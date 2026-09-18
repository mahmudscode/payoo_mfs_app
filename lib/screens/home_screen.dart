import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../sheets/add_money_sheet.dart';
import '../sheets/cash_out_sheet.dart';
import '../sheets/get_bonus_sheet.dart';
import '../sheets/pay_bill_sheet.dart';
import '../sheets/transactions_sheet.dart';
import '../sheets/transfer_money_sheet.dart';
import '../widgets/action_button.dart';
import '../widgets/responsive_page.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openSheet(BuildContext context, Widget sheet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => sheet,
    );
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final balance = context.watch<AppState>().balance;

    return Scaffold(
      body: ResponsivePage(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Image.asset('assets/images/payoo.png', height: 44, width: 44),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${balance.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const Text('Available Balance', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _logout(context),
                      icon: const Icon(Icons.logout, size: 16),
                      label: const Text('Log Out'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🔥 Welcome to Payoo!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Enjoy easy and convenient financial services with us.\n'
                        'Cashout charge is low.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
                      ),
                      const SizedBox(height: 20),
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1,
                        children: [
                          ActionButton(
                            icon: '💰',
                            label: 'Add Money',
                            onTap: () => _openSheet(context, const AddMoneySheet()),
                          ),
                          ActionButton(
                            icon: '💸',
                            label: 'Cashout',
                            onTap: () => _openSheet(context, const CashOutSheet()),
                          ),
                          ActionButton(
                            icon: '💵',
                            label: 'Transfer Money',
                            onTap: () => _openSheet(context, const TransferMoneySheet()),
                          ),
                          ActionButton(
                            icon: '🎁',
                            label: 'Get Bonus',
                            onTap: () => _openSheet(context, const GetBonusSheet()),
                          ),
                          ActionButton(
                            icon: '💳',
                            label: 'Pay Bill',
                            onTap: () => _openSheet(context, const PayBillSheet()),
                          ),
                          ActionButton(
                            icon: '🧾',
                            label: 'Transactions',
                            onTap: () => _openSheet(context, const TransactionsSheet()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
