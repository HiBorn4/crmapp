import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/quick_action_model.dart';

class ModificationController extends GetxController {
  final selectedCategoryIndex = 0.obs;
  final descriptionController = TextEditingController();
  
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.construction, 'label': 'Civil Work'},
    {'icon': Icons.brush, 'label': 'Interior'},
    {'icon': Icons.handyman, 'label': 'Maintenance'},
  ];

  final List<QuickActionModel> quickActions = [
    QuickActionModel(title: 'Cost Sheet', description: 'View detailed cost breakdown'),
    QuickActionModel(title: 'Payment Schedule', description: 'Check payment timeline'),
    QuickActionModel(title: 'Activity log', description: 'View modification history'),
  ].obs;
}
