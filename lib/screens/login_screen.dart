// File: screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final bool isSignup;

  const LoginScreen({Key? key, this.isSignup = false}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _isChecked = false;

  final TextEditingController _emailController =
      TextEditingController(text: "test@example.com"); // Default Email
  final TextEditingController _passwordController =
      TextEditingController(text: "Pass123"); // Default Password

  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = Get.find<AuthService>(); // Get the already initialized service
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleContinue() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // LOGIN FLOW
      final user = await _authService.signIn(email, password);

      if (user != null) {
        // Email Verified → Go to Home
        if (user.emailVerified) {
          Get.offAllNamed('/home');
        } else {
          // Email not verified → Send OTP
          await _authService.sendOTP();
          Get.toNamed('/otp', arguments: {'email': email});
        }
      }
    } catch (e) {
      print("🔥 Login Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Black Header (40% of screen)
                      Container(
                        height: screenHeight * 0.4,
                        width: double.infinity,
                        color: Colors.black,
                        padding: EdgeInsets.only(left: 20, bottom: 30),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Customer App\nTell us your login\ndetails.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // White Section
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          padding:
                              EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: screenHeight * 0.03),

                              // Email Field
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              // Password Field
                              TextField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.03),

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFDBD3FD),
                                    padding:
                                        EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  // onPressed: _handleContinue,
                                  onPressed: () => Get.toNamed('/home'),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.05,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.03),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
