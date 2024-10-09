import 'package:dine_ease/provider/user_provider.dart';
import 'package:dine_ease/view/booking/my_booking_page.dart';
import 'package:dine_ease/view/cart/cart_screen.dart';
import 'package:dine_ease/view/home/home_page.dart';
import 'package:dine_ease/view/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

ValueNotifier<int> selectedIndex = ValueNotifier(0);

class NavTabs extends StatelessWidget {
  const NavTabs({super.key});
  final List<Widget> pagesIndex = const [
    HomePage(),
    MyBookingPage(),
    CartScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    context.read<UserProvider>().getCurrentUserProfile();
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (context, value, child) {
        return Scaffold(
          body: pagesIndex[value],
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BottomNavigationBar(
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey.shade400,
              currentIndex: value,
              onTap: (value) {
                selectedIndex.value = value;
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.style_outlined),
                  label: 'Booking',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_outlined),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
