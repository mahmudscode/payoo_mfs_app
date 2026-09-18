import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../widgets/labeled_field.dart';
import '../widgets/sheet_scaffold.dart';

class AddMoneySheet extends StatefulWidget {
  const AddMoneySheet({super.key});

  @override
  State<AddMoneySheet> createState() => _AddMoneySheetState();
}

class _AddMoneySheetState extends State<AddMoneySheet> {
  static const _banks = {
    'city-bank': 'City Bank',
    'brac-bank': 'Brac Bank',
    'dbbl': 'Dutch-Bangla Bank',
  };

  String? _bank;
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
    if (_bank == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a bank.')));
      return;
    }

    final account = _accountController.text.trim();
    final pin = _pinController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0;
    final messenger = ScaffoldMessenger.of(context);

    if (account != AppState.correctAccountNumber || pin != AppState.correctPin) {
      messenger.showSnackBar(const SnackBar(content: Text('Account number or PIN is incorrect.')));
      return;
    }
    if (amount <= 0) {
      messenger.showSnackBar(const SnackBar(content: Text('Enter a valid amount.')));
      return;
    }

    context.read<AppState>().addMoney(amount);
    Navigator.pop(context);
    messenger.showSnackBar(const SnackBar(content: Text('Money added successfully.')));
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Add Money',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: 'Select A Bank',
            child: DropdownButtonFormField<String>(
              initialValue: _bank,
              hint: const Text('Select bank'),
              items: _banks.entries
                  .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                  .toList(),
              onChanged: (v) => setState(() => _bank = v),
            ),
          ),
          LabeledField(
            label: 'Bank Account Number',
            child: TextField(
              controller: _accountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter 11 digit account number'),
            ),
          ),
          LabeledField(
            label: 'Amount to Add',
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Add amount to withdraw'),
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
          ElevatedButton(onPressed: _submit, child: const Text('Add Money')),
        ],
      ),
    );
  }
}
