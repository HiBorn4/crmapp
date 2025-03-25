import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/modification_controller.dart';
import '../models/quick_action_model.dart';

class ModificationScreen extends StatelessWidget {
  final ModificationController _controller = Get.put(ModificationController());

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
            _buildTopModifications(screenWidth, screenHeight),
            _buildDescriptionSection(screenWidth, screenHeight),
            _buildHelpDeskSection(screenWidth, screenHeight),
            _buildQuickActionsSection(screenWidth, screenHeight),
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
          Text('Modification',
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
      centerTitle: true,
    );
  }

  Widget _buildTopModifications(double screenWidth, double screenHeight) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'TOP MODIFICATIONS',
        style: TextStyle(
          fontSize: screenHeight * 0.018,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: screenHeight * 0.01),
      SizedBox(
        height: screenHeight * 0.08, // Adjusted height
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _controller.categories.length,
          itemBuilder: (context, index) => _buildCategoryItem(
            screenWidth,
            screenHeight,
            _controller.categories[index],
            () => _controller.selectedCategoryIndex.value = index,
          ),
        ),
      ),
    ],
  );
}

Widget _buildCategoryItem(
    double screenWidth, double screenHeight, Map<String, dynamic> category, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: IntrinsicWidth( // Makes width dynamic based on content
      child: Container(
        margin: EdgeInsets.only(right: screenWidth * 0.02),
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(category['icon'], size: screenHeight * 0.03, color: Colors.black), // Icon on left
            SizedBox(width: screenWidth * 0.02),
            Text(
              category['label'],
              style: TextStyle(
                fontSize: screenHeight * 0.016,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildDescriptionSection(double screenWidth, double screenHeight) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: screenHeight * 0.02),
      Text(
        'DESCRIPTION',
        style: TextStyle(
          fontSize: screenHeight * 0.018,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: screenHeight * 0.01),
      TextField(
        controller: _controller.descriptionController,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: 'Describe your specification',
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none, // Removed the black border
          contentPadding: EdgeInsets.all(screenHeight * 0.015),
        ),
      ),
      SizedBox(height: screenHeight * 0.02),
      Row(
        children: [
          Row(
            children: [
              Icon(Icons.attach_file, size: screenHeight * 0.02, color: Colors.black),
              SizedBox(width: screenWidth * 0.01),
              TextButton(
                onPressed: _attachReference,
                child: Text(
                  'Attach reference',
                  style: TextStyle(
                    fontSize: screenHeight * 0.018,
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.012, 
              horizontal: screenWidth * 0.05,
            ),
            decoration: BoxDecoration(
              color: Colors.purple[100], // Light lavender
            ),
            child: GestureDetector(
              onTap: _submitModification,
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: screenHeight * 0.018,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}


  Widget _buildHelpDeskSection(double screenWidth, double screenHeight) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Heading outside the card
      Text(
        'HELP DESK',
        style: TextStyle(
          fontSize: screenHeight * 0.018,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      SizedBox(height: screenHeight * 0.01), // Small spacing

      // Rectangular Help Desk Card
      Container(
        color: Colors.white, // White background
        padding: EdgeInsets.all(screenHeight * 0.02),
        margin: EdgeInsets.only(bottom: screenHeight * 0.015),
        child: Row(
          children: [
            CircleAvatar(
              radius: screenHeight * 0.03,
              backgroundImage: AssetImage('assets/profile.jpeg'),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rohit',
                    style: TextStyle(
                      fontSize: screenHeight * 0.018,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'CRM Executive',
                    style: TextStyle(
                      fontSize: screenHeight * 0.016,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '+91 91234 56789',
                    style: TextStyle(
                      fontSize: screenHeight * 0.016,
                      fontWeight: FontWeight.bold, // Bold contact number
                      color: Colors.black, // Black color for contact number
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: screenWidth * 0.02), // Spacing before button
            OutlinedButton(
              onPressed: _contactHelpDesk,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black), // Black border
                foregroundColor: Colors.black, // Black text
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04, // Adjust width
                  vertical: screenHeight * 0.015, // Adjust height
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Rectangular shape
                ),
              ),
              child: Text(
                'Contact',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildQuickActionsSection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
          child: Text(
            'QUICK ACTIONS',
            style: TextStyle(
              fontSize: screenHeight * 0.02,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _controller.quickActions.length,
          itemBuilder: (context, index) => _buildQuickActionItem(
            screenWidth,
            screenHeight,
            _controller.quickActions[index],
          ),
        )),
      ],
    );
  }

  Widget _buildQuickActionItem(double screenWidth, double screenHeight, QuickActionModel action) {
    return Container(
      margin: EdgeInsets.all(screenWidth*0.01),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: ListTile(
        title: Text(action.title,
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.bold,
            )),
        subtitle: Text(action.description,
            style: TextStyle(
              fontSize: screenHeight * 0.015,
              color: Colors.grey,
            )),
        trailing: Icon(Icons.arrow_forward_ios, 
            size: screenHeight * 0.02),
        onTap: () => _handleQuickAction(action.title),
      ),
    );
  }

  void _handleQuickAction(String action) {
    // Implement navigation logic
  }

  void _attachReference() async {
    // Implement file attachment logic
  }

  void _submitModification() {
    if (_controller.descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter description');
      return;
    }
    // Implement submission logic
    Get.dialog(
      AlertDialog(
        title: Text('Success'),
        content: Text('Modification request submitted'),
        actions: [TextButton(onPressed: Get.back, child: Text('OK'))],
      ),
    );
  }

  void _contactHelpDesk() async {
    final url = 'tel:+919123456789';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

}