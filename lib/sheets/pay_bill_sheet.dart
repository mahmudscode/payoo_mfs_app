import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../widgets/labeled_field.dart';
import '../widgets/sheet_scaffold.dart';

class PayBillSheet extends StatefulWidget {
  const PayBillSheet({super.key});

  @override
  State<PayBillSheet> createState() => _PayBillSheetState();
}

class _PayBillSheetState extends State<PayBillSheet> {
  static const _billers = {
    'electricity': 'Electricity',
    'gas': 'Gas',
    'water': 'Water',
  };

  String? _biller;
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
    if (_biller == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a biller.')));
      return;
    }

    final account = _accountController.text.trim();
    final pin = _pinController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0;
    final state = context.read<AppState>();
    final messenger = ScaffoldMessenger.of(context);

    if (account != AppState.correctAccountNumber || pin != AppState.correctPin) {
      messenger.showSnackBar(const SnackBar(content: Text('Biller account number or PIN is incorrect.')));
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

    state.payBill(_billers[_biller]!, amount);
    Navigator.pop(context);
    messenger.showSnackBar(const SnackBar(content: Text('Bill paid successfully.')));
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Pay Bill',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: 'Select To Pay',
            child: DropdownButtonFormField<String>(
              initialValue: _biller,
              hint: const Text('Select biller'),
              items: _billers.entries
                  .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                  .toList(),
              onChanged: (v) => setState(() => _biller = v),
            ),
          ),
          LabeledField(
            label: 'Biller Account Number',
            child: TextField(
              controller: _accountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter account number'),
            ),
          ),
          LabeledField(
            label: 'Amount to Pay',
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Add amount to pay'),
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
          ElevatedButton(onPressed: _submit, child: const Text('Pay Now')),
        ],
      ),
    );
  }
}
