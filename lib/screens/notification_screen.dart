// import 'package:crmapp/widgets/footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
// import '../utils/responsive.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // final String uid;
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    // controller.initialize(uid);

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
                    // _buildProfileSection(controller, screenWidth, screenHeight),
                    // SizedBox(height: screenHeight*0.02,),
                    _buildSectionTitle('PERMISSION', screenHeight, screenWidth),
                    buildAccount(controller, screenWidth, screenHeight),
                    // SizedBox(height: screenHeight*0.3,),
                  ],
                ),
              ),
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
            'Notifications',
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
    itemCount: controller.notificationOptions.length,
    itemBuilder: (context, index) {
      final option = controller.notificationOptions[index];
      final title = option['title']!;
      final isLogout = title.toLowerCase() == 'logout';

      return Obx(() {
        final isChecked = controller.accountOptionStates[title] ?? false;

        return Container(
          margin: EdgeInsets.all(screenWidth * 0.01),
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              vertical: isLogout ? screenHeight * 0.01 : 0,
              horizontal: screenWidth * 0.04,
            ),
            title: Text(
              title,
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
            trailing: isLogout
                ? Icon(Icons.exit_to_app, size: screenHeight * 0.022)
                : Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      if (value != null) {
                        controller.toggleAccountOption(title, value);
                      }
                    },
                  ),
            onTap: () {
              if (isLogout) {
                controller.handleAccountOption(title);
              }
            },
          ),
        );
      });
    },
  );
}

}
