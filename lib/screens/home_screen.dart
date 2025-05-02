// ignore_for_file: invalid_use_of_protected_member, avoid_print

import 'package:crmapp/screens/overview_screen.dart';
import 'package:crmapp/screens/profile_screen.dart';
import 'package:crmapp/screens/unit_detail_screen.dart';
import 'package:crmapp/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';
import '../utils/tapered_line_painter.dart';
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(3), // Adjust height as needed
          child: CustomPaint(
            painter: TaperedLinePainter(),
            child: SizedBox(width: double.infinity),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      Responsive.getPadding(screenWidth).horizontal * 0.35,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.015),
                    _buildSummarySection(screenWidth, screenHeight, controller),
                    SizedBox(height: screenHeight * 0.025),
                    _buildCategorySection(screenHeight, screenWidth),
                  ],
                ),
              ),
            ),
            PreferredSize(
              preferredSize: Size.fromHeight(10), // Adjust height as needed
              child: CustomPaint(
                painter: TaperedLinePainter(),
                child: SizedBox(width: double.infinity),
              ),
            ),
            _buildListItemSection(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.15),
            _buildFooterSection(screenWidth),
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
          style: TextStyle(
            fontSize: Responsive.getFontSize(screenWidth, 15),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: screenHeight * 0.015),

        Obx(
          () => Row(
            children:
                controller.summaryData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 8, // small margin between cards
                      ),
                      child: SummaryItem(
                        value: item['value']!,
                        label: item['label']!,
                      ),
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
            style: TextStyle(
              fontSize: Responsive.getFontSize(screenWidth, 15),
              fontWeight: FontWeight.w500,
            ),
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
                      margin: EdgeInsets.only(right: screenWidth * 0.03),
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
        return 'Registered';
      case 2:
        return 'Allotment';
      case 3:
        return 'Agreement';
      case 4:
        return 'Possession';
      case 5:
        return 'Registration';
      default:
        return 'Category';
    }
  }

  Widget _buildCategoryItem(
    String value,
    String label,
    double screenWidth,
    int index, {
    double radius = 40, // control circle size
  }) {
    double diameter = radius * 1.6;

    return GestureDetector(
      onTap: () => controller.changeCategory(index),
      child: Obx(() {
        bool isSelected = controller.selectedCategoryIndex.value == index;
        return Column(
          children: [
            Container(
              width: diameter,
              height: diameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFFE6E0FA) : Colors.white,
                border:
                    isSelected
                        ? null
                        : Border.all(color: Colors.grey.shade300, width: 1.5),
              ),
              alignment: Alignment.center,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: radius * 0.5,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.03),
            Text(
              label,
              style: TextStyle(
                fontSize: radius * 0.3,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildListItemSection(double screenWidth, double screenHeight) {
    return Obx(() {
      final categoryIndex = controller.selectedCategoryIndex.value;

      // Handle cases where data is empty or selected category has no entries
      if (controller.categoryData.isEmpty ||
          categoryIndex >= controller.categoryData.length ||
          controller.categoryData[categoryIndex].isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/empty.png',
                  width: screenWidth,
                  height: screenHeight * 0.25,
                  fit: BoxFit.contain,
                ),
                Text(
                  'Oops No Data Found...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: screenHeight * 0.2),
              ],
            ),
          ),
        );
      }

      final categoryItems = controller.categoryData[categoryIndex];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: categoryItems.length,
            itemBuilder:
                (context, index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: screenHeight * 0.01,
                  ), // adjust spacing as needed
                  child: _buildListItem(
                    categoryItems[index],
                    screenWidth,
                    screenHeight,
                  ),
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
        padding: EdgeInsets.all(screenWidth * 0.035),
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
                  width: screenWidth * 0.14,
                  height: screenWidth * 0.14,
                  decoration: BoxDecoration(
                    color: Color(0xFFEDE9FE),
                    // borderRadius: BorderRadius.circular(8), // Use a fixed radius for squareness
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Unit No',
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        unitNo,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
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
                  Text(
                    "Shuba Ecostone",
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    "Last Activity: 180 Days",
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Row of colored dots
                Row(
                  children: [
                    _buildDot(Colors.yellow, screenWidth),
                    SizedBox(width: screenWidth * 0.01),
                    _buildDot(Colors.green, screenWidth),
                    SizedBox(width: screenWidth * 0.01),
                    _buildDot(Colors.red, screenWidth),
                  ],
                ),
                SizedBox(height: screenWidth * 0.015),

                // Due text
                Text(
                  'Due in 2 days',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenWidth * 0.01),

                // Amount
                Text(
                  '₹ $formattedAmount',
                  style: TextStyle(
                    fontSize: screenWidth * 0.038,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(Color color, double screenWidth) {
    return Container(
      width: screenWidth * 0.02,
      height: screenWidth * 0.02,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildFooterSection(double screenWidth) {
    double fontSize = Responsive.getFontSize(screenWidth, 16);
    double iconSize = screenWidth * 0.075; // Icons scale with screen width
    double titleSize = Responsive.getFontSize(screenWidth, 20);
    double shubaFontSize = Responsive.getFontSize(screenWidth, 28);
    double shubaHFontSize = Responsive.getFontSize(screenWidth, 36);

    return Container(
      color: Color(0xff191B1C),
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.05, // Dynamic vertical padding
        horizontal: screenWidth * 0.08, // Adjusted for different screens
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Shuba" with Artistic Styled "H"
          Center(
            child: Image.asset(
              'assets/shubha.png', // Replace with your actual image path
              width:
                  shubaFontSize *
                  6, // Adjust size dynamically based on font size
              fit: BoxFit.contain, // Ensures the image scales properly
            ),
          ),

          SizedBox(height: screenWidth * 0.03),
          Text(
            "address",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),

          // Address
          Text(
            "#1,HSR Sector 1, Bangalore, Karnataka-560049",
            style: GoogleFonts.outfit(
              color: Color(0xff737576),
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: screenWidth * 0.03),

          // "View in Map" Button
          GestureDetector(
            onTap: () {
              // Handle map opening
            },
            child: Text(
              "View in Map",
              style: GoogleFonts.outfit(
                color: Color(0xff737576),
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          SizedBox(height: screenWidth * 0.06),

          // Contact Info
          Text(
            "Contact Us",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: screenWidth * 0.015),

          Text(
            "+91 1234567890 || www.shubaexample.com",
            style: GoogleFonts.outfit(
              color: Color(0xff737576),
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: screenWidth * 0.07),

          Text(
            "our website",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: screenWidth * 0.07),

          // Report
          Text(
            "Report",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenWidth * 0.07),

          Center(
            child: Text(
              "connect with us",
              style: GoogleFonts.outfit(
                color: Color(0xff737576),
                fontSize: titleSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: screenWidth * 0.05),

          // Social Media Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon('assets/whatsapp.png', iconSize, () {
                // Handle WhatsApp click
              }),

              _buildSocialIcon('assets/insta.png', iconSize, () {
                // Handle Instagram click
              }),
              _buildSocialIcon('assets/x.png', iconSize, () {
                // Handle X (Twitter) click
              }),
              _buildSocialIcon('assets/fb.png', iconSize, () {
                // Handle Facebook click
              }),
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
