import 'package:flutter/material.dart';
import '../models/inventory.dart';
import '../services/database_helper.dart';

class InventoryViewModel extends ChangeNotifier {
  List<Inventory> _inventories = [];

  List<Inventory> get inventories => _inventories;

  Future<void> getInventories() async {
    final database = await DatabaseHelper.init();
    final List<Map<String, dynamic>> maps = await database.query('products');
    _inventories = List.generate(maps.length, (i) {
      return Inventory(
        code: maps[i]['code'],
        designation: maps[i]['designation'],
        barcode: maps[i]['barcode'],
        quantity: maps[i]['quantity'],
        date: DateTime.parse(maps[i]['date']),
      );
    });
    notifyListeners();
  }

  Future<void> addInventory(Inventory inventory) async {
    await DatabaseHelper.insertProduct(Product(
      code: inventory.code,
      designation: inventory.designation,
      barcode: inventory.barcode,
    ));
    await getInventories();
  }

  Future<List<Inventory>> getCompletedInventories() async {
    final completedInventories = _inventories.where((i) => i.quantity > 0).toList();
    return completedInventories;
  }
}
