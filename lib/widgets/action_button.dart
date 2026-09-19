import 'package:flutter/material.dart';

import '../theme/breakpoints.dart';

class ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final wide = isWideLayout(context);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: TextStyle(fontSize: wide ? 30 : 20)),
              SizedBox(height: wide ? 8 : 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: wide ? 14 : 11, color: const Color(0xFF475569)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
