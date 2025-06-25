import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bank_account.dart';
import 'account_from_screen.dart'; // ← フォーム画面をインポート
import 'custom_field_settings_screen.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({super.key});

  @override
  State<AccountListScreen> createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  final List<BankAccount> _accounts = [];
  // 無料版の口座数上限
  final int _freeAccountLimit = 3;

  Future<void> _importFromCsv() async {
    // CSVインポート時の口座数チェック
    final remainingSlots = _freeAccountLimit - _accounts.length;
    
    if (remainingSlots <= 0) {
      _showAccountLimitDialog();
      return;
    }
    
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final contents = await file.readAsString();
        final rows = const CsvToListConverter().convert(contents, eol: '\n');

        final importedAccounts =
            rows.skip(1).map((row) {
              return BankAccount(
                userName: row[0],
                bankName: row[1],
                branchName: row[2],
                branchNumber: row[3],
                accountNumber: row[4],
                isSalary: row[5] == 'true',
                hasCreditCard: row[6] == 'true',
                isAutoWithdrawal: row[7] == 'true',
                linkedApp: row[8],
                memo: row[9],
                customFields: {},
              );
            }).toList();

        // 無料版の上限を超えないようにインポート
        final availableSlots = _freeAccountLimit - _accounts.length;
        
        if (importedAccounts.length > availableSlots) {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('口座数制限'),
                  content: Text('無料版では最大3口座までしか登録できません。\n${importedAccounts.length}件中${availableSlots}件のみインポートします。'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
          
          setState(() {
            _accounts.addAll(importedAccounts.take(availableSlots));
          });
        } else {
          setState(() {
            _accounts.addAll(importedAccounts);
          });
        }
        
        _saveAccounts();

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('CSVをインポートしました')));
        }
      }
    } catch (e) {
      debugPrint('csv: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('CSVのインポートに失敗しました: $e')));
      }
    }
  }

  Future<void> _exportToCsv() async {
    try {
      final rows = <List<String>>[];

      rows.add([
        'userName',
        'bankName',
        'branchName',
        'branchNumber',
        'accountNumber',
        'isSalary',
        'hasCreditCard',
        'isAutoWithdrawal',
        'linkedApp',
        'memo',
      ]);

      for (final account in _accounts) {
        rows.add(account.toCsvRow());
      }

      final csvData = const ListToCsvConverter().convert(rows);

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/accounts_export.csv');

      await file.writeAsString(csvData);

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('CSVを書き出しました: ${file.path}')));
        await Share.shareXFiles([XFile(file.path)]);
      }
    } catch (e, stack) {
      debugPrint('csv: $e');
      debugPrint('stack: $stack');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('CSVの書き出しに失敗しました: $e')));
    }
  }

  Future<void> _loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final accountJsonList = prefs.getStringList('accounts') ?? [];
    final loadedAccounts =
        accountJsonList
            .map((jsonStr) => BankAccount.fromJson(jsonDecode(jsonStr)))
            .toList();
    setState(() {
      _accounts.clear();
      _accounts.addAll(loadedAccounts);
    });
  }

  Future<void> _saveAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final accountJsonList =
        _accounts.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList('accounts', accountJsonList);
  }

  void _addAccount(BankAccount account) {
    setState(() {
      _accounts.add(account);
    });
    _saveAccounts();
  }

  void _navigateToAddScreen() {
    // 無料版の口座制限（3口座まで）
    if (_accounts.length >= _freeAccountLimit) {
      _showAccountLimitDialog();
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountFromScreen(onAdd: _addAccount),
      ),
    );
  }
  
  void _showAccountLimitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('口座数制限'),
          content: const Text('無料版では最大3口座までしか登録できません。'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('閉じる'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  void _navigateToSettingsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomFieldSettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('口座一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettingsScreen,
            tooltip: '設定',
          ),
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: _importFromCsv,
            tooltip: 'CSVインポート',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportToCsv,
            tooltip: 'CSVエクスポート',
          ),
        ],
      ),
      body: Column(
        children: [
          // 登録口座数の表示
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '登録口座数: ${_accounts.length}/$_freeAccountLimit',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _accounts.length,
              itemBuilder: (context, index) {
                final account = _accounts[index];
                return Dismissible(
                  key: Key(account.accountNumber + account.userName),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _accounts.removeAt(index);
                    });
                    _saveAccounts();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${account.bankName}　の口座を削除しました')),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(account.bankName),
                      subtitle: Text(
                        '口座番号: ${account.accountNumber}\n支店: ${account.branchName} (${account.branchNumber})',
                      ),
                      isThreeLine: true,
                      onTap: () async {
                        final updatedAccount = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AccountFromScreen(
                                  onAdd: (updated) {},
                                  initialAccount: account,
                                ),
                          ),
                        );
                        if (updatedAccount != null) {
                          setState(() {
                            _accounts[index] = updatedAccount;
                          });
                          _saveAccounts();
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}