import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/model/cart_model.dart';

class OrderModel {
  String? id;
  String? userName;
  String? paymentId;
  String? total;
  Timestamp? createdAt;
  String? status;
  List<CartModel>? foods;

  OrderModel({
    this.id,
    this.userName,
    this.paymentId,
    this.total,
    this.createdAt,
    this.status,
    this.foods,
  });

  factory OrderModel.fromJson(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data()!;
    return OrderModel(
      id: doc.id,
      userName: json['user_name'],
      paymentId: json['payment_id'],
      total: json['total'],
      createdAt: json['createdAt'],
      status: json['status'],
      foods: json['foods'] == null
          ? []
          : List<CartModel>.from(
              json['foods']!.map((e) => CartModel.fromMap(e))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id ?? "",
        "user_name": userName ?? "",
        "payment_id": paymentId ?? "",
        "total": total ?? "",
        "createdAt": createdAt ?? DateTime.now(),
        "status": status ?? "pending",
        "foods": foods != null ? foods!.map((e) => e.toMap()) : [],
      };
}
