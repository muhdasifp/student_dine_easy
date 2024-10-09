import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/model/cart_model.dart';
import 'package:dine_ease/model/food_model.dart';
import 'package:dine_ease/model/order_model.dart';
import 'package:dine_ease/model/user_model.dart';
import 'package:dine_ease/utility/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final _userCollection = FirebaseFirestore.instance.collection('users');
  final _orderCollection = FirebaseFirestore.instance.collection('orders');
  final User? _user = FirebaseAuth.instance.currentUser;
  late UserModel currentUser;
  int cartCount = 0;
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapStream;

  ///get current user profile and save in currentUser
  Future<void> getCurrentUserProfile() async {
    try {
      var snap = await _userCollection.doc(_user!.uid).get();
      currentUser = UserModel.fromJson(snap);
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  ///update user coins according to purchase
  Future<void> _updateUserCoin(int coins) async {
    try {
      await _userCollection.doc(currentUser.uid).update({
        "coins": FieldValue.increment(coins),
      });
    } catch (e) {
      throw e.toString();
    }
  }

  ///add to cart
  Future<void> addToCart(FoodModel food) async {
    try {
      bool result = await _checkCart(food.title!);
      if (result) {
        throw 'Already in the Cart';
      } else {
        final doc =
            _userCollection.doc(currentUser.uid).collection('carts').doc();
        final docId = doc.id;
        await doc.set(
          CartModel(id: docId, food: food).toMap(),
        );
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> incrementCart(String id) async {
    try {
      await _userCollection
          .doc(currentUser.uid)
          .collection('carts')
          .doc(id)
          .update({
        "qty": FieldValue.increment(1),
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> decrementCart(String id) async {
    try {
      await _userCollection
          .doc(currentUser.uid)
          .collection('carts')
          .doc(id)
          .update({
        "qty": FieldValue.increment(-1),
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> _checkCart(String title) async {
    try {
      return await _userCollection
          .doc(currentUser.uid)
          .collection('carts')
          .where('food.title', isEqualTo: title)
          .get()
          .then((value) => value.size > 0 ? true : false);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteCart(String id) async {
    try {
      await _userCollection
          .doc(currentUser.uid)
          .collection('carts')
          .doc(id)
          .delete();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> checkOutCart(List<CartModel> cart, double total) async {
    try {
      final doc = _orderCollection.doc();
      final docId = doc.id;

      await doc.set(
        OrderModel(
          id: docId,
          total: total.toString(),
          foods: cart,
          userName: currentUser.name,
          paymentId: generateRandomString(12),
        ).toJson(),
      );

      int totalCoins = 0;

      if (cart.isNotEmpty) {
        for (var data in cart) {
          totalCoins += data.food!.coins!;
          await _userCollection
              .doc(currentUser.uid)
              .collection('carts')
              .doc(data.id)
              .delete();
        }
        _updateUserCoin(totalCoins);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> getCartCount() async {
    await getCurrentUserProfile();
    snapStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('carts')
        .snapshots();
    snapStream.listen((event) {
      cartCount = event.docs.length;
    });
  }

  UserProvider() {
    getCartCount();
  }
}
