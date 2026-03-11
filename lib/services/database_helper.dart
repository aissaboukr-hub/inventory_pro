import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

class DatabaseHelper {
  static Future<Database> init() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'inventory.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE products(code TEXT PRIMARY KEY, designation TEXT, barcode TEXT, quantity INTEGER, date TEXT)",
        );
      },
      version: 1,
    );
  }

  static Future<void> insertProduct(Product product) async {
    final Database db = await DatabaseHelper.init();
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
