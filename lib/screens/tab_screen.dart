import 'package:flutter/material.dart';
import 'package:point_system/screens/bill_screen.dart';
import 'package:point_system/screens/completed_bills_screen.dart';
import 'package:point_system/screens/items_screen.dart';
import 'package:point_system/screens/pending_bills_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedIndex = 0;

  Widget _selectedScreen = ItemsScreen();

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex == 0) {
      _selectedScreen = ItemsScreen();
    } else if (_selectedIndex == 1) {
      _selectedScreen = BillScreen();
    } else if (_selectedIndex == 2) {
      _selectedScreen = PendingBillsScreen();
    } else if (_selectedIndex == 3) {
      _selectedScreen = CompletedBillsScreen();
    }
    return Scaffold(
      body: _selectedScreen,

      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Items',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            label: 'Billing',
          ),

          NavigationDestination(
            icon: Icon(Icons.pending_actions_outlined),
            label: 'Pending Bills',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_outlined),
            label: 'Completed Bills',
          ),
        ],
        indicatorColor: const Color.fromARGB(255, 251, 197, 35),
        onDestinationSelected: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
