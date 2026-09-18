import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../widgets/labeled_field.dart';
import '../widgets/sheet_scaffold.dart';

class CashOutSheet extends StatefulWidget {
  const CashOutSheet({super.key});

  @override
  State<CashOutSheet> createState() => _CashOutSheetState();
}

class _CashOutSheetState extends State<CashOutSheet> {
  final _agentController = TextEditingController();
  final _amountController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _agentController.dispose();
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _submit() {
    final agent = _agentController.text.trim();
    final pin = _pinController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0;
    final state = context.read<AppState>();
    final messenger = ScaffoldMessenger.of(context);

    if (agent != AppState.correctAccountNumber || pin != AppState.correctPin) {
      messenger.showSnackBar(const SnackBar(content: Text('Agent number or PIN is incorrect.')));
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

    state.cashOut(amount);
    Navigator.pop(context);
    messenger.showSnackBar(const SnackBar(content: Text('Cash out successful.')));
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Cash Out',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: 'Agent Number',
            child: TextField(
              controller: _agentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter 11 digit number'),
            ),
          ),
          LabeledField(
            label: 'Amount',
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter amount to withdraw'),
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
          ElevatedButton(onPressed: _submit, child: const Text('Withdraw Money')),
        ],
      ),
    );
  }
}
