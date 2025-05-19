import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_reminder_controller.dart';

class TaskReminderScreen extends StatelessWidget {
  final TaskReminderController _controller = Get.put(TaskReminderController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, screenWidth, screenHeight),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          child: Column(
            children: [
              _buildCalendarSection(context, screenWidth, screenHeight),
              _buildCategoryFilters(context, screenWidth, screenHeight),
              _buildTaskList(context, screenWidth, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, double screenWidth, double screenHeight) {
    return AppBar(
      
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
        iconSize: screenWidth * 0.06,
      ),
      title: Text(
        'Task Reminder',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: screenWidth * 0.045,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
    );
  }

  Widget _buildCalendarSection(BuildContext context, double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                    size: screenWidth * 0.055,
                  ),
                  SizedBox(width: screenWidth * 0.025),
                  Text(
                    '3 Tasks today',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              _buildMonthYearDropdown(context, screenWidth, screenHeight),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          _buildWeekRow(context, screenWidth, screenHeight),
        ],
      ),
    );
  }

  Widget _buildMonthYearDropdown(BuildContext context, double screenWidth, double screenHeight) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.005,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(screenWidth * 0.015),
      ),
      child: DropdownButton<String>(
        value: _controller.selectedMonth.value,
        items: _controller.months.map((String month) {
          return DropdownMenuItem<String>(
            value: month,
            child: Text(
              month,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.035,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) => _controller.selectedMonth.value = value!,
        isDense: true,
        underline: SizedBox(),
        icon: Icon(Icons.keyboard_arrow_down, size: screenWidth * 0.05),
      ),
    );
  }

  Widget _buildWeekRow(BuildContext context, double screenWidth, double screenHeight) {
    return Obx(() {
      final selectedDateTime = DateTime(
        _controller.selectedYear.value,
        _controller.selectedMonthIndex,
        _controller.selectedDate.value,
      );
      final currentWeekday = selectedDateTime.weekday;
      final startOfWeek = selectedDateTime.subtract(Duration(days: currentWeekday - 1));

      return Row(
        children: List.generate(7, (index) {
          final day = startOfWeek.add(Duration(days: index));
          final isSelected = day.day == _controller.selectedDate.value;

          return Expanded(
            child: GestureDetector(
              onTap: () => _controller.updateSelectedDate(day.day, day.month, day.year),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.01,
                ),
                decoration: BoxDecoration(
                  border: isSelected
                      ? Border.all(
                          color: Colors.black,
                          width: screenWidth * 0.005,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
                child: Column(
                  children: [
                    Text(
                      _getWeekdayName(day.weekday),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.032,
                        color: isSelected ? Colors.black : Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      '${day.day}',
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.grey[800],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    });
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }

  Widget _buildCategoryFilters(BuildContext context, double screenWidth, double screenHeight) {
    return Container(
      height: screenHeight * 0.04,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth*0.005),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _controller.filters.length,
        itemBuilder: (context, index) => _buildFilterButton(index, context, screenWidth, screenHeight),
      ),
    );
  }

  Widget _buildFilterButton(int index, BuildContext context, double screenWidth, double screenHeight) {
    final isSelected = index == _controller.selectedFilterIndex.value;

    return GestureDetector(
      onTap: () => _controller.changeFilter(index),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.008,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFEDE9FE) : Colors.white,
          // borderRadius: BorderRadius.circular(screenWidth * 0.025),
        ),
        child: Text(
          _controller.filters[index],
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.035,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, double screenWidth, double screenHeight) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _controller.tasks.length,
      itemBuilder: (context, index) => _buildTaskItem(_controller.tasks[index], context, screenWidth, screenHeight),
    );
  }

  Widget _buildTaskItem(Task task, BuildContext context, double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.all(screenWidth * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: screenWidth * 0.015,
            spreadRadius: screenWidth * 0.005,
            offset: Offset(0, screenHeight * 0.003),
          )
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
                  Icon(
                    Icons.access_time,
                    size: screenWidth * 0.045,
                    color: Colors.grey,
                  ),
                  SizedBox(width: screenWidth * 0.025),
                  Text(
                    task.time,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.035,
                  vertical: screenHeight * 0.006,
                ),
                decoration: BoxDecoration(
                  color: task.statusColor,
                  borderRadius: BorderRadius.circular(screenWidth * 0.015),
                ),
                child: Text(
                  task.status,
                  style: TextStyle(
                    fontSize: screenWidth * 0.032,
                    color: _getStatusTextColor(task.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.012),
          Text(
            task.project,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(height: screenHeight * 0.02),
          Text(
            task.description,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
              decoration: task.status == 'Completed' ? TextDecoration.lineThrough : null,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.015),
              child: OutlinedButton(
                onPressed: () => _controller.completeTask(task),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.01,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.025),
                  ),
                ),
                child: Text(
                  'Completed',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Pending':
        return Color(0xFFFF5252);
      case 'In-Progress':
        return Color(0xFFFFB300);
      case 'Completed':
        return Color(0xFF00C853);
      default:
        return Colors.black;
    }
  }
}