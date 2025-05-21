// ignore_for_file: invalid_use_of_protected_member, avoid_print

import 'package:crmapp/screens/overview_screen.dart';
import 'package:crmapp/screens/profile_screen.dart';
import 'package:crmapp/screens/unit_detail_screen.dart';
import 'package:crmapp/screens/search_screen.dart';
import 'package:crmapp/widgets/footer.dart';
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

const HomeScreen({super.key, required this.userUid});

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
'assets/icons/home1.png',
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
'assets/icons/overall.png',
width: 24,
height: 24,
color: _selectedIndex == 2 ? Colors.black : Colors.grey,
),
label: "Overall",
),
BottomNavigationBarItem(
icon: Image.asset(
'assets/icons/tasks.png',
width: 24,
height: 24,
color: _selectedIndex == 3 ? Colors.black : Colors.grey,
),
label: "Tasks",
),
],
),
);
}
}

class HomeContent extends StatefulWidget {
final String userUid;

const HomeContent({super.key, required this.userUid});
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
backgroundColor: Colors.white,
leading: Row(
children: [
SizedBox(width: screenWidth * 0.03),
GestureDetector(
onTap: () {
Get.to(() => ProfileScreen(uid: widget.userUid));
},
child: ClipOval(
child: Image.asset(
'assets/home_profile.png',
width: screenWidth * 0.11,
height: screenWidth * 0.11,
fit: BoxFit.cover,
),
),
),
],
),
title: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
_getGreetingMessage(),
style: GoogleFonts.outfit(
fontSize: Responsive.getFontSize(screenWidth, 18),
),
),
Text(
controller.userData['name'] ?? 'Nameless',
style: GoogleFonts.outfit(
fontSize: Responsive.getFontSize(screenWidth, 20),
fontWeight: FontWeight.bold,
),
),
],
),
// bottom: PreferredSize(
// preferredSize: Size.fromHeight(3), // Adjust height as needed
// child: CustomPaint(
// painter: TaperedLinePainter(),
// child: SizedBox(width: double.infinity),
// ),
// ),
),
body: SingleChildScrollView(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Center(
child: Container(
width: screenHeight * 0.35,
height: 1,
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.centerLeft,
end: Alignment.centerRight,
colors: [
Colors.transparent,
Colors.grey.shade400,
Colors.transparent,
],
),
),
),
),
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
_buildListItemSection(screenWidth, screenHeight),
SizedBox(height: screenHeight * 0.15),
Footer(screenWidth),
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
Padding(
padding: const EdgeInsets.only(left: 6.0),
child: Text(
'UNIT SUMMARY',
style: GoogleFonts.outfit(
fontSize: Responsive.getFontSize(screenWidth, 15),
fontWeight: FontWeight.w500,
color: Color(0xff606062),
),
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
Padding(
padding: const EdgeInsets.only(left: 6.0),
child: Text(
'CATEGORY',
style: GoogleFonts.outfit(
fontSize: Responsive.getFontSize(screenWidth, 15),
fontWeight: FontWeight.w500,
color: Color(0xff606062)
),
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
color: isSelected ? const Color(0xffEDE9FE) : Colors.white,
border:
isSelected
? null
: Border.all(color: Colors.grey.shade300, width: 1.5),
),
alignment: Alignment.center,
child: Text(
value,
style: GoogleFonts.outfit(
fontSize: radius * 0.5,
fontWeight: FontWeight.w600,
color: isSelected ? const Color(0xff0E0A1F) : Colors.grey,
),
),
),
SizedBox(height: screenWidth * 0.03),
Text(
label,
style: GoogleFonts.outfit(
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
style: GoogleFonts.outfit(
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
bottom: screenHeight * 0.002,
left: 10,
right: 10
), 
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
style: GoogleFonts.outfit(
fontSize: screenWidth * 0.03,
color: Color(0xff0E0A1F),
fontWeight: FontWeight.w400,
),
),
Text(
unitNo,
style: GoogleFonts.outfit(
color: Color(0xff0E0A1F),
fontSize: screenWidth * 0.035,
fontWeight: FontWeight.w500,
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
style: GoogleFonts.openSans(
fontSize: screenWidth * 0.04,
fontWeight: FontWeight.w600,
color: Color(0xff0E0A1F),
),
),
Text(
"Shuba Ecostone",
style: GoogleFonts.openSans(
fontSize: screenWidth * 0.03,
color: Color(0xff606062),
fontWeight: FontWeight.w400,
),
),
Text(
"Last Activity: 180 Days",
style: GoogleFonts.openSans(
fontSize: screenWidth * 0.03,
color: Color(0xff606062),
fontWeight: FontWeight.w400
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
_buildDot(Color(0xffEAB300), screenWidth),
SizedBox(width: screenWidth * 0.01),
_buildDot(Color(0xff1B6600), screenWidth),
SizedBox(width: screenWidth * 0.01),
_buildDot(Color(0xff960000), screenWidth),
],
),
SizedBox(height: screenWidth * 0.015),

// Due text
Text(
'Due in 2 days',
style: GoogleFonts.outfit(
color: Color(0xff960000),
fontSize: screenWidth * 0.03,
fontWeight: FontWeight.w400,
),
),
SizedBox(height: screenWidth * 0.01),

// Amount
Text(
'₹ $formattedAmount',
style: GoogleFonts.outfit(
fontSize: screenWidth * 0.04,
fontWeight: FontWeight.w600,
color: Color(0xff0E0A1F),
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
}