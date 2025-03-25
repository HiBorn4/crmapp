import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cost_sheet_controller.dart';
import '../models/cost_item_model.dart';
import '../models/payment_entry_model.dart';
import '../models/quick_action_model.dart';
import '../utils/app_colors.dart';

class CostSheetScreen extends StatelessWidget {
  final CostSheetController _controller = Get.put(CostSheetController());

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
            _buildSection('PLOT', _controller.plcItems, screenWidth, screenHeight),
            _buildSection('ADDITIONAL CHARGES', _controller.additionalCharges, screenWidth, screenHeight),
            _buildSection('CONSTRUCTION CHARGES', _controller.constructionCharges, screenWidth, screenHeight),
            _buildSection('CONSTRUCTION ADDITIONAL CHARGES', _controller.constructionAdditional, screenWidth, screenHeight),
            _buildPossessionSection(screenWidth, screenHeight),
            _buildPaymentList(screenWidth, screenHeight),
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
            style: TextStyle(
              fontSize: screenHeight * 0.022,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Shuba Ecostone - 131',
            style: TextStyle(
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
          'TOTAL BALANCE',
          style: TextStyle(
            fontSize: screenHeight * 0.018,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          '₹ 1,11,32,000',
          style: TextStyle(
            fontSize: screenHeight * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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

  Widget _buildPossessionSection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildSection('POSSESSION CHARGES', _controller.possessionCharges, screenWidth, screenHeight),
        Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.02, bottom: screenHeight*0.01),
          child: Container(
            height: screenHeight*0.05,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            child: TextButton(
              onPressed: _downloadCostSheet,
              child: Text(
                'Download',
                style: TextStyle(
                  fontSize: screenHeight * 0.018,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentList(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.01),
          child: Text(
            'Payment Schedule',
            style: TextStyle(
              fontSize: screenHeight * 0.016,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _controller.paymentEntries.length,
          itemBuilder: (context, index) => _buildPaymentItem(
            screenWidth,
            screenHeight,
            _controller.paymentEntries[index],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.01, right: screenWidth * 0.05),
            child: Text(
              'View All',
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
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


  Widget _buildPaymentSchedule(double screenWidth, double screenHeight) {
    return 
    // Obx(() => 
    Card(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Padding(
        padding: EdgeInsets.all(screenHeight * 0.02),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PAYMENT SCHEDULE',
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.bold,
                    )),
                TextButton(
                  onPressed: () => Get.toNamed('/payment-schedule'),
                  child: Text('View all',
                      style: TextStyle(
                        fontSize: screenHeight * 0.016,
                        color: Colors.black,
                      )),
                ),
              ],
            ),
            ..._controller.paymentEntries.map(
              (entry) => _buildPaymentEntry(entry, screenWidth, screenHeight),
            ),
          ],
        ),
      ),
    );
    // );
  }

  Widget _buildPaymentEntry(PaymentEntry entry, double screenWidth, double screenHeight) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: ListTile(
        contentPadding: EdgeInsets.all(screenHeight * 0.01),
        title: Text(entry.date,
            style: TextStyle(
              fontSize: screenHeight * 0.016,
              color: Colors.grey,
            )),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.description,
                style: TextStyle(
                  fontSize: screenHeight * 0.018,
                  fontWeight: FontWeight.bold,
                )),
            RichText(
              text: TextSpan(
                text: entry.amount,
                style: TextStyle(
                  fontSize: screenHeight * 0.016,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: ' Inc GST',
                    style: TextStyle(
                      fontSize: screenHeight * 0.014,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
            style: TextStyle(
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
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.bold,
            )),
        subtitle: Text(action.description,
            style: TextStyle(
              fontSize: screenHeight * 0.015,
              color: Colors.grey,
            )),
        trailing: Icon(Icons.arrow_forward_ios, 
            size: screenHeight * 0.02),
        onTap: () =>  Get.toNamed('/activity-log'),
      ),
    );
  }

  void _downloadCostSheet() {
    // Implement download logic
  }

}