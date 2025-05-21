import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/search_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

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
      backgroundColor: Colors.white,
      appBar: _buildCustomAppBar(screenWidth),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchField(screenWidth),
          _buildCategoryFilters(screenWidth),
          SizedBox(height: 15),
          _buildContentArea(screenHeight),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(double screenWidth) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black, size: 20),
            onPressed: () => Get.back(),
          ),
          Text(
            'Search',
            style: GoogleFonts.outfit(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 5,
      ), // Reduced vertical padding
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Color(0xff656567)),
          hintText: 'Search',
          hintStyle: GoogleFonts.outfit(
            color: Color(0xff656567),
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0), // Sharp corners
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical:
                screenWidth * 0.02, // Reduced vertical padding inside field
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
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                controller.categories.map((category) {
                  final isSelected =
                      category == controller.selectedCategory.value;
                  return Container(
                    margin: EdgeInsets.only(
                      right: screenWidth * 0.04,
                    ), // Adds spacing between buttons
                    child: ElevatedButton(
                      onPressed: () => controller.selectCategory(category),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected ? const Color(0xFFEDE9FE) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        side: BorderSide.none,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenWidth * 0.02,
                        ),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.outfit(
                          color: Colors.black,
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildContentArea(double screenHeight) {
    return Expanded(child: Container(color: Color(0xFFB1B1B5)));
  }
}
