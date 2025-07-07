import 'package:flutter/material.dart';

class BillScreen extends StatelessWidget {
  const BillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billing Section', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Center(
        child: Text(
          'Bill Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
