import 'package:get/get.dart';

import '../models/activity_entry_model.dart';
import '../models/quick_action_model.dart';

class ActivityLogController extends GetxController {
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

  // final RxList<QuickAction> quickActions = <QuickAction>[
  //   QuickAction(title: 'Cost Sheet', description: 'View detailed cost breakdown'),
  //   QuickAction(title: 'Make a Payment', description: 'Initiate new payment'),
  // ].obs;

  // Quick Actions
  final RxList<QuickActionModel> quickActions = <QuickActionModel>[
    QuickActionModel(title: 'Cost Sheet', description: 'View detailed cost breakdown'),
    QuickActionModel(title: 'Make a Payment', description: 'Initiate new payment'),
    QuickActionModel(title: 'Download Receipt', description: 'Get your payment receipts'),
    QuickActionModel(title: 'View Agreement', description: 'Check the agreement details'),
    QuickActionModel(title: 'Payment History', description: 'Review past transactions'),
  ].obs;
}
