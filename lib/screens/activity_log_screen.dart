import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/activity_log_controller.dart';
import '../models/activity_entry_model.dart';
import '../models/quick_action_model.dart';
import '../utils/app_colors.dart';
import '../utils/tapered_line_painter.dart';
import 'cost_sheet_screen.dart';
import 'modification_screen.dart';
import 'payment_schedule_screen.dart';


class ActivityLogScreen extends StatefulWidget {
  final String projectUid;
  final String userUid;

  ActivityLogScreen(this.projectUid, this.userUid);
  @override
  State<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  final ActivityLogController _controller = Get.put(ActivityLogController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(screenWidth, screenHeight),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          children: [
            _buildActivityList(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),
            _buildQuickActionsSection(screenWidth, screenHeight),
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
            'Activity Log',
            style: TextStyle(
              fontSize: screenHeight * 0.022,
              fontWeight: FontWeight.bold,
            ),
          ),
          Obx(() => Text(
  _controller.projectName.value,
  style: TextStyle(fontSize: screenHeight * 0.016),
))

        ],
      ),
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), // Adjust height as needed
          child: CustomPaint(
            painter: TaperedLinePainter(),
            child: SizedBox(width: double.infinity),
          ),
        ),
    );
  }

  Widget _buildActivityList(double screenWidth, double screenHeight) {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _controller.activities.length,
      itemBuilder: (context, index) => _buildActivityItem(
        screenWidth,
        screenHeight,
        _controller.activities[index],
        index == _controller.activities.length - 1,
      ),
    ));
  }

  Widget _buildActivityItem(double screenWidth, double screenHeight, ActivityEntry activity, bool isLast) {
  return Container(
    margin: EdgeInsets.only(bottom: screenHeight * 0.003),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: screenWidth*0.06, child: _buildTimeline(screenHeight, isLast)),
        SizedBox(width: screenWidth * 0.01),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: EdgeInsets.all(screenHeight * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activity.title,
                      style: TextStyle(
                        fontSize: screenHeight * 0.018,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(activity.status).withOpacity(0.2),
                        // border: Border.all(color: _getStatusColor(activity.status)),
                      ),
                      child: Text(
                        activity.status,
                        style: TextStyle(
                          fontSize: screenHeight * 0.014,
                          fontWeight: FontWeight.w700,
                          color: _getStatusColor(activity.status),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  'By: ${activity.author}',
                  style: TextStyle(
                    fontSize: screenHeight * 0.015,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  '${activity.date}',
                  style: TextStyle(
                    fontSize: screenHeight * 0.015,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildTimeline(double screenHeight, bool isLast) {
  // Customizable parameters
  final double dotSize = screenHeight * 0.015;
  final double lineHeight = screenHeight * 0.1; // Directly controls gap between dots
  final double verticalSpacing = 0; // Additional spacing between dot and line

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
      if (!isLast)
        Container(
          margin: EdgeInsets.only(top: verticalSpacing),
          width: 2,
          height: lineHeight,
          color: Colors.black,
        ),
    ],
  );
}

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        return Colors.green;
      case 'IN PROGRESS':
        return Colors.orange;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildQuickActionsSection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
          child: Text(
            'QUICK ACTIONS',
            style: TextStyle(
              fontSize: screenHeight * 0.017,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _controller.quickActions.length,
          itemBuilder: (context, index) => _buildQuickActionItem(
            screenWidth,
            screenHeight,
            _controller.quickActions[index],
          ),
        )),
      ],
    );
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
        onTap: () => _handleQuickAction(action.title),
      ),
    );
  }

  void _handleQuickAction(String action) {
  switch (action) {
    case 'Cost Sheet':
      Get.to(() => CostSheetScreen(widget.projectUid, widget.userUid));
      break;
    case 'Request Modification':
      Get.to(() => ModificationScreen());
      break;
    case 'Payment Schedule':
      Get.to(() => PaymentScheduleScreen(widget.projectUid, widget.userUid));
      break;
    default:
      Get.snackbar('Unknown Action', 'No screen found for "$action"');
  }
}
}

