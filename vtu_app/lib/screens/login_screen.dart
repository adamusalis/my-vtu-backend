// lib/screens/login_screen.dart

// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final ApiService _api = ApiService();
  bool _loading = false;
  String? _error;

  void _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final ok = await _api.login(_emailCtl.text.trim(), _passCtl.text);
      if (ok) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const DashboardScreen()));
      } else {
        setState(() => _error = 'Login failed');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailCtl, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: _passCtl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              child: _loading ? const CircularProgressIndicator() : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}