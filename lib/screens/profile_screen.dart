import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  final socialMediaLinks = [
    SocialMedia(icon: Icons.call, url: 'https://wa.me/919123456780'),
    SocialMedia(icon: Icons.camera, url: 'https://instagram.com'),
    SocialMedia(icon: Icons.book, url: 'https://facebook.com'),
    SocialMedia(icon: Icons.one_x_mobiledata_outlined, url: 'https://twitter.com'),
  ].obs;
}

class ProfileScreen extends StatelessWidget {
  final ProfileController _controller = Get.put(ProfileController());
  final String address = "#1, HSR Sector 1, Bangalore, Karnataka-560049";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _buildAppBar(screenWidth, screenHeight),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(screenWidth, screenHeight),
            _buildSectionTitle('ACCOUNT', screenHeight),
            _buildAccountOptions(screenWidth, screenHeight),
            _buildContactSection(screenWidth, screenHeight),
            _buildSocialMediaSection(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(double screenWidth, double screenHeight) {
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
          Text('Shuba Ecostone - 131',
              style: TextStyle(
                fontSize: screenHeight * 0.016,
              )),
        ],
      ),
    );
  }


  Widget _buildProfileSection(double screenWidth, double screenHeight) {
  return Container(
    color: Colors.white, // Ensures the background is white
    padding: EdgeInsets.all(screenHeight * 0.02),
    child: Row(
      children: [
        CircleAvatar(
          radius: screenHeight * 0.035,
          backgroundImage: AssetImage('assets/profile.jpeg'),
        ),
        SizedBox(width: screenWidth * 0.04),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures spacing
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VISHAL KUMAR',
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Joined on 29, Nov 2050',
                    style: TextStyle(
                      fontSize: screenHeight * 0.016,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.edit, size: screenHeight * 0.025), 
                  onPressed: () {},
                ),
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

  Widget _buildAccountOptions(double screenWidth, double screenHeight) {
    final options = [
      {'title': 'Change Password', 'desc': 'Update your account password'},
      {'title': 'Refer', 'desc': 'Invite friends and earn rewards'},
      {'title': 'Report', 'desc': 'Submit issues or feedback'},
      {'title': 'Logout', 'desc': 'Sign out from your account'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: options.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          title: Text(options[index]['title']!,
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                fontWeight: FontWeight.w500,
              )),
          subtitle: Text(options[index]['desc']!,
              style: TextStyle(
                fontSize: screenHeight * 0.015,
                color: Colors.grey,
              )),
          trailing: Icon(Icons.arrow_forward_ios, size: screenHeight * 0.02),
          onTap: () => _handleAccountOption(options[index]['title']!),
        ),
      ),
    );
  }

  Widget _buildContactSection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text('SUBHA',
              style: TextStyle(
                fontSize: screenHeight * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              )),
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(address,
            style: TextStyle(
              fontSize: screenHeight * 0.016,
            )),
        TextButton(
          onPressed: () => _openMap(address),
          child: Text('View in map',
              style: TextStyle(
                fontSize: screenHeight * 0.016,
                color: Colors.blue,
              )),
        ),
        SizedBox(height: screenHeight * 0.02),
        _buildSectionTitle('CONTACT US', screenHeight),
        Text('+91 91234 56780',
            style: TextStyle(
              fontSize: screenHeight * 0.016,
            )),
        Text('abc@gmail.com',
            style: TextStyle(
              fontSize: screenHeight * 0.016,
            )),
        SizedBox(height: screenHeight * 0.02),
        _buildSectionTitle('OUR WEBSITE', screenHeight),
        Text('www.subhaecoston.com',
            style: TextStyle(
              fontSize: screenHeight * 0.016,
              color: Colors.blue,
            )),
        SizedBox(height: screenHeight * 0.02),
        _buildSectionTitle('REPORT', screenHeight),
      ],
    );
  }

  Widget _buildSocialMediaSection(double screenWidth, double screenHeight) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('CONNECT WITH US', screenHeight),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _controller.socialMediaLinks
                  .map((link) => IconButton(
                        icon: Icon(link.icon, size: screenHeight * 0.04),
                        onPressed: () => _launchURL(link.url),
                      ))
                  .toList(),
            ),
          ],
        ));
  }

  void _handleAccountOption(String option) {
    switch (option) {
      case 'Change Password':
        Get.toNamed('/change-password');
        break;
      case 'Logout':
        _confirmLogout();
        break;
      // Add other cases
    }
  }

  void _confirmLogout() {
    Get.defaultDialog(
      title: 'Logout',
      content: Text('Are you sure you want to logout?'),
      confirm: TextButton(
        onPressed: () => Get.offAllNamed('/login'),
        child: Text('Yes'),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text('No'),
      ),
    );
  }

  Future<void> _openMap(String address) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<void> _launchURL(String url) async {
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