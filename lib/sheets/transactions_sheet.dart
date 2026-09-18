import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../widgets/sheet_scaffold.dart';
import '../widgets/transaction_tile.dart';

class TransactionsSheet extends StatelessWidget {
  const TransactionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<AppState>().transactions;

    return SheetScaffold(
      title: 'Transaction History',
      trailing: TextButton(
        onPressed: () {},
        child: const Text('View All', style: TextStyle(fontSize: 12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: transactions.map((t) => TransactionTile(transaction: t)).toList(),
      ),
    );
  }
}
