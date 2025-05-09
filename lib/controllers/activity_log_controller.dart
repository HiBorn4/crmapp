import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/activity_entry_model.dart';
import '../models/quick_action_model.dart';

class ActivityLogController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<ActivityEntry> activities = <ActivityEntry>[
    ActivityEntry(
      title: 'Booked',
      author: 'Vishal Kumar.S',
      date: '22 Feb 2025',
      status: 'CONFIRMED',
    ),
    ActivityEntry(
      title: 'Booked',
      author: 'Vishal Kumar.S',
      date: '22 Feb 2025',
      status: 'CONFIRMED',
    ),
    ActivityEntry(
      title: 'Advance',
      author: 'Rahul Sharma',
      date: '25 Mar 2025',
      status: 'IN PROGRESS',
    ),
    ActivityEntry(
      title: 'Loan Documents',
      author: 'Priya Patel',
      date: '28 Mar 2025',
      status: 'REJECTED',
    ),
  ].obs;

  // Project Name
  final RxString projectName = ''.obs;

  /// Fetch project name from Firestore
  Future<void> fetchProjectName(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        projectName.value = data['projectName'] ?? 'No Project';
        print("Fetched Project Name: ${projectName.value}");
      }
    } catch (e) {
      print('Error fetching project name: $e');
    }
  }

  // Quick Actions
  final RxList<QuickActionModel> quickActions = <QuickActionModel>[
    QuickActionModel(title: 'Cost Sheet', description: 'Get a clear breakdown of expenses'),
    QuickActionModel(title: 'Request Modification', description: 'Customize your home to fit your needs'),
    QuickActionModel(title: 'Payment Schedule', description: 'View and manage your payment timelines with ease'),
  ].obs;
}
