import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/transaction_model.dart';

class TransactionController extends GetxController {
  final transactions = <TransactionModel>[
    TransactionModel(
      icon: Icons.credit_card,
      name: 'Plastering',
      amount: 900000.0,
      details: 'Shubha Ecostone',
      date: '29 Nov',
    ),
    TransactionModel(
      icon: Icons.description,
      name: 'Agreement',
      amount: 550000.0,
      details: 'Shubha Ecostone',
      date: '28 Nov',
    ),
    TransactionModel(
      icon: Icons.build,
      name: 'Cement Purchase',
      amount: 250000.0,
      details: 'Shubha Ecostone',
      date: '27 Nov',
    ),
    TransactionModel(
      icon: Icons.electrical_services,
      name: 'Wiring & Electrical',
      amount: 320000.0,
      details: 'Shubha Ecostone',
      date: '26 Nov',
    ),
    TransactionModel(
      icon: Icons.plumbing,
      name: 'Plumbing Work',
      amount: 180000.0,
      details: 'Shubha Ecostone',
      date: '25 Nov',
    ),
    TransactionModel(
      icon: Icons.home_repair_service,
      name: 'Carpentry',
      amount: 210000.0,
      details: 'Shubha Ecostone',
      date: '24 Nov',
    ),
    TransactionModel(
      icon: Icons.park,
      name: 'Garden Landscaping',
      amount: 150000.0,
      details: 'Shubha Ecostone',
      date: '23 Nov',
    ),
    TransactionModel(
      icon: Icons.kitchen,
      name: 'Kitchen Setup',
      amount: 400000.0,
      details: 'Shubha Ecostone',
      date: '22 Nov',
    ),
    TransactionModel(
      icon: Icons.shower,
      name: 'Bathroom Fittings',
      amount: 275000.0,
      details: 'Shubha Ecostone',
      date: '21 Nov',
    ),
    TransactionModel(
      icon: Icons.local_shipping,
      name: 'Material Transport',
      amount: 130000.0,
      details: 'Shubha Ecostone',
      date: '20 Nov',
    ),
  ].obs;
}
