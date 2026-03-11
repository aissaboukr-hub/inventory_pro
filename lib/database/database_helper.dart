import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/product.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> init() async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'inventory.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products(
            code TEXT PRIMARY KEY,
            designation TEXT,
            barcode TEXT,
            quantity INTEGER DEFAULT 0,
            date TEXT
          )
        ''');

        await db.execute(
          'CREATE INDEX idx_products_barcode ON products(barcode)',
        );

        await db.execute(
          'CREATE INDEX idx_products_designation ON products(designation)',
        );
      },
    );

    return _database!;
  }

  static Future<void> insertProduct(Product product) async {
    final db = await init();

    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertProductsBatch(List<Product> products) async {
    final db = await init();

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final product in products) {
        batch.insert(
          'products',
          product.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    });
  }

  static Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await init();
    return db.query('products', orderBy: 'designation ASC');
  }

  static Future<Map<String, dynamic>?> findProductByBarcode(String barcode) async {
    final db = await init();

    final result = await db.query(
      'products',
      where: 'barcode = ?',
      whereArgs: [barcode],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return result.first;
  }

  static Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    final db = await init();

    return db.query(
      'products',
      where: '''
        designation LIKE ? OR
        code LIKE ? OR
        barcode LIKE ?
      ''',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'designation ASC',
      limit: 100,
    );
  }

  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
