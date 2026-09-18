import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../widgets/labeled_field.dart';
import '../widgets/sheet_scaffold.dart';

class GetBonusSheet extends StatefulWidget {
  const GetBonusSheet({super.key});

  @override
  State<GetBonusSheet> createState() => _GetBonusSheetState();
}

class _GetBonusSheetState extends State<GetBonusSheet> {
  final _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _submit() {
    final promoCode = _couponController.text.trim();
    final messenger = ScaffoldMessenger.of(context);

    if (promoCode != AppState.correctPromoCode) {
      messenger.showSnackBar(const SnackBar(content: Text('Invalid promo code.')));
      return;
    }

    context.read<AppState>().addBonus();
    Navigator.pop(context);
    messenger.showSnackBar(const SnackBar(content: Text('\$500 bonus added successfully.')));
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Get Bonus',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: 'Enter Bonus Coupon',
            child: TextField(
              controller: _couponController,
              decoration: const InputDecoration(hintText: 'Enter coupon'),
            ),
          ),
          const SizedBox(height: 4),
          ElevatedButton(onPressed: _submit, child: const Text('Get Bonus')),
        ],
      ),
    );
  }
}
