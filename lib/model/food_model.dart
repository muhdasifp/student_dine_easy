import 'package:cloud_firestore/cloud_firestore.dart';

class FoodModel {
  String? id;
  String? title;
  String? description;
  String? category;
  String? image;
  double? price;
  double? offer;
  bool? veg;
  int? coins;
  String? time;
  Timestamp? createdAt;

  FoodModel({
    this.id,
    this.title,
    this.description,
    this.category,
    this.image,
    this.price,
    this.offer,
    this.veg,
    this.coins,
    this.time,
    this.createdAt,
  });

  factory FoodModel.fromJson(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data()!;
    return FoodModel(
        id: doc.id,
        title: json["title"],
        description: json["description"],
        category: json["category"],
        image: json["image"],
        price: json["price"]?.toDouble(),
        offer: json["offer"]?.toDouble(),
        veg: json["veg"],
        coins: json["coins"]?.toInt(),
        time: json["time"],
        createdAt: json['created_at']);
  }

  factory FoodModel.fromMap(Map<String, dynamic> json) {
    return FoodModel(
        id: json['id'],
        title: json["title"],
        description: json["description"],
        category: json["category"],
        image: json["image"],
        price: json["price"]?.toDouble(),
        offer: json["offer"]?.toDouble(),
        veg: json["veg"],
        coins: json["coins"]?.toInt(),
        time: json["time"],
        createdAt: json['created_at']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "category": category,
        "image": image,
        "price": price,
        "offer": offer,
        "veg": veg,
        "coins": coins,
        "time": time,
        "created_at": createdAt,
      };
}
