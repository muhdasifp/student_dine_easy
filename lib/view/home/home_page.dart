import 'package:dine_ease/provider/user_provider.dart';
import 'package:dine_ease/view/cart/cart_screen.dart';
import 'package:dine_ease/view/home/widgets/category_row.dart';
import 'package:dine_ease/view/home/widgets/new_launch_build.dart';
import 'package:dine_ease/view/home/widgets/slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            title: const Text("Dine Ease"),
            actions: [
              Consumer<UserProvider>(
                  builder: (context, cart, _) => Badge(
                        backgroundColor: Colors.green,
                        label: Text('${cart.cartCount}'),
                        child: IconButton(
                            onPressed: () {
                              Get.to(
                                () => const CartScreen(),
                                transition: Transition.upToDown,
                              );
                            },
                            icon: const Icon(Icons.shopping_cart_outlined)),
                      ))
              // Badge(
              //   backgroundColor: Colors.green,
              //   label: Text('${context.watch<UserProvider>().cartCount}'),
              //   child: IconButton(
              //     onPressed: () {
              //       Get.to(
              //         () => const CartScreen(),
              //         transition: Transition.upToDown,
              //       );
              //     },
              //     icon: const Icon(Icons.shopping_cart_outlined),
              //   ),
              // )
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                children: [
                  HomeSlider(size: size),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Popular Category",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const HomeCategoryRow(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("New Launch",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'see all',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  HomeNewLaunch(size: size)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
