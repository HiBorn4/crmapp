// ignore_for_file: invalid_use_of_protected_member

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
  final RxList<List<Map<String, dynamic>>> categoryData = <List<Map<String, dynamic>>>[].obs;

  HomeController({required this.uid});

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  /// Fetch user profile data
  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        userData.value = userDoc.data() as Map<String, dynamic>;
        orgName.value = userData['orgName'] ?? ''; // Fetch orgName directly
        print('User data fetched: ${userData.value}');

        if (orgName.value.isNotEmpty) {
          fetchTotalLeads();
        }
      } else {
        print('User document not found.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  /// Fetch total leads count and category-wise distribution
  Future<void> fetchTotalLeads() async {
    if (orgName.value.isEmpty) {
      print("Error: orgName is empty, cannot fetch leads.");
      return;
    }

    try {
      String collectionName = '${orgName.value}_units'; // Example: "spark_units"
      print("Fetching leads from collection: $collectionName");

      Map<String, int> statusCounts = {
        'booked': 0,
        'agreement_pipeline': 0,
        'agreement': 0,
        'registered': 0,
        'possession': 0,
        'construction': 0,
      };

      for (String status in statusCounts.keys) {
        var querySnapshot = await _firestore
            .collection(collectionName)
            .where("assignedTo", isEqualTo: uid)
            .where("status", isEqualTo: status)
            .get();

        statusCounts[status] = querySnapshot.docs.length;
      }

      // Set total lead count
      totalLeadsCount.value = statusCounts.values.reduce((a, b) => a + b);
      updateSummaryData();

      // Update category data
      updateCategoryData(statusCounts);

      print("Total leads count: ${totalLeadsCount.value}");
    } catch (e) {
      print('Error fetching total leads: $e');
    }
  }

  /// Updates summary section UI
  void updateSummaryData() {
    summaryData.value = [
      {'value': '0', 'label': 'Total Tasks'},
      {'value': totalLeadsCount.value.toString(), 'label': 'Total Units'},
      {'value': '0', 'label': 'Completed'},
    ];
    update();
  }

  /// Update category-wise data dynamically
  void updateCategoryData(Map<String, int> statusCounts) {
    categoryData.value = [
      List.generate(statusCounts['booked'] ?? 0, (index) => _generateItem(index, 'booked')),
      List.generate(statusCounts['agreement_pipeline'] ?? 0, (index) => _generateItem(index, 'agreement_pipeline')),
      List.generate(statusCounts['agreement'] ?? 0, (index) => _generateItem(index, 'agreement')),
      List.generate(statusCounts['construction'] ?? 0, (index) => _generateItem(index, 'construction')),
      List.generate(statusCounts['registered'] ?? 0, (index) => _generateItem(index, 'registered')),
      List.generate(statusCounts['possession'] ?? 0, (index) => _generateItem(index, 'possession')),
    ];

    update();
    print('Updated category data with ${categoryData.value.length} categories');
  }

  /// Generate a lead item with mock data
  Map<String, dynamic> _generateItem(int index, String category) {
    return {
      'unitNo': index,
      'name': userData['name'] ?? 'Unknown User',
      'status': category.toUpperCase(),
      'amount': '₹ ${(10 + index)}',
      'contact': index.isEven ? '+91 91234 56789' : 'N/A',
    };
  }

  /// Change selected category index
  void changeCategory(int index) {
    if (index >= 0 && index < categoryData.value.length) {
      selectedCategoryIndex.value = index;
      print('Changed to category $index with ${categoryData.value[index].length} items');
    }
  }

  /// Get data for the currently selected category
  List<Map<String, dynamic>> get currentCategoryData {
    if (categoryData.value.isEmpty || selectedCategoryIndex.value >= categoryData.value.length) {
      return [];
    }
    return categoryData.value[selectedCategoryIndex.value];
  }
}
