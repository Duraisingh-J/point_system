import 'package:flutter/material.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Center(
        child: Text('Add Item Screen'),
      ),
      bottomNavigationBar: null,
    );
  }
}