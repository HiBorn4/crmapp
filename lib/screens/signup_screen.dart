import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Carousel
            SizedBox(
              height: screenHeight * 0.7, // 50% of screen height
              child: PageView(
                controller: _pageController,
                children: [
                  Image.asset('assets/collaborate.jpg', fit: BoxFit.cover),
                  Image.asset('assets/share_documents.jpg', fit: BoxFit.cover),
                  Image.asset('assets/track_progress.jpg', fit: BoxFit.cover),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Dots Indicator
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

            // Login Button
            SizedBox(
              width: screenWidth * 0.5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDBD3FD),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.to(() => LoginScreen());
                },
                child: Text(
                  "Log In",
                  style: TextStyle(
                    fontSize: screenHeight * 0.022,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
