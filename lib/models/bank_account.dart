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
  Map<String, String> customFields = {};

  List<String> toCsvRow() {
    return [
      userName,
      bankName,
      branchName,
      branchNumber,
      accountNumber,
      isSalary.toString(),
      hasCreditCard.toString(),
      isAutoWithdrawal.toString(),
      linkedApp,
      memo,
    ];
  }

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
    this.customFields = const {},
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
    'customFields': customFields,
  };
  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
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
    customFields: json['customFields'] ?? const {},
  );
}
