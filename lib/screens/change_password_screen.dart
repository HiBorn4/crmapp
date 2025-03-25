import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/password_controller.dart';

class PasswordChangeScreen extends StatelessWidget {
  final PasswordController controller = Get.put(PasswordController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Password',
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileSection(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.03),
              _buildPasswordField(
                context: context,
                label: 'Old Password',
                controller: controller,
                textController: controller.oldPasswordController,
                isHidden: controller.isOldPasswordHidden,
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildPasswordField(
                context: context,
                label: 'New Password',
                controller: controller,
                textController: controller.newPasswordController,
                isHidden: controller.isNewPasswordHidden,
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildPasswordField(
                context: context,
                label: 'Confirm Password',
                controller: controller,
                textController: controller.confirmPasswordController,
                isHidden: controller.isConfirmPasswordHidden,
                validator: (value) {
                  if (value != controller.newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.toNamed('/forgot-password'),
                  child: Text(
                    'FORGOT PASSWORD?',
                    style: TextStyle(
                      color: Colors.black, // Black text
                      fontSize: screenWidth * 0.035,
                      decoration: TextDecoration.none, // No underline
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Center(
                child: ElevatedButton(
                  onPressed: controller.saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE6E6FA), // Light Lavender
                    minimumSize: Size(screenWidth * 0.9, screenHeight * 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Sharp edges
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.black, // Black text
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.black, // Black icons and text
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Units',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 0) Get.offAllNamed('/home');
          if (index == 1) Get.offAllNamed('/project-detail');
        },
      ),
    );
  }

  /// 🔹 Profile Section Widget
  Widget _buildProfileSection(double screenWidth, double screenHeight) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Sharp corners
      ),
      child: Padding(
        padding: EdgeInsets.all(screenHeight * 0.02),
        child: Row(
          children: [
            CircleAvatar(
              radius: screenHeight * 0.06,
              backgroundImage: AssetImage('assets/profile.jpeg'),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('VISHAL KUMAR',
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('Joined on 29, Nov 2050',
                      style: TextStyle(
                        fontSize: screenHeight * 0.016,
                        color: Colors.grey,
                      )),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, size: screenHeight * 0.025),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Password Field with Eye Icon
  Widget _buildPasswordField({
    required BuildContext context,
    required String label,
    required PasswordController controller,
    required TextEditingController textController,
    required RxBool isHidden,
    FormFieldValidator<String>? validator,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Obx(() => TextFormField(
              controller: textController,
              obscureText: isHidden.value,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero, // Sharp edges
                ),
                contentPadding: EdgeInsets.all(screenWidth * 0.03),
                suffixIcon: IconButton(
                  icon: Icon(
                    isHidden.value ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    isHidden.toggle();
                  },
                ),
              ),
              validator: validator ??
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
            )),
      ],
    );
  }
}