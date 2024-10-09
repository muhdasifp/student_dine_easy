import 'package:dine_ease/provider/admin_provider.dart';
import 'package:dine_ease/provider/my_provider.dart';
import 'package:dine_ease/utility/helper.dart';
import 'package:dine_ease/view/admin/admin_home_page.dart';
import 'package:dine_ease/view/widgets/custom_button.dart';
import 'package:dine_ease/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 500,
            maxHeight: double.infinity,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    size: 150,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    controller: emailController,
                    label: 'email',
                    validator: (value) {
                      if (value != 'admin@gmail.com') {
                        return 'Invalid User name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: passwordController,
                    label: 'password',
                    validator: (value) {
                      if (value != 'password') {
                        return 'Invalid Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    button: "Login",
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        context.read<MyProvider>().toggle();
                        context
                            .read<AdminProvider>()
                            .adminLogin(
                                emailController.text, passwordController.text)
                            .then((value) {
                          context.read<MyProvider>().toggle();
                          Get.off(() => const AdminHomePage());
                        }).onError((error, stackTrace) {
                          context.read<MyProvider>().toggle();
                          snackMessage(
                              message: error.toString(), context: context);
                        });
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
