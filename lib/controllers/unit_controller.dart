// ignore_for_file: invalid_use_of_protected_member, avoid_print


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/cost_item_model.dart';
import '../models/payment_entry_model.dart';
import '../models/quick_action_model.dart';

class UnitController extends GetxController {
  final String userUid;
  final String projectUid;

  UnitController({required this.userUid, required this.projectUid});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reactive variables
  final RxString orgName = ''.obs;
  final RxMap<String, dynamic> projectData = <String, dynamic>{}.obs;
  final RxList<Map<String, String>> applicantInfo = <Map<String, String>>[].obs;
  // Payment schedule will be stored as a reactive list of maps
  final RxList<Map<String, dynamic>> paymentSchedule =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, String>> costSheetItems =
      <Map<String, String>>[].obs;
    // Dummy data for testing if needed (remove if using live data)
  final RxList<PaymentEntry> payments = <PaymentEntry>[].obs;
  final RxList<CostItem> additionalCharges = <CostItem>[].obs;
final RxList<CostItem> constructionCharges = <CostItem>[].obs;
final RxList<CostItem> constructionAdditionalCharges = <CostItem>[].obs;
final RxList<CostItem> possessionCharges = <CostItem>[].obs;

final RxDouble tA = 0.0.obs;
final RxDouble tB = 0.0.obs;
final RxDouble tC = 0.0.obs;
final RxDouble tD = 0.0.obs;
final RxDouble tE = 0.0.obs;

void _parseTValues() {
  // Fetch the values from projectData and set them, defaulting to 0.0 if not found
  tA.value = (projectData["T_A"] ?? 0.0).toDouble();
  tB.value = (projectData["T_B"] ?? 0.0).toDouble();
  tC.value = (projectData["T_C"] ?? 0.0).toDouble();
  tD.value = (projectData["T_D"] ?? 0.0).toDouble();
  tE.value = (projectData["T_E"] ?? 0.0).toDouble();

  print("📊 T-Values:");
  print("T_A: ${tA.value}");
  print("T_B: ${tB.value}");
  print("T_C: ${tC.value}");
  print("T_D: ${tD.value}");
  print("T_E: ${tE.value}");
}


List<CostItem> _extractCostItems(String key) {
  List<CostItem> items = [];

  print('🔍 Extracting cost items from key: $key');
  
  if (projectData.containsKey(key)) {
    var list = projectData[key];
    print('📦 Raw data for $key: $list');

    if (list is List) {
      for (int i = 0; i < list.length; i++) {
        var item = list[i];
        try {
          print('➡️ Parsing item $i: $item');

          String label = item["component"]?["label"]?.toString().trim() ?? "N/A";
          double price = double.tryParse(item["TotalNetSaleValueGsT"].toString()) ?? 0.0;
          String formattedPrice = "₹ ${_formatCurrency(price)}";

          print('✅ Parsed: Label = $label | Price = $formattedPrice');

          items.add(CostItem(label, '', formattedPrice));
        } catch (e) {
          print("❌ Error parsing item $i in $key: $e");
        }
      }
    } else {
      print('⚠️ Expected a List for $key, but got: ${list.runtimeType}');
    }
  } else {
    print('❌ projectData does not contain key: $key');
  }

  return items;
}



void _parseCostItems() {
  additionalCharges.value = _extractCostItems("additionalChargesCS");
  constructionCharges.value = _extractCostItems("ConstructCS");
  constructionAdditionalCharges.value = _extractCostItems("constAdditionalChargesCS");
  possessionCharges.value = _extractCostItems("PossessionAdditionalCostCS");
  

  print("✅ Parsed Cost Items:");
  print("Additional Charges: ${additionalCharges.length}");
  print("Construction Charges: ${constructionCharges.length}");
  print("Construction Additional Charges: ${constructionAdditionalCharges.length}");
  print("Possession Charges: ${possessionCharges.length}");
}


  String name = '';
  String dob = '';
  String maritalStatus = '';
  String mobile = '';
  String address = '';
  String altMobile = '';
  String panNo = '';
  String aadharNo = '';
  String currentAdd = '';
  String permAdd = '';

  final List<CostItem> plcItems = [
    CostItem('Unit cost', '1,32,000 sqft', '₹ 1,32,000'),
    CostItem('PLC', '0 sqft', '₹ 1,32,00'),
    CostItem('PLC', '0 sqft', '₹ 0'),
  ];

  // Unit Summary reactive values
  final totalAmount = 0.0.obs;
  final paidAmount = 0.0.obs;

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

  /// Fetch Project Details from `<orgName>_units` collection using projectUid
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

        //         void _printLongText(String text) {
        //   const chunkSize = 800;
        //   for (var i = 0; i < text.length; i += chunkSize) {
        //     final chunk = text.substring(i, i + chunkSize > text.length ? text.length : i + chunkSize);
        //     print(chunk);
        //   }
        // }

        // Then use:
        // final safeProjectData = _sanitizeForJson(projectData);
        // final formattedJson = const JsonEncoder.withIndent('  ').convert(safeProjectData);
        // _printLongText('\n📦 Formatted Project Data for ID: $projectUid\n$formattedJson');

        _parseUnitSummaryData();
        _parseCostItems();
        _parseTValues();


        _parsePaymentData();
        getApplicantDetailsFromProject();
      } else {
        print('Project details not found.');
      }
    } catch (e) {
      print('Error fetching project details: $e');
    }
  }

  //   dynamic _sanitizeForJson(dynamic input) {
  //   if (input is Map) {
  //     return input.map((key, value) => MapEntry(key, _sanitizeForJson(value)));
  //   } else if (input is List) {
  //     return input.map(_sanitizeForJson).toList();
  //   } else if (input is double && (input.isNaN || input.isInfinite)) {
  //     return null;
  //   } else {
  //     return input;
  //   }
  // }

  

  void _parseUnitSummaryData() {
    double eligibleCost = 0;
    double paid = 0;
    double balance = 0;

    eligibleCost += (projectData.value["T_elgible"] ?? 0).toDouble();
    paid += (projectData.value["T_review"] ?? 0).toDouble();
    balance += (projectData.value["T_elgible_balance"] ?? 0).toDouble();

    totalAmount.value = eligibleCost;
    paidAmount.value = paid;

    print("Eligible Cost: $eligibleCost");
    print("Paid: $paid");
    print("Balance: $balance");
  }

  void _parsePaymentData() {
    if (projectData.value.containsKey("fullPs")) {
      var fullPs = projectData.value["fullPs"];
      if (fullPs is List &&
          fullPs.isNotEmpty &&
          fullPs[0] is Map<String, dynamic>) {
        List<Map<String, dynamic>> allSchedules = [];

        for (int index = 0; index < fullPs.length; index++) {
          var item = fullPs[index];

          String dateStr =
              item["schDate"]?.toString() ?? item["oldDate"]?.toString() ?? '';
          String formattedDate = _formatDate(dateStr);
          String amountStr = "₹ ${_formatCurrency(item["value"] ?? 0)}";

          int outstanding =
              item["outstanding"] ?? 1; // Assuming unpaid by default
          String status;
          Color statusColor;

          DateTime? scheduledDate;
          try {
            if (dateStr.isNotEmpty) {
              scheduledDate = DateTime.fromMillisecondsSinceEpoch(
                int.parse(dateStr),
              );
            }
          } catch (e) {
            scheduledDate = null;
          }

          DateTime today = DateTime.now();
          if (outstanding == 0) {
            status = "PAID";
            statusColor = Colors.green;
          } else if (scheduledDate != null && scheduledDate.isAfter(today)) {
            status = "UPCOMING";
            statusColor = Colors.orange;
          } else if (scheduledDate != null && scheduledDate.isBefore(today)) {
            status = "DUE ON TODAY";
            statusColor = Color(0xFF960000);
          } else {
            status = "PENDING";
            statusColor = Colors.grey;
          }

          allSchedules.add({
            'number': (index + 1).toString().padLeft(2, '0'),
            'date': formattedDate,
            'description': item["label"] ?? '',
            'amount': amountStr,
            'status': status,
            'statusColor': statusColor,
          });
        }

        paymentSchedule.value = allSchedules;
        payments.value =
            allSchedules.map((entry) => PaymentEntry.fromJson(entry)).toList();

        print("\n📅 Parsed Payment Schedule Entries:");
        for (var item in allSchedules) {
          print('--------------------------------');
          print('🔢 No: ${item['number']}');
          print('📆 Date: ${item['date']}');
          print('📝 Description: ${item['description']}');
          print('💰 Amount: ${item['amount']}');
          print('📌 Status: ${item['status']}');
        }
      } else {
        print("fullPs format is unexpected or empty.");
      }
    } else {
      print("fullPs not found in project data.");
    }
  }

  // Helper: Format date string (customize as needed)
  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      // Use your preferred date format here
      return date.toDate().toString();
    }
    if (date is String && date.isNotEmpty) {
      try {
        DateTime parsedDate = DateTime.parse(date);
        // Customize format if needed, for now returning in 'dd, MMM, yyyy'
        return "${parsedDate.day}, ${_getMonthName(parsedDate.month)}, ${parsedDate.year}";
      } catch (e) {
        return date;
      }
    }
    return 'N/A';
  }

  // Helper: Format currency
  String _formatCurrency(dynamic amount) {
    if (amount is num) {
      return amount
          .toStringAsFixed(2)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }
    return '0.00';
  }

  // Helper: Convert month number to month name
  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }



  
  void getApplicantDetailsFromProject() {
  final customerList = projectData['customerDetailsObj'];
  print("📋 Raw customerDetailsObj:");
  print(projectData['customerDetailsObj']);

  final firstCustomer = (customerList is List && customerList.isNotEmpty)
      ? customerList.first
      : {};

  name = firstCustomer['customerName1']?.toString() ?? 'N/A';
  dob = _formatDate(firstCustomer['dob1']);
  maritalStatus = firstCustomer['marital1']?['label']?.toString() ?? 'N/A';
  mobile = firstCustomer['phoneNo1']?.toString() ?? 'N/A';
  panNo = firstCustomer['panNo1']?.toString() ?? 'N/A';
  aadharNo = firstCustomer['aadharNo1']?.toString() ?? 'N/A';
  currentAdd = firstCustomer['address1']?.toString() ?? 'N/A';
  permAdd = firstCustomer['aggrementAddress']?.toString() ?? 'N/A';

  // Print the parsed info
  print('\n🧾 Applicant Info:');
  print('👤 Name: $name');
  print('🎂 DOB: $dob');
  print('💍 Marital Status: $maritalStatus');
  print('📞 Mobile: $mobile');
  print('🪪 PAN: $panNo');
  print('🧾 Aadhar: $aadharNo');
  print('🏠 Current Address: $currentAdd');
  print('📜 Permanent Address: $permAdd');
}

final List<QuickActionModel> quickActions = [
    QuickActionModel(
      title: 'Cost Sheet',
      description: 'Get a clear breakdown of expenses',
    ),
    QuickActionModel(
      title: 'Request Modifications',
      description: 'Customize your home to fit your needs',
    ),
    QuickActionModel(
      title: 'Activity Log',
      description: 'Track all your actions in one place and stay updated',
    ),
  ].obs;

}
