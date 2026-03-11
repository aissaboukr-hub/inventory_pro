import 'package:flutter/material.dart';

import '../models/product.dart';
import '../database/database_helper.dart';

class ScanViewModel extends ChangeNotifier {
  Product? scannedProduct;

  Future<void> searchProduct(String barcode) async {
    final data = await DatabaseHelper.findProductByBarcode(barcode);

    if (data != null) {
      scannedProduct = Product(
        code: data['code'] ?? '',
        designation: data['designation'] ?? '',
        barcode: data['barcode'] ?? '',
      );
    } else {
      scannedProduct = null;
    }

    notifyListeners();
  }
}
