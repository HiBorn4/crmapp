import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/search_controller.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchScreenController controller = Get.put(SearchScreenController());
  int _selectedIndex = 1; // Default to "Search" tab

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      controller.navigate(index);
    }
  }

  @override
  Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    appBar: _buildCustomAppBar(screenWidth),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchField(screenWidth), // Now closer to AppBar
        _buildCategoryFilters(screenWidth),
        _buildContentArea(screenHeight),
      ],
    ),
  );
}

PreferredSizeWidget _buildCustomAppBar(double screenWidth) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    title: Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),Text(
              'Search',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          
        
      ],
    ),
  );
}

Widget _buildSearchField(double screenWidth) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 5), // Reduced vertical padding
    child: TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.black),
        hintText: 'Search',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0), // Sharp corners
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenWidth * 0.02, // Reduced vertical padding inside field
        ),
      ),
      onChanged: (value) => controller.search(value),
    ),
  );
}


Widget _buildCategoryFilters(double screenWidth) {
  return Container(
    height: 60,
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
    child: Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.categories.map((category) {
          final isSelected = category == controller.selectedCategory.value;
          return Padding(
            padding: EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () => controller.selectCategory(category),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Color(0xFFE6E0FA) : Colors.white, // Light lavender for selected
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Sharp corners
                ),
                side: BorderSide.none, // No border for selected
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: Colors.black, // Always black text
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
            ),
          );
        }).toList(),
      ),
    )),
  );
}

Widget _buildContentArea(double screenHeight) {
  return Expanded(
    child: Container(
      color: Colors.black, // Black container
      child: Center(
        child: Text(
          "Search Results",
          style: TextStyle(fontSize: 18, color: Colors.white), // White text for visibility
        ),
      ),
    ),
  );
}

}

