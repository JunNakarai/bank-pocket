import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bank_account.dart';
import 'account_from_screen.dart'; // ← フォーム画面をインポート

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({super.key});

  @override
  State<AccountListScreen> createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  final List<BankAccount> _accounts = [];

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountFromScreen(onAdd: _addAccount),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('口座一覧')),
      body: ListView.builder(
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
                title: Text('${account.userName} - ${account.bankName}'),
                subtitle: Text(
                  '口座番号: ${account.accountNumber}\n支店: ${account.branchName} (${account.branchNumber})',
                ),
                isThreeLine: true,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
