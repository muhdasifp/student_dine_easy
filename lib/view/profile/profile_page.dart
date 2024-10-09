import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/model/user_model.dart';
import 'package:dine_ease/provider/my_provider.dart';
import 'package:dine_ease/provider/user_provider.dart';
import 'package:dine_ease/service/user_service.dart';
import 'package:dine_ease/view/profile/widgets/about_page.dart';
import 'package:dine_ease/view/profile/widgets/contact_us_page.dart';
import 'package:dine_ease/view/profile/widgets/delete_account.dart';
import 'package:dine_ease/view/profile/widgets/order_page.dart';
import 'package:dine_ease/view/profile/widgets/redeem_point_page.dart';
import 'package:dine_ease/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final provider = Provider.of<MyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${userProvider.currentUser.name} !"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(userProvider.currentUser.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("No Data Found"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final user = UserModel.fromJson(snapshot.data!);
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    child: Text(
                      user.email![0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(
                      Icons.toll_outlined,
                      color: Colors.yellow,
                    ),
                    title: const Text('Points'),
                    trailing: Text(
                      '${user.coins}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => OrderPage(userName: '${user.name}'),
                          transition: Transition.leftToRightWithFade);
                    },
                    leading: const Icon(Icons.food_bank_outlined),
                    title: const Text("Orders"),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => RedeemPointPage(
                            coins: user.coins!,
                          ));
                    },
                    leading: const Icon(Icons.local_offer_outlined),
                    title: const Text('Redeem Coins'),
                  ),
                  ListTile(
                    onTap: () => Get.to(() => const AboutPage()),
                    leading: const Icon(Icons.error_outline),
                    title: const Text('About us'),
                  ),
                  ListTile(
                    onTap: () => Get.to(() => const ContactUsPage()),
                    leading: const Icon(Icons.live_help_outlined),
                    title: const Text('Contact us'),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => const DeleteUserAccount());
                    },
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Delete Account'),
                  ),
                  const Spacer(),
                  CustomButton(
                    button: 'Logout',
                    onTap: () {
                      provider.toggle();
                      UserService()
                          .logoutUser()
                          .then((value) => provider.toggle())
                          .onError((error, stackTrace) => provider.toggle());
                    },
                  )
                ],
              ),
            );
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
