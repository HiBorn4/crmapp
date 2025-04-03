import 'package:crmapp/screens/cost_sheet_screen.dart';
import 'package:crmapp/widgets/summary_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/unit_controller.dart';
import '../widgets/dimension_graph_chart.dart';
import '../widgets/donut_chart.dart';
// import '../widgets/dimension_diagram.dart';
import '../widgets/document_item.dart';
import '../widgets/need_attention_item.dart';
import '../widgets/transaction_item.dart';
import '../widgets/quick_action_item.dart';
import '../utils/responsive.dart';

class UnitDetailScreen extends StatelessWidget {
  final UnitController _controller = Get.put(UnitController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(screenWidth),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          Responsive.getPadding(screenWidth).horizontal * 0.4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUnitSummary(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),

            _buildCategory(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),

            _buildUnitDimensions(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),
            _buildModificationSection(screenWidth),
            SizedBox(height: screenHeight * 0.03),
            _buildHelpRepairSection(screenWidth),
            SizedBox(height: screenHeight * 0.03),
            _buildDocumentsSection(screenWidth),
            // SizedBox(height: screenHeight * 0.03),
            _buildTransactionsSection(screenWidth),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(double screenWidth) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shuba Ecostone',
            style: TextStyle(
              fontSize: Responsive.getFontSize(screenWidth, 20),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Shuba Ecostone - 131',
            style: TextStyle(fontSize: Responsive.getFontSize(screenWidth, 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitSummary(double screenWidth, double screenHeight) {
    RxInt selectedTab = 0.obs; // 0 = Stage Balance, 1 = Unit Cost
    final UnitController _controller = Get.find<UnitController>();

    // return Obx(
    //   () => 
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Text(
            'UNIT SUMMARY',
            style: TextStyle(
              fontSize: Responsive.getFontSize(screenWidth, 14),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenWidth * 0.03),
          _buildListItem({
  "unitNo": "132",
  "name": "John Doe",
  "contact": "+91 98765 43210",
  "amount": "₹ 12,00,000"
}, screenWidth, screenHeight)

        ],
      );
    // );
  }

  Widget _buildListItem(Map<String, dynamic> item, double screenWidth, double screenHeight) {
  // Safely extract values with null checks
  final unitNo = item['unitNo']?.toString() ?? 'N/A';
  final name = item['name']?.toString() ?? 'No Name';
  final contact = item['contact']?.toString() ?? 'No Contact';

  return GestureDetector(
    onTap: () => Get.to(() => CostSheetScreen()),
    child: Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.01),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
          IconButton(
            icon: Icon(Icons.call, size: screenWidth * 0.07),
            onPressed: () => Get.to(() => UnitDetailScreen()),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildCategory(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CATEGORY',
          style: TextStyle(
            fontSize: Responsive.getFontSize(screenWidth, 14),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround, // Ensures equal spacing
          children: [
            _buildCategoryItem(
              screenWidth,
              screenHeight,
              Icons.receipt_long,
              "Cost Sheet",
              () {
                Get.toNamed('/costSheet');
              },
            ),
            _buildCategoryItem(
              screenWidth,
              screenHeight,
              Icons.schedule,
              "Schedule",
              () {
                Get.toNamed('/schedule');
              },
            ),
            _buildCategoryItem(
              screenWidth,
              screenHeight,
              Icons.list,
              "Activity",
              () {
                Get.toNamed('/activity');
              },
            ),
            _buildCategoryItem(
              screenWidth,
              screenHeight,
              Icons.build,
              "Modifications",
              () {
                Get.toNamed('/modifications');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    double screenWidth,
    double screenHeight,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    double iconSize = screenWidth * 0.08; // Responsive icon size
    double textSize = Responsive.getFontSize(screenWidth, 14);
    double containerSize = screenWidth * 0.15; // Responsive circle size

    return Expanded(
      // Ensures equal spacing for all items
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Get.toNamed('/cost-sheet'),

            child: Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Icon(icon, size: iconSize, color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            label,
            style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUnitDimensions(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UNIT DETAILS AND DIMENSIONS',
          style: TextStyle(
            fontSize: Responsive.getFontSize(screenWidth, 14),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenWidth * 0.03),
        Center(
          child: Container(
            height: screenHeight * 0.35, // Adjusted for better fit
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: DimensionGraph(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModificationSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading
        Text(
          'Modification',
          style: TextStyle(
            fontSize: Responsive.getFontSize(screenWidth, 14),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenWidth * 0.03),

        // Modification Card
        Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Colors.white, // Background is white
          ),
          child: Row(
            children: [
              // Modification Icon (Black)
              Icon(
                Icons.build,
                size: screenWidth * 0.08,
                color: Colors.black, // Black icon
              ),
              SizedBox(width: screenWidth * 0.04),

              // Text Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need to modify your home?',
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(screenWidth, 16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Modify home's layout, interiors or features effortlessly.",
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(screenWidth, 14),
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              // Right Arrow (White arrow inside black circle)
              GestureDetector(
                onTap: () => Get.toNamed('/modification'),
                child: Container(
                  width: screenWidth * 0.08,
                  height: screenWidth * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.black, // Black circle
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: screenWidth * 0.05,
                      color: Colors.white, // White arrow
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpRepairSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading
        Text(
          'Help & Repair',
          style: TextStyle(
            fontSize: Responsive.getFontSize(screenWidth, 14),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenWidth * 0.03),

        // Profile Card
        Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Colors.white, // White background
          ),
          child: Row(
            children: [
              // Profile Image (Reduced Radius)
              CircleAvatar(
                radius: screenWidth * 0.06, // Reduced size
                backgroundImage: AssetImage('assets/profile.jpeg'),
              ),
              SizedBox(width: screenWidth * 0.04),

              // Name, Position, and Number
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hanif',
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(screenWidth, 16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4), // Added space between lines
                    Text(
                      'CRM Executive',
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(screenWidth, 14),
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4), // Added space between lines
                    Text(
                      '+91 9768562601',
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(screenWidth, 14),
                      ),
                    ),
                  ],
                ),
              ),

              // Contact Button with White Background & Black Border
              Container(
                height: screenWidth * 0.1,
                width: screenWidth * 0.3,
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  border: Border.all(color: Colors.black), // Black border
                  borderRadius: BorderRadius.circular(
                    5,
                  ), // Slightly rounded edges
                ),
                child: TextButton(
                  onPressed: () => Get.toNamed('/contact'),
                  child: Text(
                    'Contact',
                    style: TextStyle(
                      color: Colors.black, // Black text
                      fontSize: Responsive.getFontSize(screenWidth, 16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title: DOCUMENTS
        Text(
          'DOCUMENTS',
          style: TextStyle(
            fontSize: Responsive.getFontSize(
              screenWidth,
              14,
            ), // Increased font size slightly
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: screenWidth * 0.04), // Added space after heading
        // Documents List
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _controller.documents.length,
            itemBuilder:
                (context, index) => DocumentItem(
                  document: _controller.documents[index],
                  screenWidth: screenWidth,
                ),
          ),
        ),

        SizedBox(height: screenWidth * 0.03), // Responsive spacing
        // "View All" Button
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Get.toNamed('/documents'),
            child: Text(
              'View all',
              style: TextStyle(
                fontSize: Responsive.getFontSize(screenWidth, 16),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title: RECENT TRANSACTIONS
        Text(
          'RECENT TRANSACTIONS',
          style: TextStyle(
            fontSize: Responsive.getFontSize(
              screenWidth,
              14,
            ), // Increased for better visibility
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: screenWidth * 0.04), // Added space after heading
        // Transactions List
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _controller.transactions.length,
            itemBuilder:
                (context, index) => TransactionItem(
                  transaction: _controller.transactions[index],
                  screenWidth: screenWidth,
                ),
          ),
        ),

        SizedBox(height: screenWidth * 0.03), // Responsive spacing
        // "View All" Button
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Get.toNamed('/transactions'),
            child: Text(
              'View all',
              style: TextStyle(
                fontSize: Responsive.getFontSize(screenWidth, 16),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
