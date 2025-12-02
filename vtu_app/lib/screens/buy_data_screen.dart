// lib/screens/buy_data_screen.dart

// lib/screens/buy_data_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BuyDataScreen extends StatefulWidget {
  const BuyDataScreen({super.key});
  @override
  State<BuyDataScreen> createState() => _BuyDataScreenState();
}

class _BuyDataScreenState extends State<BuyDataScreen> {
  final ApiService _api = ApiService();
  final _phone = TextEditingController();
  String _plan = '1GB';
  bool _loading = false;
  String? _message;

  final List<String> plans = ['500MB', '1GB', '2GB', '5GB'];

  void _buy() async {
    setState(() {
      _loading = true;
      _message = null;
    });
    try {
      // adapt /purchases/data/ and body to your backend API
      final resp = await _api.post('/purchases/data/', body: {
        'phone': _phone.text.trim(),
        'plan': _plan,
      });
      setState(() => _message = 'Success: $resp');
    } catch (e) {
      setState(() => _message = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buy Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone number')),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _plan,
            items: plans.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
            onChanged: (v) => setState(() { if (v != null) _plan = v; }),
            decoration: const InputDecoration(labelText: 'Plan'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _loading ? null : _buy,
            child: _loading ? const CircularProgressIndicator() : const Text('Buy'),
          ),
          if (_message != null) ...[
            const SizedBox(height: 12),
            Text(_message!),
          ]
        ]),
      ),
    );
  }
}