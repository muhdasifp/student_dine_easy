import 'package:dine_ease/data/images.dart';
import 'package:dine_ease/model/food_model.dart';
import 'package:dine_ease/provider/my_provider.dart';
import 'package:dine_ease/provider/user_provider.dart';
import 'package:dine_ease/utility/helper.dart';
import 'package:dine_ease/view/cart/cart_screen.dart';
import 'package:dine_ease/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  final FoodModel food;

  const DetailsScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text("${food.category}"),
            scrolledUnderElevation: 0,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_circle_left_outlined)),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.to(() => const CartScreen());
                  },
                  icon: const Icon(Icons.shopify_outlined)),
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage("${food.image}"),
                      ),
                    ),
                  ),
                  Text(
                    "${food.title}",
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('₹${food.offer}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 12),
                      Text('₹${food.price}',
                          style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.red[200])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text("${food.description}"),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.access_time_outlined, size: 35),
                          Text('${food.time} minutes')
                        ],
                      ),
                      Column(
                        children: [
                          food.veg!
                              ? Image(
                                  image: iconVegImage, height: 35, width: 35)
                              : Image(
                                  image: iconNonVegImage,
                                  height: 35,
                                  width: 35),
                          food.veg! ? const Text("veg") : const Text("non-veg")
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(Icons.toll, color: Colors.amber, size: 35),
                          Text('${food.coins}')
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.25,
                  //   width: MediaQuery.of(context).size.width,
                  //   child: GridView.builder(
                  //     padding: const EdgeInsets.all(12),
                  //     itemCount: 4,
                  //     scrollDirection: Axis.horizontal,
                  //     gridDelegate:
                  //         const SliverGridDelegateWithFixedCrossAxisCount(
                  //       crossAxisCount: 1,
                  //       mainAxisSpacing: 10,
                  //     ),
                  //     itemBuilder: (context, index) {
                  //       return const Card();
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: CustomButton(
          button: 'Add to Cart',
          onTap: () {
            context.read<MyProvider>().toggle();
            context
                .read<UserProvider>()
                .addToCart(food)
                .then((value) => context.read<MyProvider>().toggle())
                .onError((error, stackTrace) {
              context.read<MyProvider>().toggle();
              snackMessage(
                  message: error.toString(),
                  context: context,
                  color: Colors.orange);
            });
          },
        ),
      ),
    );
  }
}
