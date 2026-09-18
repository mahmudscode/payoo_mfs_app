import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../widgets/labeled_field.dart';
import '../widgets/sheet_scaffold.dart';

class TransferMoneySheet extends StatefulWidget {
  const TransferMoneySheet({super.key});

  @override
  State<TransferMoneySheet> createState() => _TransferMoneySheetState();
}

class _TransferMoneySheetState extends State<TransferMoneySheet> {
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _submit() {
    final account = _accountController.text.trim();
    final pin = _pinController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0;
    final state = context.read<AppState>();
    final messenger = ScaffoldMessenger.of(context);

    if (account != AppState.correctAccountNumber || pin != AppState.correctPin) {
      messenger.showSnackBar(const SnackBar(content: Text('Invalid account number or PIN.')));
      return;
    }
    if (amount <= 0) {
      messenger.showSnackBar(const SnackBar(content: Text('Enter a valid amount.')));
      return;
    }
    if (amount > state.balance) {
      messenger.showSnackBar(const SnackBar(content: Text('Insufficient balance.')));
      return;
    }

    state.transferMoney(amount);
    Navigator.pop(context);
    messenger.showSnackBar(SnackBar(content: Text('Successfully transferred \$${amount.toStringAsFixed(2)}.')));
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Transfer Money',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: 'User Account Number',
            child: TextField(
              controller: _accountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter 11 digit number'),
            ),
          ),
          LabeledField(
            label: 'Amount',
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter amount to transfer'),
            ),
          ),
          LabeledField(
            label: 'Pin Number',
            child: TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter 4 digit pin number'),
            ),
          ),
          const SizedBox(height: 4),
          ElevatedButton(onPressed: _submit, child: const Text('Send Now')),
        ],
      ),
    );
  }
}
