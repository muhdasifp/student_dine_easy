import 'package:dine_ease/service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteUserAccount extends StatefulWidget {
  const DeleteUserAccount({super.key});

  @override
  State<DeleteUserAccount> createState() => _DeleteUserAccountState();
}

class _DeleteUserAccountState extends State<DeleteUserAccount> {
  TextEditingController deleteController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? currentUserEmail = FirebaseAuth.instance.currentUser!.email;

  bool isValid = true;

  startTimer() async {
    setState(() => isValid = false);
    await Future.delayed(const Duration(days: 1), () {
      setState(() => isValid = true);
    });
  }

  @override
  void dispose() {
    deleteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete your Account'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Doy you want to delete your account!?'),
                  const SizedBox(height: 12),
                  Form(
                    key: formKey,
                    child: TextFormField(
                      validator: (value) {
                        setState(() => isValid = true);
                        if (value != currentUserEmail) {
                          startTimer();
                          return 'email address not match';
                        }
                        return null;
                      },
                      controller: deleteController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'enter your email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: isValid
                        ? () {
                            if (formKey.currentState!.validate()) {
                              UserService().deleteUser();
                            }
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                        isValid ? 'Delete My Account' : "try after 24 hour"),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "this process is not reversible your account and points are deleted permanently",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.redAccent.shade400,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
