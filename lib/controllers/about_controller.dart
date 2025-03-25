import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutController extends GetxController {
  final firstNameController = TextEditingController(text: 'VISHAL');
  final lastNameController = TextEditingController(text: 'KUMAR');
  final emailController = TextEditingController(text: 'vishal123@gmail.com');
  final phoneController = TextEditingController(text: '+91 91234 56780');
  final formKey = GlobalKey<FormState>();
  var currentNavIndex = 2.obs;

  void saveProfile() {
    if (formKey.currentState!.validate()) {
      Get.snackbar('Success', 'Profile updated successfully');
      Get.back();
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  void changeNavIndex(int index) {
    currentNavIndex.value = index;
    switch (index) {
      case 0:
        Get.offAllNamed('/home');
        break;
      case 1:
        Get.offAllNamed('/units');
        break;
      case 2:
        break;
    }
  }
}