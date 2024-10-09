import 'package:dine_ease/provider/my_provider.dart';
import 'package:dine_ease/service/notification_service.dart';
import 'package:dine_ease/service/user_service.dart';
import 'package:dine_ease/utility/helper.dart';
import 'package:dine_ease/view/admin/admin_login.dart';
import 'package:dine_ease/view/auth/register_page.dart';
import 'package:dine_ease/view/home/nav_tab.dart';
import 'package:dine_ease/view/widgets/custom_button.dart';
import 'package:dine_ease/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    Get.offAll(() => const AdminLoginPage());
                  },
                  icon: const Icon(
                    Icons.admin_panel_settings_outlined,
                    color: Colors.red,
                  ))
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Welcome",
                      style:
                          TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("New User ?"),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const RegisterPage());
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    button: "Login",
                    onTap: () {
                      provider.toggle();
                      UserService()
                          .loginUser(
                              emailController.text, passwordController.text)
                          .then((value) {
                        provider.toggle();
                        Get.offAll(() => const NavTabs());
                      }).onError((error, stackTrace) {
                        provider.toggle();
                        snackMessage(
                            message: error.toString(), context: context);
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
