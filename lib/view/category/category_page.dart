import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/data/images.dart';
import 'package:dine_ease/model/food_model.dart';
import 'package:dine_ease/provider/user_provider.dart';
import 'package:dine_ease/view/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('foods')
            .where('category', isEqualTo: category)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text("NO Data Found!"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No item Available right now in this category"),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                FoodModel data = FoodModel.fromJson(snapshot.data!.docs[index]);

                return Row(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      height: size.height * 0.12,
                      width: size.height * 0.12,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage("${data.image}"),
                          )),
                      child:
                      Image(image: iconNonVegImage, height: 20, width: 20),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        children: [
                          Text("${data.title}"),
                          Text(category),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${data.price}',
                                  style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.red)),
                              const SizedBox(width: 10),
                              Text("${data.offer}"),
                              const SizedBox(width: 15),
                              const Icon(Icons.toll, color: Colors.amber),
                              const SizedBox(width: 5),
                              Text("${data.coins} Coins"),
                            ],
                          ),
                          MaterialButton(
                            color: Colors.blueAccent,
                            height: 30,
                            minWidth: double.infinity,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            textColor: Colors.white,
                            onPressed: () {
                              context.read<UserProvider>().addToCart(data).then((value) => Get.to(()=>const CartScreen()));
                            },
                            child: const Text("Add to Cart"),
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            );
          }
          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}
