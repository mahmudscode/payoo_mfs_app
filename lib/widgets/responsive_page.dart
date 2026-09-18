import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Lays the app out as a plain, full-height page.
///
/// On a phone it simply fills the screen. On a wider (desktop/web) viewport
/// the content is centered in a fixed-width column instead of being
/// stretched edge to edge - there is no phone-frame/bezel mockup here,
/// just a normal responsive web layout.
class ResponsivePage extends StatelessWidget {
  final Widget child;
  final Color contentColor;

  const ResponsivePage({
    super.key,
    required this.child,
    this.contentColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppTheme.background,
      child: SizedBox.expand(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: ColoredBox(
              color: contentColor,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
