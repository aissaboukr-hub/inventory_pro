import 'package:flutter/material.dart';

import '../models/inventory.dart';
import '../models/product.dart';
import '../database/database_helper.dart';

class InventoryViewModel extends ChangeNotifier {
  List<Inventory> _inventories = [];

  List<Inventory> get inventories => _inventories;

  Future<List<Inventory>> getInventories() async {
    final maps = await DatabaseHelper.getAllProducts();

    _inventories = List.generate(maps.length, (i) {
      return Inventory(
        code: maps[i]['code'] ?? '',
        designation: maps[i]['designation'] ?? '',
        barcode: maps[i]['barcode'] ?? '',
        quantity: maps[i]['quantity'] ?? 0,
        date: DateTime.tryParse(maps[i]['date'] ?? '') ?? DateTime.now(),
      );
    });

    notifyListeners();
    return _inventories;
  }

  Future<void> addInventory(Inventory inventory) async {
    await DatabaseHelper.insertProduct(
      Product(
        code: inventory.code,
        designation: inventory.designation,
        barcode: inventory.barcode,
      ),
    );

    await getInventories();
  }

  Future<List<Inventory>> getCompletedInventories() async {
    if (_inventories.isEmpty) {
      await getInventories();
    }

    return _inventories.where((i) => i.quantity != 0).toList();
  }
}
