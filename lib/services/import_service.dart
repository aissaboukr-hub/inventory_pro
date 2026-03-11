import 'dart:io';
import 'package:flutter/services.dart';
import 'package:xlsx/xlsx.dart' as xlsx;
import 'package:file_picker/file_picker.dart';
import 'google_sheets_service.dart';
import 'database_helper.dart';
import '../models/product.dart';

class ImportService {
  Future<void> importFromExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    if (result != null) {
      final path = result.files.single.path!;
      final products = await _parseExcel(path);
      await _saveProductsToDatabase(products);
    }
  }

  Future<List<Product>> _parseExcel(String filePath) async {
    final excel = xlsx.Excel.createExcel();
    final bytes = File(filePath).readAsBytesSync();
    final excelData = xlsx.Excel.decodeBytes(bytes);

    List<Product> products = [];
    for (var sheet in excelData.sheets.values) {
      for (var row in sheet.rows) {
        final product = Product(
          code: row[0], // Code produit
          designation: row[1], // Désignation
          barcode: row[2], // Code-barres
        );
        products.add(product);
      }
    }
    return products;
  }

  Future<void> _saveProductsToDatabase(List<Product> products) async {
    for (var product in products) {
      await DatabaseHelper.insertProduct(product);
    }
  }

  Future<void> importFromGoogleSheets() async {
    final products = await GoogleSheetsService.fetchProducts();
    for (var product in products) {
      await DatabaseHelper.insertProduct(Product(
        code: product['code'],
        designation: product['designation'],
        barcode: product['barcode'],
      ));
    }
  }
}
