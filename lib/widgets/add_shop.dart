import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:point_system/datamodel/shop.dart';
import 'package:point_system/provider/shops_provider.dart';

class AddShop extends ConsumerStatefulWidget {
  const AddShop();

  @override
  ConsumerState<AddShop> createState() => _AddShopState();
}

class _AddShopState extends ConsumerState<AddShop> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(shopLoadingProvider);
    final _shopNameController = TextEditingController();
    final _phNoController = TextEditingController();
    final _idController = TextEditingController();

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
          Text(
            'New Shop',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          TextFormField(
            controller: _shopNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Shop Name',
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _phNoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                    prefixText: '+91 ',
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ID',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),

          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : () {
               if(_shopNameController.text.isEmpty || _phNoController.text.isEmpty || _idController.text.isEmpty ) {
                  Fluttertoast.showToast(
                    msg: "Fill all fields",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  return;
                }
                if(_phNoController.text.length != 10) {
                  Fluttertoast.showToast(
                    msg: "Phone number must be 10 digits",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  return;
                }
                
                FocusScope.of(context).unfocus();
                ref
                    .read(shopsProvider.notifier)
                    .addShop(
                      Shop(
                        name: _shopNameController.text,
                        phno: _phNoController.text,
                        id: _idController.text,
                      ),
                    );
                  
                Navigator.of(context).pop();
              },
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Add Shop'),
            ),
          ),
        ],
      ),
    );
  }
}
