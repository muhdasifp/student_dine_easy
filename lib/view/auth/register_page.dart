import 'package:dine_ease/provider/my_provider.dart';
import 'package:dine_ease/service/user_service.dart';
import 'package:dine_ease/utility/helper.dart';
import 'package:dine_ease/view/home/nav_tab.dart';
import 'package:dine_ease/view/widgets/custom_button.dart';
import 'package:dine_ease/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Hello",
                      style:
                          TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: nameController,
                    label: 'user name',
                    prefix: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: emailController,
                    label: 'email',
                    prefix: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: passwordController,
                    label: 'password',
                    prefix: const Icon(Icons.lock_outline),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: numberController,
                    label: 'number',
                    prefix: const Icon(Icons.call_outlined),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    button: "Register",
                    onTap: () {
                      provider.toggle();
                      UserService()
                          .registerNewUser(
                              emailController.text,
                              passwordController.text,
                              nameController.text,
                              numberController.text)
                          .then((value) {
                        provider.toggle();
                        Get.offAll(() => const NavTabs());
                      }).onError((error, stackTrace) {
                        snackMessage(
                            message: error.toString(), context: context);
                        provider.toggle();
                      });
                    },
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Text(
                      "Already have an account",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
