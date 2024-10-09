import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/model/cart_model.dart';
import 'package:dine_ease/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('carts')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text("No Data Found")));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          double calculateAmount() {
            double subTotal = 0.0;
            List carts = snapshot.data!.docs;
            for (var data in carts) {
              subTotal += (data['qty'] * data['food']['offer']);
            }
            return subTotal;
          }


          return Scaffold(
            appBar: AppBar(
              title: const Text('Cart'),
            ),
            body: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final cart = snapshot.data!.docs[index];
                return Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              image: NetworkImage(
                            "${cart['food']['image']}",
                          ))),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          "${cart['food']['title']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                userProvider.incrementCart(cart.id);
                              },
                              icon: const Icon(Icons.add),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${cart['qty']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                if (cart['qty'] > 1) {
                                  userProvider.decrementCart(cart.id);
                                } else {
                                  userProvider.deleteCart(cart.id);
                                }
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              "₹${cart['food']['offer']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text("Total",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text("₹${calculateAmount()}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    minWidth: double.infinity,
                    textColor: Colors.white,
                    onPressed: () {
                      var carts = snapshot.data!.docs
                          .map((e) => CartModel.fromJson(e))
                          .toList();
                      userProvider.checkOutCart(carts, calculateAmount());
                    },
                    color: Colors.green,
                    child: const Text("Check Out"),
                  ),
                  const SizedBox(height: 5),
                  calculateAmount() > 500
                      ? Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("New Voucher Unlocked",
                                  style: TextStyle(color: Colors.white)),
                              const Icon(
                                Icons.local_offer_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text('view',
                                      style: TextStyle(color: Colors.white)))
                            ],
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          );
        }
        return const Center(child: Text("Something went wrong"));
      },
    );
  }
}
