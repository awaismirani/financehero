import 'package:financehero/controllers/webview_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'controllers/goal_controller.dart';
import 'models/goal_model.dart';
import 'views/finance/home_screen.dart';
import 'views/webview_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(GoalModelAdapter());
  Get.put(WebviewController()); // ✅ Inject FirebaseController
  Get.put(GoalController());

  runApp( SavingsGoalApp());
}

class SavingsGoalApp extends StatelessWidget {
  const SavingsGoalApp({super.key});

  @override
  Widget build(BuildContext context) {
    final WebviewController firebaseController = Get.find();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => Obx(() {
        final showWebView =
            firebaseController.web.value == "true" && firebaseController.link.value.isNotEmpty;

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Savings Goal App',
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.green,
          ),
          home: showWebView
              ? WebviewScreen(url: firebaseController.link.value)
              : DashboardScreen(),
        );
      }),
    );
  }
}
