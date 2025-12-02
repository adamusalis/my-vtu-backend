// lib/screens/dashboard_screen.dart

// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'buy_data_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _api = ApiService();
  String _profile = 'Not loaded';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    try {
      final profile = await _api.get('/users/me/'); // change endpoint
      setState(() => _profile = profile.toString());
    } catch (e) {
      setState(() => _profile = 'Error: $e');
    }
  }

  void _logout() async {
    await _api.logout();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [ IconButton(onPressed: _logout, icon: const Icon(Icons.logout)) ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Profile:'),
            const SizedBox(height: 8),
            Text(_profile),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BuyDataScreen())),
              icon: const Icon(Icons.data_usage),
              label: const Text('Buy Data / Airtime'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _loadProfile,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh profile'),
            ),
          ],
        ),
      ),
    );
  }
}