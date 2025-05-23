import 'package:crmapp/screens/search_screen.dart';
import 'package:crmapp/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/about_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/document_screen.dart';
import 'screens/login_screen.dart';
import 'screens/modification_screen.dart';
import 'screens/refer_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/transaction_detail_screen.dart';
import 'screens/transaction_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized properly

  await Firebase.initializeApp(); // Initialize Firebase

  try {
    // final prefs = await SharedPreferences.getInstance();
    print('SharedPreferences initialized successfully');
  } catch (e) {
    print('Error initializing SharedPreferences: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRM App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(AuthService());
      }),
      initialRoute: "/",
      home: SplashScreen(),
      getPages: [
        GetPage(name: '/', page: () => SignupScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/search', page: () => SearchScreen()),
        GetPage(name: '/modification', page: () => ModificationScreen()),
        GetPage(name: '/about', page: () => AboutScreen()),
        GetPage(name: '/change-password', page: () => PasswordChangeScreen()),
        GetPage(name: '/refer', page: () => ReferScreen()),
        GetPage(name: '/document', page: () => DocumentsScreen()),
        GetPage(name: '/transaction', page: () => TransactionScreen()),
        GetPage(
          name: '/transaction-detail',
          page: () => TransactionDetailsScreen(),
        ),
      ],
    );
  }
}
