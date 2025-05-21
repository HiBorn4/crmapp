import 'package:crmapp/utils/amount_formatting.dart';
import 'package:flutter/material.dart';

import '../models/payment_entry_model.dart';
import '../utils/app_colors.dart';

class PaymentScheduleWidget extends StatefulWidget {
  const PaymentScheduleWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.payment,
  });

  final double screenWidth;
  final double screenHeight;
  final PaymentEntry payment;

  @override
  State<PaymentScheduleWidget> createState() => _PaymentScheduleWidgetState();
}

class _PaymentScheduleWidgetState extends State<PaymentScheduleWidget> {


  String formatAmount(String rawAmount) {
  // Remove ₹ and commas, then trim any spaces
  final cleaned = rawAmount.replaceAll('₹', '').replaceAll(',', '').trim();

  // Parse, round off, and format
  final amount = double.parse(cleaned).round();
  final formatted = _formatIndianCurrency(amount);

  return '₹$formatted';
}

/// Indian number format logic (e.g. 1,23,456)
String _formatIndianCurrency(int amount) {
  String amt = amount.toString();
  if (amt.length <= 3) return amt;

  String last3 = amt.substring(amt.length - 3);
  String rest = amt.substring(0, amt.length - 3);

  final reg = RegExp(r'(\d)(?=(\d\d)+\d$)');
  rest = rest.replaceAllMapped(reg, (Match m) => "${m[1]},");
  return "$rest,$last3";
}
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: widget.screenHeight * 0.01),
      padding: EdgeInsets.all(widget.screenHeight * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget.screenHeight * 0.01),
        boxShadow: [
          // BoxShadow(
            // color: Colors.grey.withOpacity(0.2),
            // spreadRadius: widget.screenHeight * 0.002,
            // blurRadius: widget.screenHeight * 0.01,
          // ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row with number, date and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  /// Circle with number
                  Container(
                    width: widget.screenHeight * 0.035,
                    height: widget.screenHeight * 0.035,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        widget.payment.number,
                        style: TextStyle(
                          fontSize: widget.screenHeight * 0.016,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: widget.screenWidth * 0.03),

                  /// Payment date
                  Text(
                    widget.payment.date,
                    style: TextStyle(
                      fontSize: widget.screenHeight * 0.016,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              /// Status text
              Text(
                widget.payment.status,
                style: TextStyle(
                  fontSize: widget.screenHeight * 0.016,
                  color: widget.payment.statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: widget.screenHeight * 0.015),

          /// Payment description
          Text(
            widget.payment.description,
            style: TextStyle(
              fontSize: widget.screenHeight * 0.018,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: widget.screenHeight * 0.01),

          /// Amount and action button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Amount with optional line-through
              RichText(
                text: TextSpan(
                  text: formatAmount(widget.payment.amount),
                  style: TextStyle(
                    fontSize: widget.screenHeight * 0.018,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: widget.payment.status == 'RECEIVED'
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                  children: [
                    TextSpan(
                      text: '  Inc GST',
                      style: TextStyle(
                        fontSize: widget.screenHeight * 0.015,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),

              /// Action button
              if (widget.payment.status == 'RECEIVED')
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.03),
                  height: widget.screenHeight * 0.04,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(widget.screenHeight * 0.005),
                  ),
                  child: Center(
                    child: Text(
                      'Paid',
                      style: TextStyle(
                        fontSize: widget.screenHeight * 0.016,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  height: widget.screenHeight * 0.04,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7C5F4),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.screenWidth * 0.05,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      widget.payment.status == 'DUE TODAY' ? 'Pay Now' : 'Pay in Adv',
                      style: TextStyle(
                        fontSize: widget.screenHeight * 0.016,
                        color: Colors.black,
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
}
