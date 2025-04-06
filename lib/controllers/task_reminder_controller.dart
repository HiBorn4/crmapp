// controllers/task_reminder_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskReminderController extends GetxController {
  // Reactive variables
  var selectedMonth = 'April'.obs;
  var selectedYear = DateTime.now().year.obs;
  var selectedDate = DateTime.now().day.obs;
  var selectedFilterIndex = 0.obs;

  // Data lists
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  final List<String> filters = ['All 5', 'To Do 2', 'Completed 4', 'Calls 1'];
  
  final List<Task> tasks = [
    Task(
      time: '07:00 PM',
      project: 'Shuba Ecostone-131',
      description: 'Collect Payment for "Completion of Second Slab"',
      status: 'Pending',
      statusColor: Color(0xFFFFD7D7),
    ),
    Task(
      time: '05:00 PM',
      project: 'Green Valley-245',
      description: 'Site Inspection with Client',
      status: 'In-Progress',
      statusColor: Color(0xFFFFF3D7),
    ),
    Task(
      time: '03:00 PM',
      project: 'Sky Towers-178',
      description: 'Finalize Interior Design Plans',
      status: 'Completed',
      statusColor: Color(0xFFD7FFDF),
    ),
  ].obs;

  // Getters
  int get selectedMonthIndex => months.indexOf(selectedMonth.value) + 1;

  // Actions
  void updateSelectedDate(int day, int monthIndex, int year) {
    selectedDate.value = day;
    selectedMonth.value = months[monthIndex - 1];
    selectedYear.value = year;
    update();
  }

  void changeFilter(int index) {
    selectedFilterIndex.value = index;
    update();
  }

  void completeTask(Task task) {
    final index = tasks.indexOf(task);
    tasks[index] = task.copyWith(status: 'Completed');
    update();
  }
}

class Task {
  final String time;
  final String project;
  final String description;
  final String status;
  final Color statusColor;

  Task({
    required this.time,
    required this.project,
    required this.description,
    required this.status,
    required this.statusColor,
  });

  Task copyWith({
    String? time,
    String? project,
    String? description,
    String? status,
    Color? statusColor,
  }) {
    return Task(
      time: time ?? this.time,
      project: project ?? this.project,
      description: description ?? this.description,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
    );
  }
}