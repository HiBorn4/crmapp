import 'package:crmapp/screens/cost_sheet_screen.dart';
import 'package:crmapp/screens/modification_screen.dart';
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
import '../widgets/payment_schedule.dart';
  import 'package:intl/intl.dart';

import 'payment_schedule_screen.dart';

class UnitDetailScreen extends StatefulWidget {
  final String projectUid;
  final String userUid;

  UnitDetailScreen(this.projectUid, this.userUid);

  @override
  State<UnitDetailScreen> createState() => _UnitDetailScreenState();
}

class _UnitDetailScreenState extends State<UnitDetailScreen>
    with TickerProviderStateMixin {
  late UnitController _controller;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      UnitController(userUid: widget.userUid, projectUid: widget.projectUid),
    );
    _tabController = TabController(length: 1, vsync: this);
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
      backgroundColor: Colors.white,
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
            _buildPaymentList(screenWidth, screenHeight),

            SizedBox(height: screenHeight * 0.03),

_buildSection(
  'Additional Charges',
  _controller.additionalCharges,
  screenWidth,
  screenHeight,
  _controller.tA.value,  // Access the value using .value
),
_buildSection(
  'Construction Charges',
  _controller.constructionCharges,
  screenWidth,
  screenHeight,
  _controller.tB.value,  // Access the value using .value
),
_buildSection(
  'Construction Additional Charges',
  _controller.constructionAdditionalCharges,
  screenWidth,
  screenHeight,
  _controller.tC.value,  // Access the value using .value
),
_buildSection(
  'Possession Charges',
  _controller.possessionCharges,
  screenWidth,
  screenHeight,
  _controller.tD.value,  // Access the value using .value
),



            _buildApplicantDetails(context, _tabController),

            // _buildUnitDimensions(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(double screenWidth) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading: Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.015), // Reduced left padding
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
    ),
    titleSpacing: 0, // Reduces gap between back arrow and title
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
          style: TextStyle(
            fontSize: Responsive.getFontSize(screenWidth, 14),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.white,
    elevation: 0,
  );
}


  Widget _buildUnitChart(double screenWidth) {
    RxInt selectedTab = 0.obs; // 0 = Stage Balance, 1 = Unit Cost
    final UnitController _controller = Get.find<UnitController>();

    return Obx(
      () => Column(
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
          Row(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTab('Stage Balance', 0, selectedTab, screenWidth),
                _buildTab('Unit Cost', 1, selectedTab, screenWidth),
              ],
            ),
          
          SizedBox(height: screenWidth * 0.04),

          // Content Card
          Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color:
                  Colors.white, // Changed from Colors.grey[200] to Colors.white
              borderRadius: BorderRadius.zero, // Sharp corners
            ),
            child:
                selectedTab.value == 0
                    ? _buildStageBalance(screenWidth, _controller)
                    : _buildStageBalance(screenWidth, _controller),
            // _buildUnitCost(screenWidth, _controller),
          ),
        ],
      ),
    );
  }

  // Center-Aligned Tab Widget
  Widget _buildTab(
    String text,
    int index,
    RxInt selectedTab,
    double screenWidth,
  ) {
    bool isSelected = selectedTab.value == index;

    return GestureDetector(
      onTap: () {
        selectedTab.value = index;
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          // horizontal: screenWidth * 0.05,
          vertical: screenWidth * 0.015,
        ),
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize:
                    isSelected
                        ? Responsive.getFontSize(
                          screenWidth,
                          16,
                        ) // Larger for selected
                        : Responsive.getFontSize(
                          screenWidth,
                          14,
                        ), // Smaller for unselected
                fontWeight:
                    isSelected
                        ? FontWeight.w500
                        : FontWeight.normal, // No bold for unselected
                color:
                    isSelected
                        ? Colors.black
                        : Colors
                            .grey[600], // Black for selected, grey for unselected
              ),
            ),
            SizedBox(height: 3),
            Container(
              height: 2,
              width: screenWidth * 0.2,
              color:
                  isSelected
                      ? Colors.black
                      : Colors.transparent, // Dark line for selected tab
            ),
          ],
        ),
      ),
    );
  }


String formatIndianCurrency(double amount) {
  final roundedAmount = amount.round();
  final format = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );
  return format.format(roundedAmount);
}


  Widget _buildStageBalance(double screenWidth, UnitController _controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Combined title with legends
        SizedBox(height: screenWidth * 0.03),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: screenWidth * 0.08),
            Expanded(
              flex: 2,
              child: DonutChart(
                paid: _controller.paidAmount.value,
                total: _controller.totalAmount.value,
                size: screenWidth * 0.35,
                paidColor: Color(0XFFDBD3FD),
                eligibleColor: Colors.grey[400]!,
              ),
            ),
            SizedBox(width: screenWidth * 0.15),
            Expanded(
  flex: 3,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(width: 10),
      SizedBox(width: 10),
      Text("Balance", style: TextStyle(fontSize: 12)),
      _buildAmountRow(
        'Balance',
        formatIndianCurrency(_controller.totalAmount.value - _controller.paidAmount.value),
        Colors.grey[400]!,
      ),
      SizedBox(height: screenWidth * 0.02),

      _legendBox(Colors.grey[700]!, 'Eligible Cost'),
      _buildAmountRow(
        'Eligible Cost',
        formatIndianCurrency(_controller.totalAmount.value),
        Colors.grey[700]!,
      ),
      SizedBox(height: screenWidth * 0.02),

      _legendBox(Color(0XFFDBD3FD), 'Paid'),
      _buildAmountRow(
        'Paid',
        formatIndianCurrency(_controller.paidAmount.value),
        Colors.purple[300]!,
      ),
    ],
  ),
),

          ],
        ),
      ],
    );
  }

  Widget _legendBox(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  // // Placeholder for Unit Cost section
  // Widget _buildUnitCost(double screenWidth, UnitController _controller) {
  //   return Center(
  //     child: Text(
  //       'Unit Cost Details Coming Soon!',
  //       style: TextStyle(fontSize: Responsive.getFontSize(screenWidth, 16)),
  //     ),
  //   );
  // }

  // Amount Row (Stacked Layout: Label above, Value below)
  Widget _buildAmountRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitSummary(double screenWidth, double screenHeight) {
    final data = _controller.projectData;
    print(data);

    return Obx(
      () => Column(
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
          _buildListItem(data, screenWidth, screenHeight),
        ],
      ),
    );
  }

  Widget _buildListItem(
    Map<String, dynamic> item,
    double screenWidth,
    double screenHeight,
  ) {
    // Safely extract values with null checks
    final unitNo = item['unit_no']?.toString() ?? 'N/A';
    final name =
        item['customerDetailsObj']?['customerName1']?.toString() ?? 'N/A';
    final contact =
        item['customerDetailsObj']?['phoneNo1']?.toString() ?? 'No Contact';

    return GestureDetector(
      onTap: () => Get.to(() => ModificationScreen()),
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
              onPressed: () {
                String phoneNumber = contact.replaceAll(" ", "");
                print(phoneNumber);
                FlutterDirectCallerPlugin.callNumber(phoneNumber);
              },
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
              () => Get.to(() => CostSheetScreen(widget.projectUid, widget.userUid)),
            ),
            _buildCategoryItem(
              screenWidth,
              screenHeight,
              Icons.schedule,
              "Schedule",
              () => Get.to(() => PaymentScheduleScreen(widget.projectUid, widget.userUid)),
            ),
            _buildCategoryItem(
              screenWidth,
              screenHeight,
              Icons.list,
              "Activity",
              () {
                Get.toNamed('/activity-log');
              },
            ),
            _buildCategoryItem(
              screenWidth,
              screenHeight,
              Icons.build,
              "Modifications",
              () {
                Get.toNamed('/modification');
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

  Widget _buildApplicantDetails(
    BuildContext context,
    TabController tabController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'APPLICANT DETAILS',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 400,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [buildApplicantCard()],
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

  Widget buildApplicantCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // 🔺 Sharp corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.zero, // 🔺 Sharp image corners
                image: const DecorationImage(
                  image: AssetImage('assets/primary.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildInfoLine("S/O", _controller.name),
                buildInfoLine("Pan Card", _controller.panNo),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildInfoLine("Marital Status", _controller.maritalStatus),
                buildInfoLine("Aadhar Number", _controller.aadharNo),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildInfoLine("DOB", _controller.dob),
                buildInfoLine("Secondary No", _controller.mobile),
              ],
            ),
            const Divider(height: 25, thickness: 1),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildInfoLine("Current Address", _controller.currentAdd),
                buildInfoLine("Permanent Address", _controller.permAdd),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoHeading(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
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
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PAYMENT SCHEDULE',
            style: TextStyle(
              fontSize: Responsive.getFontSize(screenWidth, 14),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenWidth * 0.03),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _controller.payments.length,
            itemBuilder:
                (context, index) => PaymentScheduleWidget(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  payment: _controller.payments[index],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostItem(
    CostItem item,
    double screenWidth,
    double screenHeight,
  ) {
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

  Widget _buildSection(
  String title,
  List<CostItem> items,
  double screenWidth,
  double screenHeight,
  double total,
) {
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
            ...items.map(
              (item) => _buildCostItem(item, screenWidth, screenHeight),
            ),
            _buildDashedDivider(),
            _buildTotalRow(screenWidth, screenHeight, total),
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
          final dashCount =
              (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              dashCount,
              (index) =>
                  Container(width: dashWidth, height: 1, color: Colors.black),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalRow(
  double screenWidth,
  double screenHeight,
  double total,
) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total',
          style: TextStyle(
            fontSize: screenHeight * 0.018,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          formatIndianCurrency(total),
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

}
