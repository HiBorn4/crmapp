// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid;

  // Reactive variables
  final RxString orgName = ''.obs;
  final RxInt totalLeadsCount = 0.obs;
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;

  // Reactive summary data
  final RxList<Map<String, String>> summaryData = <Map<String, String>>[].obs;

  // Category State
  final RxInt selectedCategoryIndex = 0.obs;
  final RxList<List<Map<String, dynamic>>> categoryData =
      <List<Map<String, dynamic>>>[].obs;

  HomeController({required this.uid});

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        userData.value = userDoc.data() as Map<String, dynamic>;
        orgName.value = userData['orgName'] ?? '';
        print('User data fetched: ${userData.value}');

        if (orgName.value.isNotEmpty) {
          await fetchTotalLeads();
        }
      } else {
        print('User document not found.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow;
    }
  }

  Future<void> fetchTotalLeads() async {
    if (orgName.value.isEmpty) {
      print("Error: orgName is empty, cannot fetch leads.");
      return;
    }

    try {
      String collectionName = '${orgName.value}_units';
      print("Fetching leads from collection: $collectionName");

      Map<String, List<Map<String, dynamic>>> categorizedLeads = {
        'booked': [],
        'registered': [],
        'agreement_pipeline': [],
        'agreement': [],
        'possession': [],
        'construction': [],
      };

      // Fetch all statuses in parallel
      await Future.wait(
        categorizedLeads.keys.map((status) async {
          try {
            var querySnapshot =
                await _firestore
                    .collection(collectionName)
                    .where("assignedTo", isEqualTo: uid)
                    .where("status", isEqualTo: status)
                    .get();

            categorizedLeads[status] =
                querySnapshot.docs.map((doc) {
                  return _sanitizeData(doc.data());
                }).toList();
          } catch (e) {
            print('Error fetching $status leads: $e');
          }
        }),
      );

      // Update counts and UI
      totalLeadsCount.value = categorizedLeads.values.fold(
        0,
        (sum, list) => sum + list.length,
      );
      updateSummaryData();
      updateCategoryData(categorizedLeads);
    } catch (e) {
      print('Error fetching total leads: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _sanitizeData(Map<String, dynamic> data) {
    final sanitized = <String, dynamic>{};

    data.forEach((key, value) {
      sanitized[key] = _convertValue(value);
    });

    return sanitized;
  }

  dynamic _convertValue(dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toIso8601String();
    }
    if (value is GeoPoint) {
      return {'lat': value.latitude, 'lng': value.longitude};
    }
    if (value is DateTime) {
      return value.toIso8601String();
    }
    if (value is double && value.isNaN) {
      return 0;
    }
    if (value is Map<String, dynamic>) {
      return _sanitizeData(value);
    }
    if (value is List) {
      return value.map((item) => _convertValue(item)).toList();
    }
    return value;
  }

  void updateSummaryData() {
    summaryData.value = [
      {'value': totalLeadsCount.value.toString(), 'label': 'Total Units'},
      {'value': '0', 'label': 'Total Task'},
      {'value': '0', 'label': 'Completed'},
    ];
    update();
  }

  void updateCategoryData(
    Map<String, List<Map<String, dynamic>>> categorizedLeads,
  ) {
    categoryData.value = [
      categorizedLeads['booked'] ?? [],
      categorizedLeads['agreement_pipeline'] ?? [],
      categorizedLeads['agreement'] ?? [],
      categorizedLeads['construction'] ?? [],
      categorizedLeads['registered'] ?? [],
      categorizedLeads['possession'] ?? [],
    ];
    update();
  }

  void changeCategory(int index) {
    if (index >= 0 && index < categoryData.length) {
      selectedCategoryIndex.value = index;
    }
  }

  List<Map<String, dynamic>> get currentCategoryData {
    if (categoryData.isEmpty ||
        selectedCategoryIndex.value >= categoryData.length) {
      return [];
    }
    return categoryData[selectedCategoryIndex.value];
  }
}
