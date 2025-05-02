import 'package:flutter/material.dart';

class SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  final bool isFirst;

  const SummaryItem({
    required this.value,
    required this.label,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(left: isFirst ? 0 : screenWidth * 0.012),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(screenWidth * 0.015),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: screenWidth * 0.015),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: screenWidth * 0.025),
        ],
      ),
    );
  }
}
