import 'dart:convert';

class BankAccount {
  String userName;
  String bankName;
  String branchName;
  String branchNumber;
  String accountNumber;
  bool isSalary;
  bool hasCreditCard;
  bool isAutoWithdrawal;
  String linkedApp;
  String memo;

  BankAccount({
    required this.userName,
    required this.bankName,
    required this.branchName,
    required this.branchNumber,
    required this.accountNumber,
    this.isSalary = false,
    this.hasCreditCard = false,
    this.isAutoWithdrawal = false,
    this.linkedApp = '',
    this.memo = '',
  });

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'bankName': bankName,
        'branchName': branchName,
        'branchNumber': branchNumber,
        'accountNumber': accountNumber,
        'isSalary': isSalary,
        'hasCreditCard': hasCreditCard,
        'isAutoWithdrawal': isAutoWithdrawal,
        'linkedApp': linkedApp,
        'memo': memo,
      };
      factory BankAccount.fromJson(Map<String, dynamic> json) 
      => BankAccount(
        userName: json['userName'],
        bankName: json['bankName'],
        branchName: json['branchName'],
        branchNumber: json['branchNumber'],
        accountNumber: json['accountNumber'],
        isSalary: json['isSalary'] ?? false,
        hasCreditCard: json['hasCreditCard'] ?? false,
        isAutoWithdrawal: json['isAutoWithdrawal'] ?? false,
        linkedApp: json['linkedApp'] ?? '',
        memo: json['memo'] ?? '',
      );
}
