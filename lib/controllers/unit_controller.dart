// ignore_for_file: invalid_use_of_protected_member, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/cost_item_model.dart';
import '../models/document_model.dart';
import '../models/payment_entry_model.dart';
import '../models/quick_action_model.dart';
import '../models/transaction_model.dart';
import '../models/unit_model.dart';

class UnitController extends GetxController {
  final String userUid;
  final String projectUid;

  UnitController({required this.userUid, required this.projectUid});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reactive variables
  final RxString orgName = ''.obs;
  final RxMap<String, dynamic> projectData = <String, dynamic>{}.obs;
  final RxList<Map<String, String>> applicantInfo = <Map<String, String>>[].obs;
  final RxList<Map<String, dynamic>> paymentSchedule = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, String>> costSheetItems = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    print("User: $userUid, Project: $projectUid");
    fetchUserData(); // Start by fetching user data
  }

  /// Fetch User Data from "users" collection and extract `orgName`
  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userUid).get();

      if (userDoc.exists) {
        orgName.value = userDoc['orgName'] ?? '';
        print('Fetched Organization Name: ${orgName.value}');

        if (orgName.value.isNotEmpty) {
          await fetchProjectDetails(); // Fetch project details once orgName is available
        }
      } else {
        print('User document not found.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  /// Fetch **Project Details** from `<orgName>_units` collection
  Future<void> fetchProjectDetails() async {
    if (orgName.value.isEmpty) {
      print("Error: orgName is empty, cannot fetch project details.");
      return;
    }

    try {
      String collectionName = '${orgName.value}_units';
      DocumentSnapshot projectDoc =
          await _firestore.collection(collectionName).doc(projectUid).get();

      if (projectDoc.exists) {
        projectData.value = projectDoc.data() as Map<String, dynamic>;
        _parseProjectData();
        print('Project Details: ${projectData.value}');
      } else {
        print('Project details not found.');
      }
    } catch (e) {
      print('Error fetching project details: $e');
    }
  }

  

  void _parseProjectData() {
    // Parse applicant info
    applicantInfo.value = [
      {'label': 'NAME', 'value': projectData['customerDetailsObj']?['customerName1'] ?? 'N/A'},
      {'label': 'DOB', 'value': _formatDate(projectData['dob'])},
      {'label': 'MARITAL STATUS', 'value': projectData['maritalStatus'] ?? 'N/A'},
      {'label': 'MOBILE', 'value': projectData['customerDetailsObj']?['phoneNo1'] ?? 'N/A'},
      {'label': 'ADDRESS', 'value': projectData['address'] ?? 'N/A'},
      {'label': 'ALT MOBILE', 'value': projectData['alternatePhone'] ?? 'N/A'},
    ];

    // Parse payment schedule
    paymentSchedule.value = (projectData['paymentSchedule'] as List<dynamic>?)?.map((item) {
      return {
        'number': item['index'],
        'date': _formatDate(item['dueDate']),
        'description': item['description'],
        'amount': '₹ ${_formatCurrency(item['amount'])}',
        'status': item['status'],
        'statusColor': _getStatusColor(item['status'])
      };
    }).toList() ?? [];

    // Parse cost sheet
    // costSheetItems.value = (projectData['costSheet'] as List<dynamic>?)?.map((item) {
    //   return {
    //     'label': item['description'],
    //     'value': '₹ ${_formatCurrency(item['amount'])}'
    //   };
    // }).toList() ?? [];
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'received': return Colors.green;
      case 'delayed': return Colors.orange;
      case 'due': return Colors.yellow;
      default: return Colors.grey;
    }
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      // return DateFormat('dd, MMM, y').format(date.toDate());
    }
    return date?.toString() ?? 'N/A';
  }

  String _formatCurrency(dynamic amount) {
    if (amount is num) {
      return amount.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
    return '0.00';
  }

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

  final List<CostItem> plcItems = [
    CostItem('Unit cost', '1,32,000 sqft', '₹ 1,32,000'),
    CostItem('PLC', '0 sqft', '₹ 0'),
  ];

  // Unit Summary
  final totalAmount = 100000.0.obs;
  final paidAmount = 75000.0.obs;

  // Documents
  final documents = <DocumentModel>[
    DocumentModel(
        icon: Icons.description,
        name: 'Agreement',
        date: '12/2/25',
        fileSize: '0.3 MB'),
    DocumentModel(
        icon: Icons.file_copy,
        name: 'Blueprint',
        date: '15/2/25',
        fileSize: '1.2 MB'),
    DocumentModel(
        icon: Icons.picture_as_pdf,
        name: 'Payment Receipt',
        date: '20/2/25',
        fileSize: '0.5 MB'),
    DocumentModel(
        icon: Icons.article,
        name: 'Project Plan',
        date: '22/2/25',
        fileSize: '2.0 MB'),
    DocumentModel(
        icon: Icons.folder,
        name: 'Legal Docs',
        date: '28/2/25',
        fileSize: '0.8 MB'),
  ].obs;

  // Attention Items
  final attentionItems = [
    UnitModel(
      unitNo: '131',
      amount: '1,32,000',
      daysLeft: '3',
      name: '',
      user: '',
      due: '',
    ),
    UnitModel(
      unitNo: '152',
      amount: '2,50,000',
      daysLeft: '5',
      name: '',
      user: '',
      due: '',
    ),
  ];

  // Transactions
  final transactions = <TransactionModel>[
    TransactionModel(
      icon: Icons.construction,
      name: 'Plastering',
      amount: 100000,
      details: 'Agreement - Shuba Ecovillony',
      date: '02 Mar',
    ),
    TransactionModel(
      icon: Icons.build,
      name: 'Wiring',
      amount: 50000,
      details: 'Electrical - Tower B',
      date: '10 Mar',
    ),
    TransactionModel(
      icon: Icons.plumbing,
      name: 'Plumbing',
      amount: 75000,
      details: 'Pipelines - Basement A',
      date: '15 Mar',
    ),
    TransactionModel(
      icon: Icons.home_repair_service,
      name: 'Tiles Work',
      amount: 120000,
      details: 'Flooring - Phase 1',
      date: '18 Mar',
    ),
    TransactionModel(
      icon: Icons.roofing,
      name: 'Roof Work',
      amount: 95000,
      details: 'Roof Installation - Block C',
      date: '25 Mar',
    ),
  ].obs;

  // Quick Actions
  final quickActions = <QuickActionModel>[
    QuickActionModel(title: 'Civil Sliver', description: 'Modification Request'),
    QuickActionModel(
        title: 'Paint Work', description: 'Color Customization Request'),
    QuickActionModel(title: 'Security Update', description: 'Access Card Activation'),
    QuickActionModel(
        title: 'Water Supply', description: 'Request for Additional Connection'),
    QuickActionModel(title: 'Electrical', description: 'Power Backup Upgrade'),
  ].obs;
}
