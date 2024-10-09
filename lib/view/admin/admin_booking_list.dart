import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminBookingList extends StatelessWidget {
  const AdminBookingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booked Tables"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('bookings')
            .orderBy('book_date')
            .get(),
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
              child: Text("No Booking Yet!"),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                return Card(
                  color: Colors.white,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text("id:${data.id}"),
                        Text("user name:${data['user_name']}"),
                        Text("user number:${data['user_number']}"),
                        Text("booking time:${data['book_time']}"),
                        Text("booing date:${data['book_date']}"),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text("Something went wrong"),
          );
        },
      ),
    );
  }
}
