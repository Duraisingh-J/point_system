import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CompleteBilling extends ConsumerStatefulWidget {
  const CompleteBilling({super.key});

  @override
  ConsumerState<CompleteBilling> createState() => _CompleteBillingState();
}

class _CompleteBillingState extends ConsumerState<CompleteBilling> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ElevatedButton.icon(
              onPressed: () {
                // Logic to complete the billing process
                // This could involve saving the bill, clearing the cart, etc.
                Fluttertoast.showToast(msg: "Billing completed successfully!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.white38,
                  textColor: Colors.black,
                  fontSize: 16.0,
                );
              },
              icon: Icon(Icons.print, size: 30),
              label: Text('Print', style: TextStyle(fontSize: 20, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                // ignore: deprecated_member_use
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.share, size: 30)),
        ],
      ),
    );
  }
}