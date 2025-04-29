// ignore_for_file: invalid_use_of_protected_member, avoid_print

import 'package:crmapp/screens/overview_screen.dart';
import 'package:crmapp/screens/profile_screen.dart';
import 'package:crmapp/screens/unit_detail_screen.dart';
import 'package:crmapp/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/summary_item.dart';
import '../utils/responsive.dart';
import 'package:intl/intl.dart'; // Add this at the top

class HomeScreen extends StatefulWidget {
  final String userUid;

  HomeScreen({required this.userUid});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController controller;
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      HomeController(uid: widget.userUid),
    ); // Pass UID to controller

    // Initialize pages after controller is set
    _pages = [
      HomeContent(userUid: widget.userUid),
      SearchScreen(),
      OverviewScreen(),
      ProfileScreen(uid: widget.userUid),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/home.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 0 ? Colors.black : Colors.grey,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/search.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 1 ? Colors.black : Colors.grey,
            ),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/units.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 2 ? Colors.black : Colors.grey,
            ),
            label: "Units",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/profile.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 3 ? Colors.black : Colors.grey,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final String userUid;

  HomeContent({required this.userUid});
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            SizedBox(width: screenWidth * 0.03),
            ClipOval(
              child: Image.asset(
                'assets/home_profile.png',
                width: screenWidth * 0.11,
                height: screenWidth * 0.11,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreetingMessage(),
              style: TextStyle(
                fontSize: Responsive.getFontSize(screenWidth, 18),
              ),
            ),
            Text(
              controller.userData['name'] ?? 'Nameless',
              style: TextStyle(
                fontSize: Responsive.getFontSize(screenWidth, 20),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey[100],
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      Responsive.getPadding(screenWidth).horizontal * 0.35,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummarySection(screenWidth, screenHeight, controller),
                    SizedBox(height: screenHeight * 0.02),
                    _buildCategorySection(screenHeight, screenWidth),
                    SizedBox(height: screenHeight * 0.01),
                    // Obx(
                    // () =>
                    _buildListItemSection(screenWidth, screenHeight),
                    // ),
                  ],
                ),
              ),
            ),
            _buildFooterSection(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  String _getGreetingMessage() {
    int hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning...!";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon...!";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening...!";
    } else {
      return "Good Night...!";
    }
  }

  Widget _buildSummarySection(
    double screenWidth,
    double screenHeight,
    HomeController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UNIT SUMMARY',
          style: TextStyle(fontSize: Responsive.getFontSize(screenWidth, 14)),
        ),
        SizedBox(height: screenHeight * 0.015),

        Obx(
          () => Row(
            children:
                controller.summaryData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;

                  return Expanded(
                    child: SummaryItem(
                      value: item['value']!,
                      label: item['label']!,
                      screenWidth: screenWidth,
                      isFirst: index == 0,
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(double screenHeight, double screenWidth) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CATEGORY',
            style: TextStyle(fontSize: Responsive.getFontSize(screenWidth, 14)),
          ),
          SizedBox(height: screenHeight * 0.015),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  controller.categoryData.value.asMap().entries.map((entry) {
                    final index = entry.key;
                    final categoryItems = entry.value;
                    final value = categoryItems.length.toString();
                    final label = _getCategoryLabel(index);
                    return Container(
                      margin: EdgeInsets.only(right: screenWidth * 0.02),
                      child: _buildCategoryItem(
                        value,
                        label,
                        screenWidth,
                        index,
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(int index) {
    switch (index) {
      case 0:
        return 'Booked';
      case 1:
        return 'Allotment';
      case 2:
        return 'Agreement';
      case 3:
        return 'Construction';
      case 4:
        return 'Registration';
      case 5:
        return 'Possession';
      default:
        return 'Category';
    }
  }

  Widget _buildCategoryItem(
    String value,
    String label,
    double screenWidth,
    int index,
  ) {
    return GestureDetector(
      onTap: () => controller.changeCategory(index),
      child: Obx(
        () => Container(
          width: screenWidth * 0.23,
          padding: EdgeInsets.all(screenWidth * 0.02),
          decoration: BoxDecoration(
            color:
                controller.selectedCategoryIndex.value == index
                    ? Color(0xFFE6E0FA)
                    : Colors.white,
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color:
                      controller.selectedCategoryIndex.value == index
                          ? Colors.black
                          : Colors.grey,
                ),
              ),
              SizedBox(height: screenWidth * 0.01),
              Text(
                label,
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  color:
                      controller.selectedCategoryIndex.value == index
                          ? Colors.black
                          : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItemSection(double screenWidth, double screenHeight) {
    return Obx(() {
      final categoryIndex = controller.selectedCategoryIndex.value;

      // Add null check and handle empty state
      if (controller.categoryData.value.isEmpty ||
          categoryIndex >= controller.categoryData.value.length) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/empty.png', // replace with your image path
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 16),
              Text(
                'No data available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      final categoryItems = controller.categoryData.value[categoryIndex];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: categoryItems.length,
            separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0),
            itemBuilder:
                (context, index) => _buildListItem(
                  categoryItems[index],
                  screenWidth,
                  screenHeight,
                ),
          ),
        ],
      );
    });
  }

  Widget _buildListItem(
    Map<String, dynamic> item,
    double screenWidth,
    double screenHeight,
  ) {
    final unitNo = item['unit_no']?.toString() ?? 'N/A';
    final name =
        item['customerDetailsObj']?['customerName1']?.toString() ?? 'N/A';
    final contact =
        item['customerDetailsObj']?['phoneNo1']?.toString() ?? 'No Contact';
    final amount = item['T_total']?.toString() ?? '₹ 0';
    final projectUid = item['uid']?.toString() ?? 'UID';
    final double parsedAmount =
        double.tryParse(amount.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
    final int roundedAmount = parsedAmount.ceil();
    final formattedAmount = NumberFormat(
      '#,##,##0',
      'en_IN',
    ).format(roundedAmount);

    return GestureDetector(
      onTap: () => Get.to(() => UnitDetailScreen(projectUid, widget.userUid)),
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: screenWidth * 0.1,
                  height: screenWidth * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(screenWidth * 0.06),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    unitNo,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  'Unit No',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    contact,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Text(
            //   amount,
            //   style: TextStyle(
            //     fontSize: screenWidth * 0.04,
            //   ),
            // ),
            Text(
              '₹ $formattedAmount',
              style: TextStyle(fontSize: screenWidth * 0.03),
            ),

            SizedBox(width: screenWidth * 0.05),
          ],
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
              _buildSocialIcon(
                'assets/whatsapp.png',
                screenWidth * 0.06,
                () => _launchWhatsApp(),
              ),
              _buildSocialIcon(
                'assets/insta.png',
                screenWidth * 0.06,
                () => _launchInstagram(),
              ),
              _buildSocialIcon(
                'assets/x.png',
                screenWidth * 0.06,
                () => _launchTwitter(),
              ),
              _buildSocialIcon(
                'assets/fb.png',
                screenWidth * 0.06,
                () => _launchFacebook(),
              ),
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
