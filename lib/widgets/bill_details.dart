import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BillDetails extends ConsumerStatefulWidget {
  const BillDetails({super.key});

  @override
  ConsumerState<BillDetails> createState() => _BillDetailsState();
}

class _BillDetailsState extends ConsumerState<BillDetails> {
  final _shopNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       
        
      ],
    );
  }
}
