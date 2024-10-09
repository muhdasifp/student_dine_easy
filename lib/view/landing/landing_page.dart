import 'package:dine_ease/utility/internet_connection_service.dart';
import 'package:dine_ease/view/admin/admin_home_page.dart';
import 'package:dine_ease/view/auth/login_page.dart';
import 'package:dine_ease/view/home/nav_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    chechUserStatus();
    super.initState();
  }

  chechUserStatus() async {
    await Future.delayed(const Duration(seconds: 2), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Get.offAll(() => const LoginPage());
        } else if (user.uid == "2TERwR6j8OTuTe6gjmLbpzVBFqi2") {
          Get.offAll(() => const AdminHomePage());
        } else {
          Get.offAll(() => const NavTabs());
        }
      });
    });
    Get.put<ConnectivityController>(ConnectivityController());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Landing Page"),
      ),
    );
  }
}
