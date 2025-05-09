import 'package:crmapp/widgets/footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../utils/responsive.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    controller.initialize(widget.uid);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
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
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileSection(controller, screenWidth, screenHeight),
                    SizedBox(height: screenHeight*0.02,),
                    _buildSectionTitle('ACCOUNT', screenHeight, screenWidth),
                    buildAccount(controller, screenWidth, screenHeight),
                    SizedBox(height: screenHeight*0.3,),
                  ],
                ),
              ),
              Footer(screenWidth),
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(
    ProfileController controller,
    double screenHeight,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, size: screenHeight * 0.025),
        onPressed: () => Get.back(),
      ),
      title: Column(
        children: [
          Text(
            'My Profile',
            style: TextStyle(
              fontSize: screenHeight * 0.022,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            controller.userData['projectName'] ?? '',
            style: TextStyle(fontSize: screenHeight * 0.016),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(
    ProfileController controller,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: screenHeight * 0.035,
            backgroundImage: AssetImage(
              controller.userData['profileImage'] ?? 'assets/profile.jpeg',
            ),
          ),
          SizedBox(width: screenWidth * 0.05),
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
                      (controller.userData['roles'] as List<dynamic>?)?.join(
                            ', ',
                          ) ??
                          'No rles',
                      style: TextStyle(
                        fontSize: screenHeight * 0.016,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.edit_outlined, size: screenHeight * 0.025),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: screenWidth*0.01),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenHeight * 0.015,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget buildAccount(
  ProfileController controller,
  double screenWidth,
  double screenHeight,
) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: controller.accountOptions.length,
    itemBuilder: (context, index) {
      final option = controller.accountOptions[index];
      final isLogout = option['title']!.toLowerCase() == 'logout';

      return Container(
        margin: EdgeInsets.all(screenWidth * 0.01),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            vertical: isLogout ? screenHeight * 0.01 : 0,
            horizontal: screenWidth * 0.04,
          ),
          title: Text(
            option['title']!,
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: isLogout
              ? null
              : Text(
                  option['desc']!,
                  style: TextStyle(
                    fontSize: screenHeight * 0.015,
                    color: Colors.grey,
                  ),
                ),
          trailing: Icon(
          Icons.arrow_forward_ios, // Logout icon
            size: screenHeight * 0.02,
          ),
          onTap: () => controller.handleAccountOption(option['title']!),
        ),
      );
    },
  );
}
}
