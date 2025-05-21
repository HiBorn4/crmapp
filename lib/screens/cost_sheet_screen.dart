import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/unit_controller.dart';
import '../models/cost_item_model.dart';
import '../models/payment_entry_model.dart';
import '../models/quick_action_model.dart';
import '../utils/amount_formatting.dart';
import '../utils/app_colors.dart';
import '../utils/download_cost_sheet.dart';
import '../utils/responsive.dart';
import '../widgets/payment_schedule.dart';

// ignore: must_be_immutable
class CostSheetScreen extends StatefulWidget {
  final String projectUid;
  final String userUid;

  CostSheetScreen(this.projectUid, this.userUid);

  
  @override
  State<CostSheetScreen> createState() => _CostSheetScreenState();
}

class _CostSheetScreenState extends State<CostSheetScreen> {
 late UnitController _controller;

 @override
  void initState() {
    super.initState();
    _controller = Get.put(
      UnitController(userUid: widget.userUid, projectUid: widget.projectUid),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _buildAppBar(screenWidth, screenHeight),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          children: [
            _buildTotalUnitCost(screenWidth, screenHeight),
            SizedBox(height: screenHeight*0.03,),
            _buildSection(
  'Cost Sheet',
  _controller.additionalCharges,
  screenWidth,
  screenHeight,
  _controller.tA.value,  // Access the value using .value
),
_buildSection(
  'Cost Sheet',
  _controller.constructionCharges,
  screenWidth,
  screenHeight,
  _controller.tB.value,  // Access the value using .value
),
_buildSection(
  'Cost Sheet',
  _controller.constructionAdditionalCharges,
  screenWidth,
  screenHeight,
  _controller.tC.value,  // Access the value using .value
),
_buildSection(
  'Cost Sheet',
  _controller.possessionCharges,
  screenWidth,
  screenHeight,
  _controller.tD.value,  // Access the value using .value
),
            download(screenWidth, screenHeight),
            _buildQuickActionsSection(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(double screenWidth, double screenHeight) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, size: screenHeight * 0.025),
        onPressed: () => Get.back(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cost Sheet',
            style: GoogleFonts.outfit(
              fontSize: screenHeight * 0.022,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Shuba Ecostone - 131',
            style: GoogleFonts.outfit(
              fontSize: screenHeight * 0.016,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalUnitCost(double screenWidth, double screenHeight) {
  return Column(
    children: [
      Text(
        'TOTAL UNIT COST',
        style: GoogleFonts.outfit(
          fontSize: screenHeight * 0.01,
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w800
        ),
      ),
      // SizedBox(height: screenHeight * 0.01),

      // 👇 Animated amount transition
      Obx(() => TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: _controller.totalAmount.value),
            duration: const Duration(seconds: 2),
            builder: (context, value, _) {
              return Text(
                formatIndianCurrency(value),
                style: GoogleFonts.outfit(
                  fontSize: screenHeight * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          )),
    ],
  );
}


  Widget _buildSection(
  String title,
  List<CostItem> items,
  double screenWidth,
  double screenHeight,
  double total,
) {
  final violetColor = Color(0xFFEDE9FE); // Light violet background

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        color: violetColor,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.012,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: screenHeight * 0.016,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Price',
              style: GoogleFonts.outfit(
                fontSize: screenHeight * 0.016,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      Container(
        height: 2,
        color: Color(0xFFC7BBFC),
      ),
      Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
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
            SizedBox(height: screenHeight*0.02,)
    ],
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
              style: GoogleFonts.outfit(
                fontSize: screenHeight * 0.015,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            if (item.details.isNotEmpty)
              Text(
                item.details,
                style: GoogleFonts.outfit(
                  fontSize: screenHeight * 0.016,
                  color: Colors.black,
                ),
              ),
          ],
        ),
        Text(
          item.amount,
          style: GoogleFonts.outfit(
            fontSize: screenHeight * 0.016,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    ),
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
            color: Colors.grey.shade400,
          )),
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
    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total',
          style: GoogleFonts.outfit(
            fontSize: screenHeight * 0.015,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          formatIndianCurrency(total),
          style: GoogleFonts.outfit(
            fontSize: screenHeight * 0.016,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}

Widget download(double screenWidth, double screenHeight) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
        child: Center(
          child: InkWell(
            onTap: _downloadCostSheet,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'Download',
                  style: GoogleFonts.outfit(
                    fontSize: screenHeight * 0.018,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Icon(Icons.download_rounded, color: Colors.black),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}



  Widget _buildQuickActionsSection(double screenWidth, double screenHeight) {
    return 
    // Obx(() => 
    
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
          child: Text(
            'QUICK ACTIONS',
            style: GoogleFonts.outfit(
              fontSize: screenHeight * 0.02,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _controller.quickActions.length,
          itemBuilder: (context, index) => _buildQuickActionItem(
            screenWidth,
            screenHeight,
            _controller.quickActions[index],
          ),
        ),
      ],
    );
    // );
  }

  Widget _buildQuickActionItem(double screenWidth, double screenHeight, QuickActionModel action) {
    return Container(
      margin: EdgeInsets.all(screenWidth*0.01),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: ListTile(
        title: Text(action.title,
            style: GoogleFonts.outfit(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.bold,
            )),
        subtitle: Text(action.description,
            style: GoogleFonts.outfit(
              fontSize: screenHeight * 0.015,
              color: Colors.grey,
            )),
        trailing: Icon(Icons.arrow_forward_ios, 
            size: screenHeight * 0.02),
        onTap: () =>  Get.toNamed('/activity-log'),
      ),
    );
  }

  void _downloadCostSheet() async {
  await downloadCostSheetPDF(_controller);
}

}