import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/model/food_model.dart';

class CartModel {
  String? id;
  FoodModel? food;
  int? qty;

  CartModel({
    this.id,
    this.food,
    this.qty = 1,
  });

  factory CartModel.fromJson(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data()!;
    return CartModel(
      id: doc.id,
      food: FoodModel.fromMap(json['food']),
      qty: json['qty'],
    );
  }

  factory CartModel.fromMap(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      food: FoodModel.fromMap(json['food']),
      qty: json['qty'],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "food": food!.toJson(),
        "qty": qty,
      };
}
