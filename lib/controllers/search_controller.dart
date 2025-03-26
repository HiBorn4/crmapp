import 'package:get/get.dart';

class SearchScreenController extends GetxController {
  final categories = ['All', 'Booked', 'Allotment', 'Agreement', 'Other'].obs;
  final selectedCategory = 'All'.obs;

  void search(String query) {
    // Implement search logic
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    // Implement filter logic
  }

  void navigate(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed('/home');
        break;
      case 1:
        break; // Already on search
      case 2:
        Get.offAllNamed('/units');
        break;
      case 3:
        Get.offAllNamed('/profile');
        break;
    }
  }
}
