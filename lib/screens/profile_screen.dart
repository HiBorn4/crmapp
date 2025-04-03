import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../utils/responsive.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;

  const ProfileScreen({required this.uid});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    controller.initialize(uid);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _buildAppBar(controller, screenHeight),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileSection(controller, screenWidth, screenHeight),
                    _buildSectionTitle('ACCOUNT', screenHeight),
                    _buildAccountOptions(controller, screenHeight),
                  ],
                ),
              ),
                    _buildFooterSection(screenWidth, screenHeight),
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(ProfileController controller, double screenHeight) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, size: screenHeight * 0.025),
        onPressed: () => Get.back(),
      ),
      title: Column(
        children: [
          Text('My Profile',
              style: TextStyle(
                fontSize: screenHeight * 0.022,
                fontWeight: FontWeight.bold,
              )),
          Text(controller.userData['projectName'] ?? '',
              style: TextStyle(
                fontSize: screenHeight * 0.016,
              )),
        ],
      ),
    );
  }

  Widget _buildProfileSection(ProfileController controller, double screenWidth, double screenHeight) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(screenHeight * 0.02),
      child: Row(
        children: [
          CircleAvatar(
            radius: screenHeight * 0.035,
            backgroundImage: AssetImage(controller.userData['profileImage'] ?? 'assets/profile.jpeg'),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.userData['name'] ?? 'Nameless',
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      controller.userData['userRole'] ?? 'No Role',
                      style: TextStyle(
                        fontSize: screenHeight * 0.016,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.edit, size: screenHeight * 0.025), 
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
      child: Text(title,
          style: TextStyle(
            fontSize: screenHeight * 0.018,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          )),
    );
  }

  Widget _buildAccountOptions(ProfileController controller, double screenHeight) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.accountOptions.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          title: Text(controller.accountOptions[index]['title']!,
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                fontWeight: FontWeight.w500,
              )),
          subtitle: Text(controller.accountOptions[index]['desc']!,
              style: TextStyle(
                fontSize: screenHeight * 0.015,
                color: Colors.grey,
              )),
          trailing: Icon(Icons.arrow_forward_ios, size: screenHeight * 0.02),
          onTap: () => controller.handleAccountOption(controller.accountOptions[index]['title']!),
        ),
      ),
    );
  }

  Widget _buildFooterSection(double screenWidth, double screenHeight) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.03,
        horizontal: screenWidth * 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/shubha.png',
              width: screenWidth * 0.6,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Address',
            style: TextStyle(
              color: Colors.white,
              fontSize: Responsive.getFontSize(screenWidth, 16),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '1234, Random Street, City Name, Country',
            style: TextStyle(
              color: Colors.white,
              fontSize: Responsive.getFontSize(screenWidth, 14),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.01),
          GestureDetector(
            onTap: () => _launchMap(),
            child: Text(
              'View in Map',
              style: TextStyle(
                color: Colors.grey,
                fontSize: Responsive.getFontSize(screenWidth, 14),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Contact Us',
            style: TextStyle(
              color: Colors.white,
              fontSize: Responsive.getFontSize(screenWidth, 18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            '+91 1234567890 || www.shubaexample.com',
            style: TextStyle(
              color: Colors.white,
              fontSize: Responsive.getFontSize(screenWidth, 14),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Report',
            style: TextStyle(
              color: Colors.white,
              fontSize: Responsive.getFontSize(screenWidth, 18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon('assets/whatsapp.png', screenWidth * 0.06, () => _launchWhatsApp()),
              _buildSocialIcon('assets/insta.png', screenWidth * 0.06, () => _launchInstagram()),
              _buildSocialIcon('assets/x.png', screenWidth * 0.06, () => _launchTwitter()),
              _buildSocialIcon('assets/fb.png', screenWidth * 0.06, () => _launchFacebook()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath, double size, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size * 0.2),
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void _launchMap() {
    // Implement map launch functionality
  }

  void _launchWhatsApp() {
    // Implement WhatsApp launch functionality
  }

  void _launchInstagram() {
    // Implement Instagram launch functionality
  }

  void _launchTwitter() {
    // Implement Twitter launch functionality
  }

  void _launchFacebook() {
    // Implement Facebook launch functionality
  }
}