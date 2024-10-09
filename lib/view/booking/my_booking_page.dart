import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/provider/booking_provider.dart';
import 'package:dine_ease/provider/user_provider.dart';
import 'package:dine_ease/view/booking/booking_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyBookingPage extends StatelessWidget {
  const MyBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Booking'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('user_name', isEqualTo: user.name)
            .snapshots(),
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
              child: Text("No Booking"),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];

                return Card(
                  elevation: 2,
                  color: Colors.amber.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Booking Table:  ${data['table_no']![0].toUpperCase() + data['table_no'].substring(1)}'),
                        Text('Booking Time: ${data['book_time']}'),
                        Text('Booking Date: ${data['book_date']}'),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 35,
                              child: MaterialButton(
                                onPressed: () {
                                  context
                                      .read<BookingProvider>()
                                      .deleteMyBooking(data['id']);
                                },
                                color: Colors.red,
                                textColor: Colors.white,
                                child: const Text('Delete Booking'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 35,
                              child: MaterialButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: QrImageView(data: data['id']),
                                      ),
                                    ),
                                  );
                                },
                                color: Colors.green,
                                textColor: Colors.white,
                                child: const Text('Show QRCode'),
                              ),
                            )
                          ],
                        )
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
      floatingActionButton: OutlinedButton(
        onPressed: () => Get.to(() => const BookingPage()),
        child: const Text('Book Your Table'),
      ),
    );
  }
}
