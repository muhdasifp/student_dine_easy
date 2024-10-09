import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? name;
  String? email;
  String? number;
  String? password;
  int? coins;
  String? address;

  UserModel({
    this.uid,
    this.name,
    this.number,
    this.email,
    this.password,
    this.coins,
    this.address,
  });

  factory UserModel.fromJson(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data()!;
    return UserModel(
      uid: doc.id,
      name: json["name"],
      number: json["number"],
      email: json["email"],
      password: json["password"],
      coins: json["coins"],
      address: json["address"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "number": number,
        "password": password,
        "coins": coins ?? 0,
        "address": address??"",
      };
}
