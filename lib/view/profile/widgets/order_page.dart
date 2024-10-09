import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/model/order_model.dart';
import 'package:dine_ease/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class OrderPage extends StatefulWidget {
  final String userName;

  const OrderPage({super.key, required this.userName});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapStream;

  final orderBox = GetStorage();

  @override
  void initState() {
    snapStream = FirebaseFirestore.instance
        .collection('orders')
        .where('user_name', isEqualTo: widget.userName)
        .orderBy('createdAt', descending: true)
        .snapshots();
    sendNotification();
    super.initState();
  }

  sendNotification() {
    String lastOrder = orderBox.read('last_order') ?? "";
    snapStream.listen((event) {
      if (lastOrder != event.docs.first['id']) {
        event.docs.first['status'] == 'completed'
            ? NotificationPermissionService()
                .sendSimpleNotification(event.docs.last['id'])
            : null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
      ),
      body: StreamBuilder(
        stream: snapStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("Data not Found"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Order Yet"));
          }
          if (snapshot.hasData) {
            List<OrderModel> orders =
                snapshot.data!.docs.map((e) => OrderModel.fromJson(e)).toList();
            List<OrderModel> completed = orders
                .where((element) => element.status == 'completed')
                .toList();
            List<OrderModel> pending =
                orders.where((element) => element.status == 'pending').toList();
            orderBox.write('last_order', '${orders.first.id}');
            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    dividerHeight: 0,
                    tabs: [
                      tabTitle(text: 'Pending'),
                      tabTitle(text: 'Completed'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    child: TabBarView(
                      children: [
                        _PendingOrders(pending: pending),
                        _CompletedOrders(completed: completed),
                      ],
                    ),
                  )
                ],
              ),
            );
          }

          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }

  Widget tabTitle({required String text}) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

//separate both pending order and complete orders in different tabs
class _CompletedOrders extends StatelessWidget {
  const _CompletedOrders({required this.completed});

  final List<OrderModel> completed;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: completed.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("order id: ${completed[index].id}"),
                ...List.generate(
                  completed[index].foods!.length,
                  (i) => Text(
                    "${i + 1}.${completed[index].foods![i].food!.title} x ${completed[index].foods![i].qty}",
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${completed[index].total} only/-"),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PendingOrders extends StatelessWidget {
  const _PendingOrders({required this.pending});

  final List<OrderModel> pending;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: pending.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("order id: ${pending[index].id}"),
                ...List.generate(
                  pending[index].foods!.length,
                  (i) => Text(
                    "${i + 1}.${pending[index].foods![i].food!.title} x ${pending[index].foods![i].qty}",
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${pending[index].total} only/-"),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
