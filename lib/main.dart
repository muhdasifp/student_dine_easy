import 'package:dine_ease/data/theme.dart';
import 'package:dine_ease/provider/admin_provider.dart';
import 'package:dine_ease/provider/booking_provider.dart';
import 'package:dine_ease/provider/my_provider.dart';
import 'package:dine_ease/provider/user_provider.dart';
import 'package:dine_ease/service/notification_service.dart';
import 'package:dine_ease/view/landing/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationPermissionService().initLocalNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  // initialize the widgets using runApp()
  runApp(const MyApp());
}

// class MyApp we created
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // initialize the provider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MyProvider()),
      ],
      // GetMaterialAPp is a widget.
      // it provide navigation between two widgets and provide theme like all necessary things.
      child: GetMaterialApp(
        title: 'Dine Ease',
        theme: myTheme,
        home: const LandingPage(),
      ),
    );
  }
}
