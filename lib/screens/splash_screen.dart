import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final authService = Get.find<AuthService>();
    final isValid = await authService.isSessionValid();

    await Future.delayed(Duration(seconds: 1)); // Optional splash delay

    if (authService.isLoggedIn && isValid) {
      Get.off(() => HomeScreen(userUid: authService.user!.uid));
    } else {
      if (authService.isLoggedIn) await authService.signOut();
      Get.off(() => SignupScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}