import 'package:flutter/material.dart';

class DocumentModel {
  final IconData icon;
  final String name;
  final String date;
  final String fileSize;

  DocumentModel({
    required this.icon,
    required this.name,
    required this.date,
    required this.fileSize,
  });
}
