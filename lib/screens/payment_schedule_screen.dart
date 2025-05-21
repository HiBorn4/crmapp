import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/payment_schedule_controller.dart';
import '../controllers/unit_controller.dart';
import '../models/payment_entry_model.dart';
import '../models/quick_action_model.dart';
import '../utils/amount_formatting.dart';
import '../utils/app_colors.dart';

class PaymentScheduleScreen extends StatefulWidget {
  final String projectUid;
  final String userUid;

  PaymentScheduleScreen(this.projectUid, this.userUid);
  @override
  State<PaymentScheduleScreen> createState() => _PaymentScheduleScreenState();
}

class _PaymentScheduleScreenState extends State<PaymentScheduleScreen> {
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
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTotalBalance(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),
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
            'Payment Schedule',
            style: GoogleFonts.outfit(
              fontSize: screenHeight * 0.022,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Shuba Ecostone - 131',
            style: GoogleFonts.outfit(fontSize: screenHeight * 0.016),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalBalance(double screenWidth, double screenHeight) {
    return Obx(() {
      final totalAmount = _controller.totalAmount.value;

      return Column(
        children: [
          Text(
            'TOTAL BALANCE',
            style: GoogleFonts.outfit(
              fontSize: screenHeight * 0.018,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: totalAmount),
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
          ),
        ],
      );
    });
  }

  Widget _buildPaymentList(double screenWidth, double screenHeight) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _controller.payments.length,
        itemBuilder:
            (context, index) => _buildPaymentItem(
              screenWidth,
              screenHeight,
              _controller.payments[index],
            ),
      ),
    );
  }

  Widget _buildPaymentItem(
    double screenWidth,
    double screenHeight,
    PaymentEntry payment,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      padding: EdgeInsets.all(screenHeight * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // color: Colors.grey.withOpacity(0.2),
            // spreadRadius: screenHeight * 0.002,
            // blurRadius: screenHeight * 0.01,
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
                        style: GoogleFonts.outfit(
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
                    style: GoogleFonts.outfit(
                      fontSize: screenHeight * 0.016,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                payment.status,
                style: GoogleFonts.outfit(
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
            style: GoogleFonts.outfit(
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
                  style: GoogleFonts.outfit(
                    fontSize: screenHeight * 0.018,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration:
                        payment.status == 'RECEIVED'
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                  ),
                  children: [
                    TextSpan(
                      text: ' Inc GST',
                      style: GoogleFonts.outfit(
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
                      style: GoogleFonts.outfit(
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
                    borderRadius: BorderRadius.all(Radius.zero),
                    color: Color(0xFFF5E6E6),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Delayed',
                      style: GoogleFonts.outfit(
                        fontSize: screenHeight * 0.016,
                        color: Color(0xFF960000),
                        fontWeight: FontWeight.w700,
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
                      style: GoogleFonts.outfit(
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

  Widget _buildQuickActionsSection(double screenWidth, double screenHeight) {
    return Column(
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
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _controller.quickActions.length,
            itemBuilder:
                (context, index) => _buildQuickActionItem(
                  screenWidth,
                  screenHeight,
                  _controller.quickActions[index],
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(
    double screenWidth,
    double screenHeight,
    QuickActionModel action,
  ) {
    return Container(
      margin: EdgeInsets.all(screenWidth * 0.01),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: ListTile(
        title: Text(
          action.title,
          style: GoogleFonts.outfit(
            fontSize: screenHeight * 0.018,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          action.description,
          style: GoogleFonts.outfit(fontSize: screenHeight * 0.015, color: Colors.grey),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: screenHeight * 0.02),
        onTap: () => _handleQuickAction(action.title),
      ),
    );
  }

  void _handleQuickAction(String action) {
    // Implement navigation logic
  }
}
