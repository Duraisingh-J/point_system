import 'package:flutter/material.dart';

class AddShop extends StatelessWidget {
  const AddShop();

  @override
  Widget build(BuildContext context) {
    final _shopNameController = TextEditingController();
    final _phNoController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
          ),
          Text('New Shop', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary), textAlign: TextAlign.center),
          SizedBox(height: 30),
          TextFormField(
            controller: _shopNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Shop Name',
              
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _phNoController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Phone Number',
              prefixText: '+91 ',
            ),
          ),
          SizedBox(height: 30),
      
        
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(onPressed: () {}, child: Text('Add Shop'))),
              
            
          
        ],
      ),
    );
  }
}
