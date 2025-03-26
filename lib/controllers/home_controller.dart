import 'package:get/get.dart';
import '../models/unit_model.dart';
import '../models/project_model.dart';

class HomeController extends GetxController {

  final summaryData = [
    {'value': '7', 'label': 'Total Tasks'},
    {'value': '195', 'label': 'Total Units'},
    {'value': '3', 'label': 'Completed'},
  ];

  final attentionItems = [
    UnitModel(
      unitNo: '131',
      amount: '1,32,000',
      daysLeft: '3', name: '', user: '', due: '',
    ),
    UnitModel(
      unitNo: '152',
      amount: '2,50,000',
      daysLeft: '5', name: '', user: '', due: '',
    ),
  ];

  final myUnits = [
    UnitModel(
      unitNo: '131',
      name: 'SHUBA ECO STONE',
      user: 'S Vishal Kumar',
      due: '1,32,000',
    ),
    UnitModel(
      unitNo: '152',
      name: 'SHUBA ELAN',
      user: 'S Vishal Kumar',
      due: '2,50,000',
    ),
  ];

  final projects = [
    ProjectModel(
      name: 'SHUBA ELAN',
      location: 'CHIKBALAPUR',
      price: '2.25 cr',
      image: 'assets/project1.jpeg',
    ),
    ProjectModel(
      name: 'SHUBA ECO STONE',
      location: 'BANGALORE',
      price: '1.75 cr',
      image: 'assets/project1.jpeg',
    ),
    ProjectModel(
      name: 'SHUBA ELAN',
      location: 'CHIKBALAPUR',
      price: '2.25 cr',
      image: 'assets/project1.jpeg',
    ),
    ProjectModel(
      name: 'SHUBA ECO STONE',
      location: 'BANGALORE',
      price: '1.75 cr',
      image: 'assets/project1.jpeg',
    ),
  ];

  final balance = 750000.0.obs;
  final paid = 250000.0.obs;
  final total = 1000000.0.obs;

  // Needs Attention
  final outstandingAmount = 132000.0.obs;
  final dueDays = 3.obs;

  // Recent Transactions
  // final transactions = <TransactionModel>[
  //   TransactionModel(
  //     name: 'Plastering',
  //     amount: 1000000,
  //     type: 'Agreement',
  //     project: 'Shuba Ecovillony'
  //   ),
  // ].obs;

  // Facilities
  // final facilities = <FacilityModel>[
  //   FacilityModel(name: 'Agreement', description: 'Shuba Ecovillony'),
  // ].obs;

  // // Quick Actions
  // final quickActions = <QuickActionModel>[
  //   QuickActionModel(title: 'Civil sliver', description: 'Modification request'),
  // ].obs;
}