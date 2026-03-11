import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_helper.dart';

class ScanViewModel extends ChangeNotifier {
  Product? scannedProduct;

  Future<void> searchProduct(String code) async {
    final database = await DatabaseHelper.init();
    final List<Map<String, dynamic>> maps = await database.query(
      'products',
      where: 'barcode = ?',
      whereArgs: [code],
    );

    if (maps.isNotEmpty) {
      scannedProduct = Product(
        code: maps[0]['code'],
        designation: maps[0]['designation'],
        barcode: maps[0]['barcode'],
      );
      notifyListeners();
    } else {
      scannedProduct = null;
      notifyListeners();
    }
  }
}
