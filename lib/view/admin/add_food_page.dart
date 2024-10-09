import 'package:dine_ease/model/food_model.dart';
import 'package:dine_ease/provider/admin_provider.dart';
import 'package:dine_ease/provider/my_provider.dart';
import 'package:dine_ease/utility/helper.dart';
import 'package:dine_ease/view/widgets/custom_button.dart';
import 'package:dine_ease/view/widgets/custom_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminAddFoodPage extends StatefulWidget {
  const AdminAddFoodPage({super.key});

  @override
  State<AdminAddFoodPage> createState() => _AdminAddFoodPageState();
}

class _AdminAddFoodPageState extends State<AdminAddFoodPage> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController offer = TextEditingController();
  TextEditingController coins = TextEditingController();
  TextEditingController time = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    price.dispose();
    offer.dispose();
    coins.dispose();
    time.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Food"),
      ),
      body: Consumer<AdminProvider>(
        builder: (_, admin, __) {
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      kIsWeb
                          ? InkWell(
                              onTap: () {
                                admin.pickImage(context);
                              },
                              child: admin.imageData != null
                                  ? Container(
                                      height: 150,
                                      width: 150,
                                      color: Colors.grey,
                                      child: Image.memory(admin.imageData!),
                                    )
                                  : const SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: Icon(Icons.image, size: 100)),
                            )
                          : InkWell(
                              onTap: () {
                                admin.pickImage(context);
                              },
                              child: admin.file != null
                                  ? Container(
                                      height: 150,
                                      width: 150,
                                      color: Colors.grey,
                                      child: Image.file(admin.file!),
                                    )
                                  : const SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: Icon(Icons.image, size: 100)),
                            ),
                      const SizedBox(height: 10),
                      CustomTextField(controller: title, label: 'title'),
                      const SizedBox(height: 10),
                      CustomTextField(
                          controller: description,
                          label: 'description',
                          maxLines: 3),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                                controller: price, label: 'price'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomTextField(
                                controller: offer, label: 'offer price'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomTextField(
                                controller: time, label: 'time'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                                controller: coins, label: 'coins'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CheckboxListTile(
                              value: admin.isVeg,
                              onChanged: (value) {
                                admin.selectVegOrNonVeg(value);
                              },
                              title: const Text("Veg"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      DropdownButton(
                        hint: const Text("Select Category"),
                        isExpanded: true,
                        value: admin.selectedCategory,
                        items: admin.availableCategory
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          admin.selectCategory(value!);
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomButton(
                        button: 'Upload',
                        onTap: () {
                          context.read<MyProvider>().toggle();
                          context
                              .read<AdminProvider>()
                              .uploadFoodModel(FoodModel(
                                description: description.text,
                                title: title.text,
                                price: double.parse(price.text),
                                offer: double.parse(offer.text),
                                time: time.text,
                                coins: int.parse(coins.text),
                              ))
                              .then((value) {
                            title.clear();
                            description.clear();
                            price.clear();
                            offer.clear();
                            coins.clear();
                            time.clear();
                            context.read<MyProvider>().toggle();
                          }).onError(
                            (error, stackTrace) {
                              context.read<MyProvider>().toggle();
                              snackMessage(
                                  message: error.toString(), context: context);
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
