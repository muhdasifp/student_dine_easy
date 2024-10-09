import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/model/redeem_model.dart';
import 'package:dine_ease/utility/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RedeemPointPage extends StatelessWidget {
  final int coins;

  const RedeemPointPage({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          bottom: PreferredSize(
              preferredSize: Size(
                double.infinity,
                size.height * 0.15,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.toll, size: 100, color: Colors.amber),
                      const SizedBox(width: 20),
                      Text(
                        "$coins",
                        style: const TextStyle(fontSize: 60),
                      )
                    ],
                  ),
                ],
              )),
          backgroundColor: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Coins",
            style: TextStyle(color: Colors.white),
          ),
          actions: const [
            Icon(CupertinoIcons.ticket_fill),
            SizedBox(width: 10),
          ],
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('redeems').get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text("NO Data Found!"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No Data Found"));
            }
            if (snapshot.hasData) {
              return GridView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.9),
                itemBuilder: (context, index) {
                  RedeemModel redeem =
                      RedeemModel.fromMap(snapshot.data!.docs[index]);
                  return Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Expanded(
                              child: Image.network("${redeem.food!.image}")),
                          Text(
                            "${redeem.food!.title}",
                            maxLines: 1,
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: redeem.point! > coins
                                ? null
                                : () {
                                    successDialog(context);
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('REDEEM',
                                    style: TextStyle(
                                        color: redeem.point! > coins
                                            ? Colors.grey
                                            : Colors.blue,
                                        fontWeight: FontWeight.bold)),
                                const Icon(Icons.toll, color: Colors.amber),
                                Text('${redeem.point}',
                                    style: TextStyle(
                                        color: redeem.point! > coins
                                            ? Colors.grey
                                            : Colors.blue,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('Something went wrong'));
          },
        ));
  }

  Future<dynamic> successDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(25),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Coupon Redeemed Successfully",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 24)),
              const SizedBox(height: 5),
              Text(
                generateRandomString(10),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
