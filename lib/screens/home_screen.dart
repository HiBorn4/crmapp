import 'package:crmapp/screens/modification_screen.dart';
import 'package:crmapp/screens/overview_screen.dart';
import 'package:crmapp/screens/project_detail_screen.dart';
import 'package:crmapp/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/summary_item.dart';
import '../utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    SearchScreen(),
    OverviewScreen(),
    ProjectDetailScreen(),
  ];

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
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _selectedCategoryIndex = 0;
  final HomeController _controller = Get.find<HomeController>();

  final List<List<Map<String, String>>> _categoryData = [
    List.generate(5, (index) => {
          'unitNo': '132',
          'name': 'Vishal Kumar',
          'amount': '₹ 9,00,000',
          'contact': index.isEven ? '+91 91234 56789' : 'UNIT NO 456'
        }),
    List.generate(2, (index) => {
          'unitNo': '132',
          'name': 'Vishal Kumar',
          'amount': '₹ 9,00,000',
          'contact': index.isEven ? '+91 91234 56789' : 'UNIT NO 456'
        }),
    List.generate(3, (index) => {
          'unitNo': '132',
          'name': 'Vishal Kumar',
          'amount': '₹ 9,00,000',
          'contact': index.isEven ? '+91 91234 56789' : 'UNIT NO 456'
        }),
    List.generate(16, (index) => {
          'unitNo': '456',
          'name': 'Another User',
          'amount': '₹ 10,00,000',
          'contact': 'UNIT NO 789'
        }),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: ClipOval(
            child: Image.asset(
              'assets/home_profile.png',
              width: screenWidth * 0.1,
              height: screenWidth * 0.1,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning...!',
              style: TextStyle(
                fontSize: Responsive.getFontSize(screenWidth, 20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Vishal',
              style: TextStyle(
                fontSize: Responsive.getFontSize(screenWidth, 28),
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
                  horizontal: Responsive.getPadding(screenWidth).horizontal * 0.35,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummarySection(screenWidth, screenHeight),
                    SizedBox(height: screenHeight * 0.03),
                    _buildCategorySection(screenWidth),
                    SizedBox(height: screenHeight * 0.03),
                    _buildListItemSection(screenWidth, screenHeight),
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

  Widget _buildSummarySection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UNIT SUMMARY',
          style: TextStyle(fontSize: Responsive.getFontSize(screenWidth, 14)),
        ),
        SizedBox(height: screenWidth * 0.02),
        Row(
          children: _controller.summaryData.map((item) {
            return Expanded(
              child: SummaryItem(
                value: item['value']!,
                label: item['label']!,
                screenWidth: screenWidth,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategorySection(double screenWidth) {
    final categories = [
      {'value': '82', 'label': 'Booked'},
      {'value': '0', 'label': 'Allotment'},
      {'value': '0', 'label': 'Agreement'},
      {'value': '16', 'label': 'Allotment'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CATEGORY',
          style: TextStyle(fontSize: Responsive.getFontSize(screenWidth, 14)),
        ),
        SizedBox(height: screenWidth * 0.02),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: categories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              return Container(
                margin: EdgeInsets.only(right: screenWidth * 0.02),
                child: _buildCategoryItem(
                  category['value']!,
                  category['label']!,
                  screenWidth,
                  index,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    String value,
    String label,
    double screenWidth,
    int index,
  ) {
    final isSelected = _selectedCategoryIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: Container(
        width: screenWidth * 0.22,
        padding: EdgeInsets.all(screenWidth * 0.02),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFE6E0FA) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
            SizedBox(height: screenWidth * 0.01),
            Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.03,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItemSection(double screenWidth, double screenHeight) {
    final items = _categoryData[_selectedCategoryIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0),
          itemBuilder: (context, index) => _buildListItem(items[index], screenWidth, screenHeight),
        ),
      ],
    );
  }

  Widget _buildListItem(Map<String, String> item, double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () => Get.to(() => ModificationScreen()),
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(8),
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
                    item['unitNo']!,
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
                    item['name']!,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    item['contact']!,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              item['amount']!,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.04),
              onPressed: () => Get.to(() => ModificationScreen()),
            ),
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
            onTap: () {},
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
              _buildSocialIcon('assets/whatsapp.png', screenWidth * 0.06),
              _buildSocialIcon('assets/insta.png', screenWidth * 0.06),
              _buildSocialIcon('assets/x.png', screenWidth * 0.06),
              _buildSocialIcon('assets/fb.png', screenWidth * 0.06),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath, double size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size * 0.2),
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}