import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/overview_donut_chart.dart';

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final List<String> dropdownOptions = ["Yesterday", "This week", "7 days ago", "This Month"];

  String selectedActivityOption = "Yesterday";  // Dropdown for MY ACTIVITY
  String selectedOverviewOption = "Yesterday";  // Dropdown for OVERVIEW

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _buildCustomAppBar(screenWidth),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              _buildMyActivitySection(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.02),
              _buildOverviewSection(screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(double screenWidth) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          Text('Overview',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildMyActivitySection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSectionHeader('MY ACTIVITY', screenWidth, true),  // Pass true for activity dropdown
        SizedBox(height: screenWidth * 0.02),

        // Donut & Text Side by Side
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                _buildDonutChart(screenWidth),
                SizedBox(height: screenHeight * 0.04),
                // Legends Below Donut in One Row
                _buildLegends(screenWidth),
              ],
            ), // Column 1 - Donut
            SizedBox(width: screenWidth * 0.2), // Small spacing
            _buildActivityText(), // Column 2 - Text & Numbers
          ],
        ),
      ],
    );
  }

  Widget _buildDonutChart(double screenWidth) {
    return Container(
      width: screenWidth * 0.5,
      height: screenWidth * 0.5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: CustomPaint(
        painter: DonutChartPainter(),
      ),
    );
  }

  Widget _buildActivityText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegendText('Calls', '120'),
        SizedBox(height: 10),
        _buildLegendText('Tasks', '150'),
        SizedBox(height: 10),
        _buildLegendText('Booked', '1'),
      ],
    );
  }

  Widget _buildLegends(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('Calls', Color(0xFFDBD3FD)),
        _buildLegendItem('Tasks', Color(0xFFFAC7C7)),
        _buildLegendItem('Booked', Color(0xFFC6FBC8)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 14)),
        SizedBox(width: 6),
      ],
    );
  }

  Widget _buildLegendText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Text(value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }

  Widget _buildOverviewSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('OVERVIEW', screenWidth, false),  // Pass false for overview dropdown
        SizedBox(height: screenWidth * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildOverviewBox('10', 'Tasks', '45%', false, screenWidth),
            _buildOverviewBox('2', 'Completed', '28%', true, screenWidth),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewBox(String value, String label, String percentage, bool isIncrease, double screenWidth) {
    return Container(
      width: screenWidth * 0.42,
      padding: EdgeInsets.all(screenWidth * 0.02),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              )),
          Text(label,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.grey[600],
              )),
          SizedBox(height: screenWidth * 0.02),
          Row(
            children: [
              Icon(
                isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                color: isIncrease ? Colors.green[400] : Colors.red[400],
                size: screenWidth * 0.04,
              ),
              SizedBox(width: screenWidth * 0.02),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isIncrease ? Colors.green[400] : Colors.red[400],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(percentage,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropDownButton(double screenWidth, bool isActivity) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: isActivity ? selectedActivityOption : selectedOverviewOption,  // Use respective state variable
          icon: Icon(Icons.arrow_drop_down, size: screenWidth * 0.04),
          items: dropdownOptions.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option, style: TextStyle(fontSize: screenWidth * 0.035)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              if (isActivity) {
                selectedActivityOption = newValue!;
              } else {
                selectedOverviewOption = newValue!;
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, double screenWidth, bool isActivity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.bold,
            )),
        _buildDropDownButton(screenWidth, isActivity),  // Pass flag to differentiate
      ],
    );
  }
}
