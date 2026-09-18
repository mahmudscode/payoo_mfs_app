import 'package:flutter/foundation.dart';

import 'transaction.dart';

/// Holds the demo account balance, transaction history and the
/// hard-coded credentials used to validate every form in the app.
class AppState extends ChangeNotifier {
  static const correctPhone = '01611111111';
  static const correctLoginPin = '1234';
  static const correctAccountNumber = '12345678901';
  static const correctPin = '1234';
  static const correctPromoCode = 'PAYOO500';

  double _balance = 45000;
  double get balance => _balance;

  final List<AppTransaction> _transactions = [
    AppTransaction(title: 'Electricity Bill', time: DateTime.now()),
    AppTransaction(title: 'Bank Deposit', time: DateTime.now()),
    AppTransaction(title: 'Mobile Recharge', time: DateTime.now()),
    AppTransaction(title: 'Gas Bill', time: DateTime.now()),
  ];

  List<AppTransaction> get transactions => List.unmodifiable(_transactions);

  void _record(String title) {
    _transactions.insert(0, AppTransaction(title: title, time: DateTime.now()));
  }

  void addMoney(double amount) {
    _balance += amount;
    _record('Bank Deposit');
    notifyListeners();
  }

  void cashOut(double amount) {
    _balance -= amount;
    _record('Cash Out');
    notifyListeners();
  }

  void transferMoney(double amount) {
    _balance -= amount;
    _record('Money Transfer');
    notifyListeners();
  }

  void payBill(String billerLabel, double amount) {
    _balance -= amount;
    _record('$billerLabel Bill');
    notifyListeners();
  }

  void addBonus() {
    _balance += 500;
    _record('Bonus Credit');
    notifyListeners();
  }
}
