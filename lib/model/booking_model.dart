import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String? id;
  String? tableNo;
  String? bookTime;
  String? bookDate;
  String? userName;
  String? userNumber;
  String? status;

  BookingModel({
    this.id,
    this.tableNo,
    this.bookTime,
    this.bookDate,
    this.userName,
    this.userNumber,
    this.status,
  });

  factory BookingModel.fromJson(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data()!;
    return BookingModel(
      id: doc.id,
      tableNo: json["table_no"],
      bookTime: json["book_time"],
      bookDate: json["book_date"],
      userName: json["user_name"],
      userNumber: json["user_number"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "table_no": tableNo,
        "book_time": bookTime,
        "book_date": bookDate,
        "user_name": userName,
        "user_number": userNumber,
        "status": status ?? "",
      };
}
