import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';

class TransactionScreen extends StatelessWidget {
  final TransactionController controller = Get.put(TransactionController());

  TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200], // Grey background
      appBar: _buildAppBar(screenWidth, screenHeight),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Column(
          children: [
            Center(
              child: Container(
                width: screenHeight * 0.35,
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      Colors.grey.shade400,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            _buildPaymentSection(context),
            SizedBox(height: screenHeight * 0.04),
            _buildTransactionList(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(double screenWidth, double screenHeight) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, size: screenHeight * 0.025),
        onPressed: () => Get.back(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transactions',
            style: GoogleFonts.outfit(
              fontSize: screenHeight * 0.022,
              fontWeight: FontWeight.w500,
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

  Widget _buildPaymentSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity, // Makes it take full width
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.05),
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'TOTAL TRANSACTIONS',
            style: GoogleFonts.outfit(
              fontSize: screenWidth * 0.03,
              fontWeight: FontWeight.w600,
              color: Color(0xff656567),
            ),
          ),
          SizedBox(height: screenWidth * 0.02),
          Text(
            '₹ 1,32,000',
            style: GoogleFonts.outfit(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.w600,
              color: Color(0xff191B1C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECENT TRANSACTIONS',
          style: GoogleFonts.outfit(
            fontSize: screenWidth * 0.032,
            fontWeight: FontWeight.w500,
            color: Color(0xff606062),
          ),
        ),
        SizedBox(height: screenWidth * 0.05),
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.transactions.length,
            itemBuilder:
                (context, index) => _TransactionItem(
                  transaction: controller.transactions[index],
                ),
          ),
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenWidth * 0.04,
          ),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Container(
                width: screenWidth * 0.12,
                height: screenWidth * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(transaction.icon),
              ),
              SizedBox(width: screenWidth * 0.04),

              // Middle section - Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.name,
                      style: GoogleFonts.openSans(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff191B1C),
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.01),
                    Text(
                      transaction.details,
                      style: GoogleFonts.openSans(
                        fontSize: screenWidth * 0.032,
                        color: Color(0xff656567),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Right section - Amount and payment method
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹ ${transaction.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: GoogleFonts.outfit(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff191B1C),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text(
                      //   transaction.paymentMethod, // e.g., "Card", "Check", "Cash"
                      //   style: GoogleFonts.outfit(
                      //     fontSize: screenWidth * 0.035,
                      //     color: Colors.grey[600],
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        transaction.date,
                        style: GoogleFonts.outfit(
                          fontSize: screenWidth * 0.035,
                          color: Color(0xff656567),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 1,
            color: Colors.grey[200],
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          ),
        ),
      ],
    );
  }
}
