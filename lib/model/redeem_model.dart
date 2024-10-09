import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/model/food_model.dart';

class RedeemModel {
  String? id;
  FoodModel? food;
  int? point;

  RedeemModel({this.id, this.food, this.point});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'food': food!.toJson(),
      'point': point,
    };
  }

  factory RedeemModel.fromMap(DocumentSnapshot<Map<String, dynamic>> map) {
    final json = map.data()!;
    return RedeemModel(
      id: map.id,
      food: FoodModel.fromMap(json['food']),
      point: json['point'] as int,
    );
  }
}
