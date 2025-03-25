import 'package:flutter/material.dart';

class TransactionModel {
  final IconData icon;
  final String name;
  final double amount;
  final String details;
  final String date;

  TransactionModel({
    required this.icon,
    required this.name,
    required this.amount,
    required this.details,
    required this.date,
  });
}