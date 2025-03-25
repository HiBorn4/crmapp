import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget { 
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final PageController _pageController = PageController();
  late final AuthService _authService;
  
  @override
  void initState() {
    super.initState();
    _authService = Get.find<AuthService>(); // Get the already initialized service
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image Carousel
            SizedBox(
              height: screenHeight * 0.65, // 40% of screen height
              width: screenWidth * 0.9, // 90% of screen width
              child: PageView(
                controller: _pageController,
                children: [
                  Image.asset('assets/collaborate.jpg', fit: BoxFit.cover),
                  Image.asset('assets/share_documents.jpg', fit: BoxFit.cover),
                  Image.asset('assets/track_progress.jpg', fit: BoxFit.cover),
                ],
              ),
            ),

            // Dots Indicator
            SizedBox(height: screenHeight * 0.02),
            SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: Color(0xFFDBD3FD),
                dotColor: Colors.grey[400]!,
                dotHeight: screenHeight * 0.012,
                dotWidth: screenWidth * 0.03,
              ),
            ),

            SizedBox(height: screenHeight * 0.05),

            // Sign Up Button
            SizedBox(
              width: screenWidth*0.4,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDBD3FD),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Navigate to login screen with signup mode
                  Get.to(() => LoginScreen(isSignup: true));
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: screenHeight * 0.022, color: Colors.black),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            // Login Text Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Have an account? ",
                  style: TextStyle(
                    fontSize: screenHeight * 0.02,
                    color: Colors.black, // Black text
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to login screen with login mode
                    Get.to(() => LoginScreen(isSignup: false));
                  },
                  child: Text(
  "Log In",
  style: TextStyle(
    fontSize: screenHeight * 0.02,
    color: Colors.purple, // Corrected hex color format
    fontWeight: FontWeight.bold,
  ),
),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}