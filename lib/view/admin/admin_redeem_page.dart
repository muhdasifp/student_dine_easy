import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/model/food_model.dart';
import 'package:dine_ease/model/redeem_model.dart';
import 'package:dine_ease/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminRedeemPage extends StatefulWidget {
  const AdminRedeemPage({super.key});

  @override
  State<AdminRedeemPage> createState() => _AdminRedeemPageState();
}

class _AdminRedeemPageState extends State<AdminRedeemPage> {
  List<FoodModel> foods = [];
  FoodModel? selectedFood;
  int point = 0;

  TextEditingController pointController = TextEditingController();

  @override
  void dispose() {
    pointController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getFoodList();
    super.initState();
  }

  getFoodList() async {
    foods = await context.read<AdminProvider>().getAllFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redeem Points'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('redeems').snapshots(),
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
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                RedeemModel data =
                    RedeemModel.fromMap(snapshot.data!.docs[index]);
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${data.point}'),
                  ),
                  title: Text("${data.food!.title}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          context
                              .read<AdminProvider>()
                              .deleteRedeemOffer("${data.id}");
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            pointController.text = data.point.toString();
                            selectedFood = data.food;
                          });

                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding: const EdgeInsets.all(10),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('select food'),
                                    DropdownMenu(
                                        initialSelection: selectedFood,
                                        width: double.infinity,
                                        hintText: 'pick food',
                                        onSelected: (value) {
                                          selectedFood = value;
                                        },
                                        dropdownMenuEntries: foods
                                            .map((e) => DropdownMenuEntry(
                                                  value: e,
                                                  label: e.title.toString(),
                                                ))
                                            .toList()),
                                    const SizedBox(height: 5),
                                    const Text('enter point'),
                                    TextFormField(
                                      controller: pointController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'enter point',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    FilledButton(
                                        onPressed: () {
                                          context
                                              .read<AdminProvider>()
                                              .changeRedeemOffer(
                                                "${data.id}",
                                                RedeemModel(
                                                  food: selectedFood,
                                                  point: int.parse(
                                                    pointController.text,
                                                  ),
                                                ),
                                              )
                                              .then((value) {
                                            pointController.clear();
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text('Save'))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              insetPadding: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('select food'),
                    DropdownMenu(
                        width: double.infinity,
                        hintText: 'pick food',
                        onSelected: (value) {
                          selectedFood = value;
                        },
                        dropdownMenuEntries: foods
                            .map((e) => DropdownMenuEntry(
                                  value: e,
                                  label: e.title.toString(),
                                ))
                            .toList()),
                    const SizedBox(height: 5),
                    const Text('enter point'),
                    TextFormField(
                      controller: pointController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'enter point',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                        onPressed: () {
                          context
                              .read<AdminProvider>()
                              .addRedeemOffer(
                                RedeemModel(
                                  food: selectedFood,
                                  point: int.parse(pointController.text),
                                ),
                              )
                              .then((value) {
                            pointController.clear();
                            Navigator.pop(context);
                          });
                        },
                        child: const Text('Save'))
                  ],
                ),
              ),
            ),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.toll, color: Colors.white),
      ),
    );
  }
}
