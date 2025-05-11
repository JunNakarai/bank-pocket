import 'package:flutter/material.dart';
import '../models/bank_account.dart';

class AccountFromScreen extends StatefulWidget {
  final void Function(BankAccount) onAdd;
  final BankAccount? initialAccount;

  const AccountFromScreen({
    super.key,
    required this.onAdd,
    this.initialAccount,
  });

  @override
  State<AccountFromScreen> createState() => _AccountFromScreenState();
}

class _AccountFromScreenState extends State<AccountFromScreen> {
  final _formKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _branchNameController = TextEditingController();
  final _branchNumberController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _linkedAppController = TextEditingController();
  final _memoController = TextEditingController();

  bool _isSalary = false;
  bool _hasCreditCard = false;
  bool _isAutoWithdrawal = false;

  @override
  void initState() {
    super.initState();
    final a = widget.initialAccount;
    if (a != null) {
      _userNameController.text = a.userName;
      _bankNameController.text = a.bankName;
      _branchNameController.text = a.branchName;
      _branchNumberController.text = a.branchNumber;
      _accountNumberController.text = a.accountNumber;
      _linkedAppController.text = a.linkedApp;
      _memoController.text = a.memo;
      _isSalary = a.isSalary;
      _hasCreditCard = a.hasCreditCard;
      _isAutoWithdrawal = a.isAutoWithdrawal;
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
    _branchNumberController.dispose();
    _accountNumberController.dispose();
    _memoController.dispose();
    super.dispose();
  }
  void _submit() {
    if (_formKey.currentState!.validate()){
      final account = BankAccount(
        userName: _userNameController.text,
        bankName: _bankNameController.text,
        branchName: _branchNameController.text,
        branchNumber: _branchNumberController.text,
        accountNumber: _accountNumberController.text,
        isSalary: _isSalary,
        hasCreditCard: _hasCreditCard,
        isAutoWithdrawal: _isAutoWithdrawal,
        linkedApp: _linkedAppController.text,
        memo: _memoController.text,
      );
      if (widget.initialAccount != null) {
        Navigator.pop(context, account);
      } else {
        widget.onAdd(account);
        Navigator.pop(context);
      }
    
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Account')),
      body: Padding(
   padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(labelText: 'ユーザー名'),
                validator: (v) => v!.isEmpty ? '必須項目です' : null,
              ),
              TextFormField(
                controller: _bankNameController,
                decoration: const InputDecoration(labelText: '銀行名'),
                validator: (v) => v!.isEmpty ? '必須項目です' : null,
              ),
              TextFormField(
                controller: _branchNameController,
                decoration: const InputDecoration(labelText: '支店名'),
              ),
              TextFormField(
                controller: _branchNumberController,
                decoration: const InputDecoration(labelText: '支店番号'),
              ),
              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(labelText: '口座番号'),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                title: const Text('給与振込口座'),
                value: _isSalary,
                onChanged: (value) => setState(() => _isSalary = value!),
              ),
              CheckboxListTile(
                title: const Text('クレジットカード'),
                value: _hasCreditCard,
                onChanged: (value) => setState(() => _hasCreditCard = value!),
              ),
              CheckboxListTile(
                title: const Text('自動引き落とし'),
                value: _isAutoWithdrawal,
                onChanged:
                    (value) => setState(() => _isAutoWithdrawal = value!),
              ),
              TextFormField(
                controller: _linkedAppController,
                decoration: const InputDecoration(labelText: '連携アプリ'),
              ),
              TextFormField(
                controller: _memoController,
                decoration: const InputDecoration(labelText: 'メモ'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _submit, child: const Text('追加する')),
            ],
          ),
        ),
      ),
    );
  }
}
