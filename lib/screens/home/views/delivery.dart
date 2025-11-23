import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'payment.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  static const routeName = '/delivery';

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  static const _deliveryStatusKey = 'delivery_started';

  double _progress = 0.0;
  String _statusText = 'Checking payment status...';
  bool _deliveryStarted = false;
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final started = prefs.getBool(_deliveryStatusKey) ?? false;

    if (!mounted) return;

    setState(() {
      _deliveryStarted = started;
      _isLoading = false;
      _progress = started ? _progress : 0.0;
      _statusText = started
          ? 'Delivery started — your scoops are on the way!'
          : 'Complete payment to unlock live delivery tracking.';
    });

    if (started) {
      _startProgress();
    } else {
      _timer?.cancel();
    }
  }

  void _startProgress() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _progress = (_progress + 0.18).clamp(0.0, 1.0);
        if (_progress >= 1.0) {
          _statusText = 'Delivered — enjoy your ice-cream!';
          timer.cancel();
        } else {
          _statusText = 'On the way • ${(_progress * 100).round()}%';
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery tracker'),
        backgroundColor: Colors.pinkAccent.shade100,
      ),
      backgroundColor: Colors.pink.shade50,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ice-cream status',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.pink.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Watch your order move from the freezer to your doorstep in real time.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: _deliveryStarted ? _progress : 0.0,
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(12),
                      backgroundColor: Colors.pink.shade50,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _progress >= 1.0
                            ? Colors.green
                            : Colors.pinkAccent.shade200,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _statusText,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh status'),
                    onPressed: _isLoading ? null : _loadStatus,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.payment),
                    label: const Text('Go to payment'),
                    onPressed: () {
                      Navigator.of(context).pushNamed(PaymentScreen.routeName);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}