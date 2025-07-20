import 'package:flutter/material.dart';
import 'package:point_system/screens/search_screen.dart';
import 'package:point_system/widgets/add_shop.dart';
import 'package:point_system/widgets/bill_details.dart';

class BillScreen extends StatelessWidget {
  const BillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Billing Section',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                isDismissible: true,
                isScrollControlled: true,
                useSafeArea: true,
                context: context,
                builder: (ctx) => Padding(
                  padding: EdgeInsetsGeometry.only(
                    bottom: MediaQuery.of(ctx).viewInsets.bottom ,
                  ),
                  child: SizedBox(
                    height: 400, // Adjust this value as needed
                    child: AddShop(),
                  ),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(children: [SearchScreen(), BillDetails()]),
    );
  }
}
