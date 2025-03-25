import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/payment_entry_model.dart';
import '../models/quick_action_model.dart';

class PaymentScheduleController extends GetxController {
  // Payment Entries
  final payments = <PaymentEntry>[
    PaymentEntry(
      number: '01',
      date: '22, Feb, 2025',
      description: 'On Booking',
      amount: '₹ 1,32,000',
      status: 'RECEIVED',
      statusColor: Colors.green,
    ),
    PaymentEntry(
      number: '02',
      date: '15, Mar, 2025',
      description: 'On execution of Agreement',
      amount: '₹ 2,50,000',
      status: 'DUE TODAY',
      statusColor: Colors.red,
    ),
    PaymentEntry(
      number: '03',
      date: '10, Apr, 2025',
      description: 'On Completion of Plinth',
      amount: '₹ 3,75,000',
      status: 'DUE IN 3 DAYS',
      statusColor: Colors.green,
    ),
    PaymentEntry(
      number: '04',
      date: '05, May, 2025',
      description: 'On Completion of 1st Floor',
      amount: '₹ 4,00,000',
      status: 'DUE IN 3 DAYS',
      statusColor: Colors.green,
    ),
    PaymentEntry(
      number: '05',
      date: '20, Jun, 2025',
      description: 'On Completion of 2nd Floor',
      amount: '₹ 4,25,000',
      status: 'UPCOMING',
      statusColor: Colors.orange,
    ),
  ].obs;

  // Quick Actions
  final quickActions = <QuickActionModel>[
    QuickActionModel(title: 'Cost Sheet', description: 'View detailed cost breakdown'),
    QuickActionModel(title: 'Make a Payment', description: 'Initiate new payment'),
    QuickActionModel(title: 'Download Receipt', description: 'Get your payment receipts'),
    QuickActionModel(title: 'View Agreement', description: 'Check the agreement details'),
    QuickActionModel(title: 'Payment History', description: 'Review past transactions'),
  ].obs;
}
