import 'package:flutter/widgets.dart';

/// Viewport width at which the app switches from the single-column mobile
/// layout to the desktop/web layout (sidebar, dashboard, dialogs).
const double kWideBreakpoint = 900;

bool isWideLayout(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= kWideBreakpoint;
