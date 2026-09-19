import 'package:flutter/widgets.dart';

import '../sheets/add_money_sheet.dart';
import '../sheets/cash_out_sheet.dart';
import '../sheets/get_bonus_sheet.dart';
import '../sheets/pay_bill_sheet.dart';
import '../sheets/transactions_sheet.dart';
import '../sheets/transfer_money_sheet.dart';

/// One tile on the home screen: an emoji, a label and the form it opens.
class HomeAction {
  final String icon;
  final String label;
  final Widget sheet;

  const HomeAction({required this.icon, required this.label, required this.sheet});
}

const homeActions = [
  HomeAction(icon: '💰', label: 'Add Money', sheet: AddMoneySheet()),
  HomeAction(icon: '💸', label: 'Cashout', sheet: CashOutSheet()),
  HomeAction(icon: '💵', label: 'Transfer Money', sheet: TransferMoneySheet()),
  HomeAction(icon: '🎁', label: 'Get Bonus', sheet: GetBonusSheet()),
  HomeAction(icon: '💳', label: 'Pay Bill', sheet: PayBillSheet()),
  HomeAction(icon: '🧾', label: 'Transactions', sheet: TransactionsSheet()),
];
