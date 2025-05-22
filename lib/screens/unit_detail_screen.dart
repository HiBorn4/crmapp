import 'package:crmapp/screens/activity_log_screen.dart';
import 'package:crmapp/screens/cost_sheet_screen.dart';
import 'package:crmapp/screens/modification_screen.dart';
import 'package:crmapp/screens/transaction_screen.dart';
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

import '../widgets/unit_dimensions.dart';
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
            _buildUnitChart(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),
            _buildMilestoneSection(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),

            _buildCategory(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),
            _buildPaymentList(screenWidth, screenHeight),

            SizedBox(height: screenHeight * 0.03),
            _buildCostSheetSection(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),
            _buildApplicantDetailsCard(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),
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
        padding: EdgeInsets.only(
          left: screenWidth * 0.015,
        ), // Reduced left padding
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
            style: TextStyle(fontSize: Responsive.getFontSize(screenWidth, 14)),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildUnitChart(double screenWidth, double screenHeight) {
    RxInt selectedTab = 0.obs; // 0 = Stage Balance, 1 = Unit Cost
    final UnitController _controller = Get.find<UnitController>();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Center-Aligned Tab Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTab('Stage Balance', 0, selectedTab, screenWidth),
              SizedBox(width: 10),
              _buildTab('Unit Cost', 1, selectedTab, screenWidth),
              SizedBox(width: 10),
              _buildTab('Finance Balance', 2, selectedTab, screenWidth),
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
                    ? _buildStageBalance(screenHeight, screenWidth, _controller)
                    : _buildStageBalance(
                      screenHeight,
                      screenWidth,
                      _controller,
                    ),
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
                          18,
                        ) // Larger for selected
                        : Responsive.getFontSize(
                          screenWidth,
                          16,
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

  Widget _buildStageBalance(
    double screenHeight,
    double screenWidth,
    UnitController _controller,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenWidth * 0.03),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Donut + Legends
              Expanded(
                flex: 5,
                child: SizedBox(
                  height:
                      screenWidth *
                      0.4, // Give enough vertical space to align bottom
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center horizontally
                    mainAxisAlignment:
                        MainAxisAlignment
                            .end, // Align children to bottom vertically
                    children: [
                      DonutChart(
                        paid: _controller.paidAmount.value,
                        total: _controller.totalAmount.value,
                        size: screenWidth * 0.4,
                        paidColor: const Color(0XFFDBD3FD),
                        eligibleColor: Colors.grey[400]!,
                      ),
                      SizedBox(height: screenWidth * 0.06),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _legendBox(
                            Color(0XFFDBD3FD),
                            'Paid',
                            screenWidth,
                            screenHeight,
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          _legendBox(
                            Colors.grey[400]!,
                            'Balance',
                            screenWidth,
                            screenHeight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Spacer between chart and amounts
              SizedBox(width: screenWidth * 0.15),

              // Right Side Amounts
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Balance",
                      style: TextStyle(fontSize: screenHeight * 0.015),
                    ),
                    _buildAmountRow(
                      'Balance',
                      formatIndianCurrency(
                        _controller.totalAmount.value -
                            _controller.paidAmount.value,
                      ),
                      Colors.grey[400]!,
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    Text(
                      'Eligible Cost',
                      style: TextStyle(fontSize: screenHeight * 0.015),
                    ),
                    _buildAmountRow(
                      'Eligible Cost',
                      formatIndianCurrency(_controller.totalAmount.value),
                      Colors.grey[700]!,
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    Text(
                      'Paid',
                      style: TextStyle(fontSize: screenHeight * 0.015),
                    ),
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
      ),
    );
  }

  Widget _legendBox(
    Color color,
    String label,
    double screenWidth,
    double screenHeight,
  ) {
    return Row(
      children: [
        Container(
          width: screenWidth * 0.04, // ~10px on 400px screen
          height: screenWidth * 0.04,
          decoration: BoxDecoration(color: color, shape: BoxShape.rectangle),
        ),
        SizedBox(width: screenWidth * 0.015),
        Text(
          label,
          style: TextStyle(
            fontSize: screenHeight * 0.016, // Scales based on screen height
          ),
        ),
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

  Widget _buildMilestoneSection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UPCOMING EVENTS',
          style: TextStyle(
            fontSize: Responsive.getFontSize(screenWidth, 14),
            fontWeight: FontWeight.bold,
            color: Color(0XFF606062),
          ),
        ),
        _milestoneCard(
          screenWidth,
          title: 'Eligible Due',
          value: '₹ 22,76,36,500',
          trailing: Text(
            'Due in 2 days',
            style: TextStyle(
              color: Color(0XFF960000),
              fontSize: screenWidth * 0.027,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _milestoneCard(
          screenWidth,
          title: 'Next Milestone',
          value: 'Registration in 2 Days',
        ),
        _milestoneCard(
          screenWidth,
          title: 'Upcoming Milestone',
          value: 'Video KYC',
        ),
      ],
    );
  }

  Widget _milestoneCard(
    double screenWidth, {
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.01,
      ),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          // Left side
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/unit_screen_diamond.png', // Replace with your asset path
                      width: screenWidth * 0.035,
                      height: screenWidth * 0.035,
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.032,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.005),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Right side (if provided)
          if (trailing != null) trailing!,
        ],
      ),
    );
  }

  Widget _buildCategory(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CATEGORY',
              style: TextStyle(
                fontSize: Responsive.getFontSize(screenWidth, 14),
                fontWeight: FontWeight.bold,
                color: const Color(0XFF606062),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed('/allCategories');
              },
              child: Text(
                'View All',
                style: TextStyle(
                  fontSize: Responsive.getFontSize(screenWidth, 14),
                  fontWeight: FontWeight.bold,
                  color: const Color(0XFF606062),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCategoryItem(
              screenWidth,
              screenHeight,
              'assets/icons/cost_sheet.png',
              "Cost Sheet",
              () => Get.to(
                () => CostSheetScreen(widget.projectUid, widget.userUid),
              ),
            ),
            _buildCategoryItem(
              screenWidth,
              screenHeight,
              'assets/icons/schedule.png',
              "Schedule",
              () => Get.to(
                () => PaymentScheduleScreen(widget.projectUid, widget.userUid),
              ),
            ),
            _buildCategoryItem(
              screenWidth,
              screenHeight,
              'assets/icons/transaction.png',
              "Transactions",
              () => Get.to(() => TransactionScreen()),
            ),
            _buildCategoryItem(
              screenWidth,
              screenHeight,
              'assets/icons/document.png',
              "Documents",
              () => Get.to(
                () => ActivityLogScreen(widget.projectUid, widget.userUid),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    double screenWidth,
    double screenHeight,
    String iconPath,
    String label,
    VoidCallback onCategoryTap,
  ) {
    double iconSize = screenWidth * 0.08; // Responsive icon size
    double textSize = Responsive.getFontSize(screenWidth, 14);
    double containerSize = screenWidth * 0.15; // Responsive circle size

    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: onCategoryTap,
            child: Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0XFFEDE9FE),
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: iconSize,
                  height: iconSize,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            label,
            style: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.w500,
              color: const Color(0XFF606062),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentList(double screenWidth, double screenHeight) {
    return Obx(() {
      final payments = _controller.payments;
      final showAllButton = payments.length > 3;
      final displayedPayments =
          showAllButton ? payments.take(3).toList() : payments;

      return Column(
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

          // Display up to 3 payment widgets
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: displayedPayments.length,
            itemBuilder:
                (context, index) => PaymentScheduleWidget(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  payment: displayedPayments[index],
                ),
          ),

          // Show "View All →" button if more than 3 payments
          if (showAllButton) ...[
            SizedBox(height: screenHeight * 0.015),
            GestureDetector(
              onTap:
                  () => Get.to(
                    () => PaymentScheduleScreen(
                      widget.projectUid,
                      widget.userUid,
                    ),
                  ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.018,
                  horizontal: screenWidth * 0.04,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(screenWidth, 13),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.015),
                    Icon(
                      Icons.arrow_forward,
                      size: screenWidth * 0.045,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildCostSheetSection(double screenWidth, double screenHeight) {
    // Mock data list (replace with your real data source)
    final costItems = [
      {'label': 'Charge Cost', 'amount': '₹ 22,76,36,500'},
      {'label': 'Additional Cost', 'amount': '₹ 22,76,36,500'},
      {'label': 'Construction Cost', 'amount': '₹ 22,76,36,500'},
      {'label': 'Construction Additional Cost', 'amount': '₹ 22,76,36,500'},
      {'label': 'Additional Charges', 'amount': '₹ 22,76,36,500'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COST SHEET',
          style: TextStyle(
            fontSize: Responsive.getFontSize(screenWidth, 14),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF606062),
          ),
        ),
        SizedBox(height: screenHeight * 0.015),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
            color: Colors.white,
            boxShadow: [
              // BoxShadow(
              // color: Colors.black.withOpacity(0.03),
              // blurRadius: 6,
              // offset: const Offset(0, 2),
              // ),
            ],
          ),
          child: Column(
            children: List.generate(costItems.length, (index) {
              final item = costItems[index];
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                      horizontal: screenWidth * 0.04,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            item['label']!,
                            style: TextStyle(
                              fontSize: Responsive.getFontSize(
                                screenWidth,
                                14.5,
                              ),
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          item['amount']!,
                          style: TextStyle(
                            fontSize: Responsive.getFontSize(screenWidth, 14.5),
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index != costItems.length - 1)
                    Divider(height: 1, color: Colors.grey.shade300),
                ],
              );
            }),
          ),
        ),
        SizedBox(height: screenHeight * 0.015),
        GestureDetector(
          onTap: () {
            // Replace with your desired navigation
            Get.to(() => CostSheetScreen(widget.projectUid, widget.userUid));
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.015,
              horizontal: screenWidth * 0.04,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View all',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(screenWidth, 13),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: screenWidth * 0.015),
                Icon(
                  Icons.arrow_forward,
                  size: screenWidth * 0.045,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplicantDetailsCard(double screenWidth, double screenHeight) {
    List<String> avatarPaths = [
      'assets/avatar1.png',
      'assets/avatar2.png',
      'assets/avatar1.png',
      // Add more if needed
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'APPLICANT DETAILS',
          style: TextStyle(
            fontSize: Responsive.getFontSize(screenWidth, 13),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF606062),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.015,
            horizontal: screenWidth * 0.035,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.025),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              buildOverlappingAvatars(
                screenWidth: screenWidth,
                avatarPaths: avatarPaths,
              ),
              Expanded(
                child: Text(
                  '${avatarPaths.length} applicants',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(screenWidth, 13),
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                '1 KYC Pending',
                style: TextStyle(
                  fontSize: Responsive.getFontSize(screenWidth, 14),
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF960000),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildOverlappingAvatars({
    required double screenWidth,
    required List<String> avatarPaths,
  }) {
    double avatarRadius = screenWidth * 0.04;
    double overlapOffset = screenWidth * 0.045;
    int maxVisible = 3;

    List<Widget> avatarWidgets = [];

    for (int i = 0; i < avatarPaths.length && i < maxVisible; i++) {
      avatarWidgets.add(
        Positioned(
          left: i * overlapOffset,
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundImage: AssetImage(avatarPaths[i]),
          ),
        ),
      );
    }

    if (avatarPaths.length > maxVisible) {
      int remaining = avatarPaths.length - maxVisible;
      avatarWidgets.add(
        Positioned(
          left: maxVisible * overlapOffset,
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Colors.grey[300],
            child: Text(
              '+$remaining',
              style: TextStyle(
                fontSize: avatarRadius * 0.9,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: (maxVisible + 1) * overlapOffset + avatarRadius,
      height: avatarRadius * 2,
      child: Stack(children: avatarWidgets),
    );
  }

  //   Widget _buildUnitDimensions(double screenWidth, double screenHeight) {
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'UNIT DIMENSIONS',
  //           style: TextStyle(
  //             fontSize: Responsive.getFontSize(screenWidth, 13),
  //             fontWeight: FontWeight.bold,
  //           color: const Color(0xFF606062),
  //           ),
  //         ),
  //         SizedBox(height: screenWidth * 0.03),
  //         Center(
  //           // child: Container(
  //           //   height: screenHeight * 0.35, // Adjusted for better fit
  //           //   padding: EdgeInsets.all(screenWidth * 0.04),
  //           //   child: DimensionGraph(
  //           //     screenWidth: screenWidth,
  //           //     screenHeight: screenHeight,
  //           //   ),
  //           // ),
  //           child: PlotOrientationDiagram(
  //   D: 20, // your base unit
  //   plotNo: '34',
  //   adjacentPlotNo: '33',
  //   northIcon: Image.asset('assets/avatar1.png'),
  //   southIcon: Image.asset('assets/avatar2.png'),
  //   eastIcon: Image.asset('assets/avatar1.png'),
  //   westIcon: Image.asset('assets/avatar2.png'),
  //   roadLabel: '9MM Road',
  // ),
  //         ),
  //       ],
  //     );
  //   }
}
