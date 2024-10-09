import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/model/booking_model.dart';
import 'package:dine_ease/utility/helper.dart';
import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  final _bookingCollection = FirebaseFirestore.instance.collection('bookings');

  String bookingTime = '';
  String bookingTable = '';

  List<String> bookedTimes = [];
  List<String> bookedTables = [];

  List<String> availableTimes = [];

  List<BookingModel> allBookings = [];

  List<String> dropdownTimeList = [
    '11.00AM',
    '12.00PM',
    '01.00PM',
    '02.00PM',
    '03.00PM',
    '04.00PM',
  ];

  Future<void> getAllBookings() async {
    try {
      var snap = await _bookingCollection.get();
      allBookings = snap.docs.map((e) => BookingModel.fromJson(e)).toList();

      List<BookingModel> todayBooking = allBookings
          .where((element) => element.bookDate == dateFormatter(DateTime.now()))
          .toList();
      checkAvailability(todayBooking);
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  void checkAvailability(List<BookingModel> bookings) {
    bookedTables = bookings.map((e) => e.tableNo!).toList();
    bookedTimes = bookings.map((e) => e.bookTime!).toList();
    availableTimes = dropdownTimeList
        .where((element) => !bookedTimes.contains(element))
        .toList();
    notifyListeners();
  }

  ///book table
  Future<void> bookTable(String bookId, String name, String number) async {
    try {
      if (bookingTable != '' && bookingTime != '') {
        await _bookingCollection.doc(bookId).set(
              BookingModel(
                id: bookId,
                bookDate: dateFormatter(DateTime.now()),
                bookTime: bookingTime,
                tableNo: bookingTable,
                userName: name,
                userNumber: number,
              ).toJson(),
            );
        bookingTime = '';
        bookingTable = '';
        notifyListeners();
      } else {
        throw Exception('Please select table and time');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  /// for deleting booking slot it helps to books another user
  Future<void> deleteMyBooking(String docId) async {
    try {
      await _bookingCollection.doc(docId).delete();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  ///to select particular table
  void selectMyTable(String table) {
    bookingTable = table;
    notifyListeners();
  }

  ///to select particular time
  void selectMyTime(String time) {
    bookingTime = time;
    notifyListeners();
  }
}
