import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  static const routeName = '/payment';

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const _deliveryStatusKey = 'delivery_started';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _isProcessing = false;
  bool _paymentCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadExistingStatus();
  }

  Future<void> _loadExistingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final started = prefs.getBool(_deliveryStatusKey) ?? false;
    if (!mounted) return;
    setState(() {
      _paymentCompleted = started;
    });
  }

  Future<void> _handlePayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_deliveryStatusKey, true);

    if (!mounted) return;

    setState(() {
      _paymentCompleted = true;
      _isProcessing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment complete! Delivery started.'),
      ),
    );
  }

  Future<void> _resetPayment() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_deliveryStatusKey);
    if (!mounted) return;
    setState(() {
      _paymentCompleted = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual payment'),
        backgroundColor: Colors.pinkAccent.shade100,
      ),
      backgroundColor: Colors.pink.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name on card',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _cardController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Card number',
                          ),
                          maxLength: 16,
                          validator: (value) {
                            if (value == null || value.length < 12) {
                              return 'Enter a valid card number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _expiryController,
                                decoration: const InputDecoration(
                                  labelText: 'Expiry (MM/YY)',
                                ),
                                validator: (value) {
                                  if (value == null || value.length != 5) {
                                    return 'MM/YY';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _cvvController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'CVV',
                                ),
                                maxLength: 3,
                                validator: (value) {
                                  if (value == null || value.length != 3) {
                                    return 'CVV';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_paymentCompleted)
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Payment already completed. Tap reset to simulate another order.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: _isProcessing
                            ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Icon(Icons.lock),
                        label: Text(
                          _paymentCompleted ? 'Paid' : 'Pay now',
                        ),
                        onPressed:
                        _paymentCompleted || _isProcessing ? null : _handlePayment,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Reset'),
                        onPressed: _paymentCompleted ? _resetPayment : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}