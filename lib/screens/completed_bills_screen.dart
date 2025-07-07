import 'package:flutter/material.dart';

class CompletedBillsScreen extends StatelessWidget {
  const CompletedBillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Bills', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Center(
        child: Text(
          'Completed Bills',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }

}