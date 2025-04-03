import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/document_model.dart';
import '../models/quick_action_model.dart';
import '../models/transaction_model.dart';
import '../models/unit_model.dart';

class UnitController extends GetxController {
  // Unit Summary
  final totalAmount = 100000.0.obs;
  final paidAmount = 75000.0.obs;
  
  // Facilities (5 Dummy Data)
  final documents = <DocumentModel>[
  DocumentModel(icon: Icons.description, name: 'Agreement', date: '12/2/25', fileSize: '0.3 MB'),
  DocumentModel(icon: Icons.file_copy, name: 'Blueprint', date: '15/2/25', fileSize: '1.2 MB'),
  DocumentModel(icon: Icons.picture_as_pdf, name: 'Payment Receipt', date: '20/2/25', fileSize: '0.5 MB'),
  DocumentModel(icon: Icons.article, name: 'Project Plan', date: '22/2/25', fileSize: '2.0 MB'),
  DocumentModel(icon: Icons.folder, name: 'Legal Docs', date: '28/2/25', fileSize: '0.8 MB'),
].obs;

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


  // Transactions (5 Dummy Data)
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

  // Quick Actions (5 Dummy Data)
  final quickActions = <QuickActionModel>[
    QuickActionModel(title: 'Civil Sliver', description: 'Modification Request'),
    QuickActionModel(title: 'Paint Work', description: 'Color Customization Request'),
    QuickActionModel(title: 'Security Update', description: 'Access Card Activation'),
    QuickActionModel(title: 'Water Supply', description: 'Request for Additional Connection'),
    QuickActionModel(title: 'Electrical', description: 'Power Backup Upgrade'),
  ].obs;
}
