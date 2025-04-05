import 'package:crmapp/screens/cost_sheet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_direct_caller_plugin/flutter_direct_caller_plugin.dart';
import 'package:get/get.dart';
import '../controllers/unit_controller.dart';
import '../models/cost_item_model.dart';
import '../models/payment_entry_model.dart';
import '../utils/app_colors.dart';
import '../widgets/dimension_graph_chart.dart';
import '../utils/responsive.dart';
import '../widgets/donut_chart.dart';

class UnitDetailScreen extends StatefulWidget {
  final String projectUid;
  final String userUid;

  UnitDetailScreen(this.projectUid, this.userUid);

  @override
  State<UnitDetailScreen> createState() => _UnitDetailScreenState();
}

class _UnitDetailScreenState extends State<UnitDetailScreen> with TickerProviderStateMixin {
  late UnitController _controller;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(UnitController(userUid: widget.userUid, projectUid: widget.projectUid));
  _tabController = TabController(length: 2, vsync: this); // use correct length
}

@override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            _buildUnitChart(screenWidth),
            SizedBox(height: screenHeight * 0.03),
            _buildUnitSummary(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),

            _buildCategory(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),

            _buildUnitDimensions(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),

            _buildApplicantDetails(context, _tabController),
            _buildPaymentList(screenWidth, screenHeight),
          
            _buildSection('PLOT', _controller.plcItems, screenWidth, screenHeight),
            _buildSection('PLOT', _controller.plcItems, screenWidth, screenHeight),
            
            // _buildBookingDetails(),
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
            'Unit Overview',
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

  Widget _buildUnitChart(double screenWidth) {
  RxInt selectedTab = 0.obs; // 0 = Stage Balance, 1 = Unit Cost
  final UnitController _controller = Get.find<UnitController>();

  return Obx(() => Column(
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

          // Center-Aligned Tab Switcher
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTab('Stage Balance', 0, selectedTab, screenWidth),
                _buildTab('Unit Cost', 1, selectedTab, screenWidth),
              ],
            ),
          ),
          SizedBox(height: screenWidth * 0.04),

          // Content Card
          Container(
  padding: EdgeInsets.all(screenWidth * 0.04),
  decoration: BoxDecoration(
    color: Colors.white, // Changed from Colors.grey[200] to Colors.white
    borderRadius: BorderRadius.zero, // Sharp corners
  ),
  child: selectedTab.value == 0
      ? _buildStageBalance(screenWidth, _controller)
      : _buildUnitCost(screenWidth, _controller),
),
        ],
      ));
}

// Center-Aligned Tab Widget
Widget _buildTab(String text, int index, RxInt selectedTab, double screenWidth) {
  bool isSelected = selectedTab.value == index;

  return GestureDetector(
    onTap: () {
      selectedTab.value = index;
    },
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenWidth * 0.015),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: isSelected
                  ? Responsive.getFontSize(screenWidth, 16) // Larger for selected
                  : Responsive.getFontSize(screenWidth, 14), // Smaller for unselected
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal, // No bold for unselected
              color: isSelected ? Colors.black : Colors.grey[600], // Black for selected, grey for unselected
            ),
          ),
          SizedBox(height: 3),
          Container(
            height: 2,
            width: screenWidth * 0.2,
            color: isSelected ? Colors.black : Colors.transparent, // Dark line for selected tab
          ),
        ],
      ),
    ),
  );
}



// Widget for Stage Balance
Widget _buildStageBalance(double screenWidth, UnitController _controller) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns donut and amounts properly
        children: [
          // Donut Chart (Eligible = Grey, Paid = Light Lavender)
          SizedBox(width: screenWidth * 0.08),  
          Expanded(
            flex: 2,
            child: Column(
              children: [
                DonutChart(
                  paid: _controller.paidAmount.value,
                  total: _controller.totalAmount.value,
                  size: screenWidth * 0.35,
                  paidColor: Colors.purple[300]!, // Paid section color
                  eligibleColor: Colors.grey[400]!, // Remaining section color
                ),
                SizedBox(height: screenWidth * 0.05), // Space below donut
              ],
            ),
          ),

          // Added space between Donut Chart and Amount Details
          SizedBox(width: screenWidth * 0.2),  

          // Amount Details
          Expanded(
            flex: 3,
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAmountRow('Eligible Cost', '₹${_controller.totalAmount.value.round()}', Colors.grey[700]!),
                SizedBox(height: screenWidth * 0.02), // Space between rows
                _buildAmountRow('Paid', '₹${_controller.paidAmount.value.round()}', Colors.purple[300]!),
              ],
            ),
          ),
        ],
      ),


      // Legend (Color Indication) - Now Below the Donut
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildLegendItem(Colors.purple[300]!, 'Paid'),
          SizedBox(width: screenWidth * 0.06),
          _buildLegendItem(Colors.grey[400]!, 'Balance'),
        ],
      ),
    ],
  );
}


// Legend Item Widget
Widget _buildLegendItem(Color color, String label) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle, // Changed from circle to square
          borderRadius: BorderRadius.circular(2), // Slightly rounded corners for aesthetics
        ),
      ),
      SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(fontSize: 14),
      ),
    ],
  );
}


// Placeholder for Unit Cost section
Widget _buildUnitCost(double screenWidth, UnitController _controller) {
  return Center(
    child: Text(
      'Unit Cost Details Coming Soon!',
      style: TextStyle(fontSize: Responsive.getFontSize(screenWidth, 16)),
    ),
  );
}


// Amount Row (Stacked Layout: Label above, Value below)
Widget _buildAmountRow(String label, String value, Color color) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500, // Slightly bold for emphasis
              ),
            ),
          
        SizedBox(height: 4), // Small spacing between label and value
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    ),
  );
}


  Widget _buildUnitSummary(double screenWidth, double screenHeight) {

    final data = _controller.projectData;
    print(data);

    return Obx(
      () =>
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
          _buildListItem(
data
, screenWidth, screenHeight)

        ],
      )
    );
  }

  Widget _buildListItem(Map<String, dynamic> item, double screenWidth, double screenHeight) {
  // Safely extract values with null checks
final unitNo = item['unit_no']?.toString() ?? 'N/A';
  final name = item['customerDetailsObj']?['customerName1']?.toString() ?? 'N/A';
  final contact = item['customerDetailsObj']?['phoneNo1']?.toString() ?? 'No Contact';

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
            onPressed: ()
            {
              String phoneNumber = contact.replaceAll(" ", "");
              print(phoneNumber);
             FlutterDirectCallerPlugin.callNumber(phoneNumber);
            }
            ,
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
                Get.toNamed('/cost-sheet');
              },
            ),
            _buildCategoryItem(
              screenWidth,
              screenHeight,
              Icons.schedule,
              "Schedule",
              () {
                Get.toNamed('/cost-sheet');
              },
            ),
            _buildCategoryItem(
              screenWidth,
              screenHeight,
              Icons.list,
              "Activity",
              () {
                Get.toNamed('/cost-sheet');
              },
            ),
            _buildCategoryItem(
              screenWidth,
              screenHeight,
              Icons.build,
              "Modifications",
              () {
                Get.toNamed('/cost-sheet');
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
    VoidCallback onCategoryTap,
  ) {
    double iconSize = screenWidth * 0.08; // Responsive icon size
    double textSize = Responsive.getFontSize(screenWidth, 14);
    double containerSize = screenWidth * 0.15; // Responsive circle size

    return Expanded(
      // Ensures equal spacing for all items
      child: Column(
        children: [
          GestureDetector(
            onTap: onCategoryTap,

            child: Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0XFFEDE9FE),
                
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


Widget _buildApplicantDetails(BuildContext context, TabController tabController) {
  final List<Map<String, String>> dummyApplicantInfo = [
    {
      "name": "John Doe",
      "dob": "01/01/1990",
      "marital_status": "Single",
      "mobile": "9876543210",
      "pan": "ABCDE1234F",
      "aadhaar": "1234 5678 9012"
    },
    {
      "name": "Jane Smith",
      "dob": "15/06/1988",
      "marital_status": "Married",
      "mobile": "9876543211",
      "pan": "XYZAB9876C",
      "aadhaar": "4321 8765 2109"
    }
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'APPLICANT DETAILS',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      SizedBox(
        height: 320,
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: dummyApplicantInfo
                    .map((item) => buildApplicantCard(item))
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),
            TabPageSelector(
              controller: tabController,
              selectedColor: Colors.deepPurple,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildApplicantCard(Map<String, String> item) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image at the top
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/primary.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Name and DOB
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildInfoLine("Name", item["name"] ?? ''),
                buildInfoLine("DOB", item["dob"] ?? ''),
              ],
            ),

            const SizedBox(height: 10),

            // Marital Status and Mobile
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildInfoLine("Marital Status", item["marital_status"] ?? ''),
                buildInfoLine("Mobile", item["mobile"] ?? ''),
              ],
            ),

            const Divider(height: 25, thickness: 1),

            // PAN and Aadhaar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildInfoLine("PAN", item["pan"] ?? ''),
                buildInfoLine("Aadhaar", item["aadhaar"] ?? ''),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildInfoHeading(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey[600],),
      ),
      const SizedBox(height: 2),
      Text(
        value,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
      ),
    ],
  );
}


Widget buildInfoLine(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 2),
      Text(
        value,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    ],
  );
}



  Widget _buildPaymentList(double screenWidth, double screenHeight) {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _controller.payments.length,
      itemBuilder: (context, index) => _buildPaymentItem(
        screenWidth,
        screenHeight,
        _controller.payments[index],
      ),
    ));
  }

  Widget _buildPaymentItem(double screenWidth, double screenHeight, PaymentEntry payment) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      padding: EdgeInsets.all(screenHeight * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenHeight * 0.01),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: screenHeight * 0.002,
            blurRadius: screenHeight * 0.01,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: screenHeight * 0.03,
                    height: screenHeight * 0.03,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        payment.number,
                        style: TextStyle(
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Text(
                    payment.date,
                    style: TextStyle(
                      fontSize: screenHeight * 0.016,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                payment.status,
                style: TextStyle(
                  fontSize: screenHeight * 0.016,
                  color: payment.statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            payment.description,
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.008),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: payment.amount,
                  style: TextStyle(
                    fontSize: screenHeight * 0.018,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: payment.status == 'RECEIVED'
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                  children: [
                    TextSpan(
                      text: ' Inc GST',
                      style: TextStyle(
                        fontSize: screenHeight * 0.015,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (payment.status == 'RECEIVED')
                Container(
                  width: screenWidth * 0.25,
                  height: screenHeight * 0.04,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(screenHeight * 0.005),
                  ),
                  child: Center(
                    child: Text(
                      'Paid',
                      style: TextStyle(
                        fontSize: screenHeight * 0.016,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else if (payment.status == 'DUE TODAY')
                Container(
                  width: screenWidth * 0.25,
                  height: screenHeight * 0.04,
                  decoration: BoxDecoration(
                    color: Color(0xFFD7C5F4),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Pay Now',
                      style: TextStyle(
                        fontSize: screenHeight * 0.016,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: screenWidth * 0.3,
                  height: screenHeight * 0.04,
                  decoration: BoxDecoration(
                    color: Color(0xFFD7C5F4),
                    borderRadius: BorderRadius.circular(screenHeight * 0.005),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Pay in Adv',
                      style: TextStyle(
                        fontSize: screenHeight * 0.016,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCostItem(CostItem item, double screenWidth, double screenHeight) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.description,
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            if (item.details.isNotEmpty)
              Text(
                item.details,
                style: TextStyle(
                  fontSize: screenHeight * 0.016,
                  color: Colors.black,
                ),
              ),
          ],
        ),
        Text(
          item.amount,
          style: TextStyle(
            fontSize: screenHeight * 0.018,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}

Widget _buildSection(String title, List<CostItem> items, double screenWidth, double screenHeight) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
        child: Text(
          title,
          style: TextStyle(
            fontSize: screenHeight * 0.016,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
        child: Column(
          children: [
            // _buildDashedDivider(),
            ...items.map((item) => _buildCostItem(item, screenWidth, screenHeight)),
            _buildDashedDivider(),
            _buildTotalRow(screenWidth, screenHeight),
          ],
        ),
      ),
    ],
  );
}

Widget _buildDashedDivider() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = 5.0;
        final dashSpace = 3.0;
        final dashCount = (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (index) => Container(
            width: dashWidth,
            height: 1,
            color: Colors.black,
          )),
        );
      },
    ),
  );
}


  Widget _buildTotalRow(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total',
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                fontWeight: FontWeight.bold,
              )),
          Text('₹ 87,000',
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
        ],
      ),
    );
  }

  Widget _buildCostSheet() {
    return Obx(() => SectionWrapper(
      title: 'COST SHEET',
      child: Column(
        children: [
          ..._controller.costSheetItems.map((item) => _buildCostSheetRow(
            item['label']!, 
            item['value']!
          )),
          const Divider(),
          _buildCostSheetRow('Total', _calculateTotalCost()),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Get.to(() => CostSheetScreen()),
              child: const Text('View all'),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildCostSheetRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _calculateTotalCost() {
    final total = _controller.costSheetItems.fold(0.0, (sum, item) {
      final value = double.tryParse(item['value']?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0') ?? 0;
      return sum + value;
    });
    return '₹ ${total.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  void _handlePaymentAction(String status) {
    if (status == 'RECEIVED') {
      // Get.to(() => PaymentDetailsScreen());
    } else {
      // Implement reminder logic
    }
  }
}

class SectionWrapper extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionWrapper({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 12),
          child,
          const Divider(height: 40),
        ],
      ),
    );
  }
}
