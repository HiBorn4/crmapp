import 'package:flutter/material.dart';

class SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  final bool isFirst;

  const SummaryItem({
    super.key,
    required this.value,
    required this.label,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: 107,
      height: 128,
      margin: EdgeInsets.only(left: isFirst ? 0 : screenWidth * 0.012),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(3,8,8,8),
            child: Image.asset(
              'assets/frame2.png', 
              width: 24,
              height: 24,
            ),
          ),
          SizedBox(height: screenWidth * 0.049),
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              color: Color(0xff606062),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: screenWidth * 0.015),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
              color: Color(0xff0E0A1F),
            ),
          ),
          SizedBox(height: screenWidth * 0.01),
        ],
      ),
    );
  }
}
