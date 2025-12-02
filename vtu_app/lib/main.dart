// lib/main.dart

// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'services/api_service.dart';
import 'constants/api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // If you want to auto-redirect to dashboard if token exists,
  // you can implement a splash that checks ApiService.getToken()
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VTU App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StartRouter(),
    );
  }
}

class StartRouter extends StatefulWidget {
  const StartRouter({super.key});
  @override
  State<StartRouter> createState() => _StartRouterState();
}

class _StartRouterState extends State<StartRouter> {
  final ApiService _api = ApiService();
  bool _loading = true;
  bool _hasToken = false;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  void _checkToken() async {
    final token = await _api.getToken();
    setState(() {
      _hasToken = token != null && token.isNotEmpty;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return _hasToken ? const DashboardScreen() : const LoginScreen();
  }
}