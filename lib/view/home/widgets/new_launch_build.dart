import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/data/images.dart';
import 'package:dine_ease/model/food_model.dart';
import 'package:dine_ease/view/details/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeNewLaunch extends StatelessWidget {
  final Size size;

  const HomeNewLaunch({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.42,
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('foods')
            .orderBy('created_at')
            .limit(6)
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
              child: Text("No item Available right now"),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: () {
                      Get.to(
                        () => DetailsScreen(food: FoodModel.fromJson(data)),
                        transition: Transition.upToDown,
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(data['image']),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['title'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "₹${data['price']}",
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  data['coins'].toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Icon(Icons.toll, color: Colors.amber),
                                const SizedBox(width: 20),
                                data['veg']
                                    ? Image(
                                        image: iconVegImage,
                                        height: 20,
                                        width: 20)
                                    : Image(
                                        image: iconNonVegImage,
                                        height: 20,
                                        width: 20),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
