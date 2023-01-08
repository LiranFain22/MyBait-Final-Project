import 'package:flutter/material.dart';
import 'package:mybait/widgets/app_drawer.dart';

class PaymentScreen extends StatelessWidget {
  static const routeName = '/payment';

  PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      drawer: AppDrawer(),
    );
  }
}