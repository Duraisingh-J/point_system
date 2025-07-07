import 'package:flutter/material.dart';

class PendingBillsScreen extends StatelessWidget {
  const PendingBillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Bills', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Center(
        child: Text(
          'Pending Bills',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }

}
