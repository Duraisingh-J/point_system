import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:point_system/widgets/add_shop.dart';
import 'package:point_system/widgets/bill_details.dart';
import 'package:point_system/widgets/search_shop.dart';

class BillScreen extends ConsumerStatefulWidget {
  const BillScreen({super.key});

  @override
  ConsumerState<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends ConsumerState<BillScreen> {
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
                    bottom: MediaQuery.of(ctx).viewInsets.bottom,
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
      body: Stack(
        children: [
          
          Positioned(top: 100, left: 0, right: 0, child: BillDetails()),
          SearchShop(),
        ],
      ),
    );
  }
}
