import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/model/order_model.dart';
import 'package:dine_ease/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminOrderPage extends StatelessWidget {
  const AdminOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Order"),
        leading: IconButton(
          onPressed: () {
            context.read<AdminProvider>().logoutAdmin();
          },
          icon: const Icon(Icons.logout),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy("createdAt", descending: true)
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
              child: Text("No Order Yet!"),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                OrderModel data =
                    OrderModel.fromJson(snapshot.data!.docs[index]);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${data.userName}",
                          style:
                              const TextStyle(fontSize: 18, color: Colors.blue),
                        ),
                        Text(
                          "${data.createdAt!.toDate()}",
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(
                      data.foods!.length,
                      (i) {
                        return Text(
                            "${i + 1}.${data.foods![i].food!.title} -- ${data.foods![i].qty}");
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total:	₹${data.total}"),
                        Text(
                          "Order Status:	₹${data.status}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                        onPressed: data.status == 'completed'
                            ? null
                            : () {
                                context
                                    .read<AdminProvider>()
                                    .completeOrder(data.id!);
                              },
                        child: const Text('Prepared')),
                    const Divider(),
                  ],
                );
              },
            );
          }
          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}
