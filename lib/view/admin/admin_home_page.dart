import 'package:dine_ease/view/admin/add_food_page.dart';
import 'package:dine_ease/view/admin/admin_booking_list.dart';
import 'package:dine_ease/view/admin/admin_order_page.dart';
import 'package:dine_ease/view/admin/admin_redeem_page.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int index = 0;
  final List<Widget> _pages = const [
    AdminOrderPage(),
    AdminAddFoodPage(),
    AdminRedeemPage(),
    AdminBookingList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: double.infinity,
        ),
        child: Scaffold(
          body: _pages[index],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: index,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fastfood_outlined),
                label: 'Add Foods',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.point_of_sale),
                label: 'Redeem coins',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border),
                label: 'Booking',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
