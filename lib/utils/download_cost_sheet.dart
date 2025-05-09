import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/unit_controller.dart';
import '../models/cost_item_model.dart';

/// Load a TrueType font that supports ₹ (Roboto in this example)
Future<pw.Font> loadCustomFont() async {
  final ByteData fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
  return pw.Font.ttf(fontData);
}
pw.Widget _buildCostPdfSection(String title, List<CostItem> items, double total, pw.Font customFont) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, font: customFont)),
      pw.SizedBox(height: 5),
      pw.Table.fromTextArray(
        headers: ['Description', 'Details', 'Amount'],
        data: items.map((item) => [item.description, item.details, item.amount.toString()]).toList(),
        cellStyle: pw.TextStyle(fontSize: 10, font: customFont),
      ),
      pw.SizedBox(height: 5),
      pw.Text('Total: ₹${total.toStringAsFixed(2)}',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: customFont)),
      pw.Divider(),
    ],
  );
}

Future<void> downloadCostSheetPDF(UnitController controller) async {
  final pdf = pw.Document();
  final customFont = await loadCustomFont();

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Text('Cost Sheet', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: customFont)),
        pw.SizedBox(height: 10),
        _buildCostPdfSection('Additional Charges', controller.additionalCharges, controller.tA.value, customFont),
        _buildCostPdfSection('Construction Charges', controller.constructionCharges, controller.tB.value, customFont),
        _buildCostPdfSection('Construction Addl Charges', controller.constructionAdditionalCharges, controller.tC.value, customFont),
        _buildCostPdfSection('Possession Charges', controller.possessionCharges, controller.tD.value, customFont),
      ],
    ),
  );

  // Request storage permission
  final status = await Permission.storage.request();
  if (!status.isGranted) {
    Get.snackbar('Permission Denied', 'Storage permission is required to save the PDF');
    return;
  }

  // Get Downloads directory (better than getExternalStorageDirectory for user access)
  final downloadsDir = Directory('/storage/emulated/0/Download/CostSheet');
  if (!await downloadsDir.exists()) {
    await downloadsDir.create(recursive: true);
  }

  final path = "${downloadsDir.path}/CostSheet_${DateTime.now().millisecondsSinceEpoch}.pdf";
  final file = File(path);
  await file.writeAsBytes(await pdf.save());

  Get.snackbar('Downloaded', 'PDF saved to: $path');
}
