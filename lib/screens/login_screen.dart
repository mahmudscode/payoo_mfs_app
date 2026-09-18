import 'package:flutter/material.dart';

import '../models/app_state.dart';
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

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
