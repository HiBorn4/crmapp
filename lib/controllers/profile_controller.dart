import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User Data Observables
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // Profile Data
  final RxList<Map<String, String>> accountOptions = <Map<String, String>>[
    {'title': 'Change Password', 'desc': 'Update your account password'},
    {'title': 'Refer', 'desc': 'Invite friends and earn rewards'},
    {'title': 'Report', 'desc': 'Submit issues or feedback'},
    {'title': 'Logout', 'desc': 'Sign out from your account'},
  ].obs;

  final RxList<SocialMedia> socialMediaLinks = <SocialMedia>[
    SocialMedia(icon: Icons.call, url: 'https://wa.me/919123456780'),
    SocialMedia(icon: Icons.camera, url: 'https://instagram.com'),
    SocialMedia(icon: Icons.book, url: 'https://facebook.com'),
    SocialMedia(icon: Icons.one_x_mobiledata_outlined, url: 'https://twitter.com'),
  ].obs;

  // Initialize profile with UID
  Future<void> initialize(String uid) async {
    await fetchUserProfile(uid);
  }

  /// Fetch user profile from Firestore
  Future<void> fetchUserProfile(String uid) async {
    try {
      isLoading(true);
      errorMessage('');

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        // Extract fields with default values
        String userName = data['name'] ?? 'Nameless';
        List<dynamic>? roles = data['roles'];
        String userRole = (roles != null && roles.isNotEmpty) ? roles[0] : 'No Role';

        userData.value = {
          'name': userName,
          'role': userRole,
          'roles': List<String>.from(roles ?? []),
          'email': data['email'] ?? 'No Email',
          'phone': data['perPh'] ?? 'No Phone',
          'company': data['orgName'] ?? 'No Company',
          'address': data['address'] ?? 'No Address',
        };

        print("User Data: Name - $userName, Role - $userRole");
      } else {
        errorMessage.value = 'User data not found.';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching user profile: $e';
      print(errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  /// Handle account options
  void handleAccountOption(String option) {
    switch (option) {
      case 'Change Password':
        Get.toNamed('/change-password');
        break;
      case 'Logout':
        _confirmLogout();
        break;
      case 'Report':
        _handleReport();
        break;
      case 'Refer':
        _handleRefer();
        break;
    }
  }

  void _confirmLogout() {
    Get.defaultDialog(
      title: 'Logout',
      content: const Text('Are you sure you want to logout?'),
      confirm: TextButton(
        onPressed: () => Get.offAllNamed('/login'),
        child: const Text('Yes'),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('No'),
      ),
    );
  }

  void _handleReport() {
    // Implement report functionality
  }

  void _handleRefer() {
    // Implement refer functionality
  }

  /// Open Google Maps
  Future<void> openMap() async {
    final String address = userData['address'] ?? 'No Address';
    final url = 'https://www.google.com/maps/search/?api=1&query=$address';

    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  /// Launch Social Media
  Future<void> launchSocialMedia(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}

class SocialMedia {
  final IconData icon;
  final String url;

  SocialMedia({required this.icon, required this.url});
}
