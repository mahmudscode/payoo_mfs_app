import 'package:flutter/material.dart';

import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/breakpoints.dart';
import '../widgets/responsive_page.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  bool _obscurePin = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _login() {
    final phone = _phoneController.text.trim();
    final pin = _pinController.text.trim();

    if (phone == AppState.correctPhone && pin == AppState.correctLoginPin) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
  }

  List<Widget> _formFields() {
    return [
      const Text('Phone Number', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
      const SizedBox(height: 4),
      TextField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(hintText: 'Phone Number'),
      ),
      const SizedBox(height: 16),
      const Text('Your Pin', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
      const SizedBox(height: 4),
      TextField(
        controller: _pinController,
        obscureText: _obscurePin,
        keyboardType: TextInputType.number,
        onSubmitted: (_) => _login(),
        decoration: InputDecoration(
          hintText: 'Pin',
          suffixIcon: IconButton(
            icon: Icon(_obscurePin ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscurePin = !_obscurePin),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () {},
          child: const Text('Forgot pin?'),
        ),
      ),
      const SizedBox(height: 8),
      ElevatedButton(onPressed: _login, child: const Text('Login')),
    ];
  }

  Widget _buildWide() {
    return Row(
      children: [
        const Expanded(flex: 5, child: _BrandPanel()),
        Expanded(
          flex: 4,
          child: ColoredBox(
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Welcome back',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Log in to manage your Payoo account.',
                        style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 32),
                      ..._formFields(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isWideLayout(context)) {
      return Scaffold(body: _buildWide());
    }

    return Scaffold(
      body: ResponsivePage(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/images/payoo.png', height: 72),
                const SizedBox(height: 16),
                const Text(
                  'Welcome to Payoo',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 28),
                ..._formFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Left-hand branding half of the desktop login screen.
class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  static const _points = [
    ('💰', 'Add money from your bank in seconds'),
    ('💸', 'Cash out and transfer with low charges'),
    ('💳', 'Pay electricity, gas and water bills'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(64),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.accent, Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset('assets/images/payoo.png', height: 56, width: 56),
          ),
          const SizedBox(height: 32),
          const Text(
            'Payoo',
            style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Easy and convenient financial services, all in one place.',
            style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 40),
          for (final (icon, text) in _points)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(text, style: const TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
