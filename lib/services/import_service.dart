import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../database/database_helper.dart';
import '../models/product.dart';
import 'google_sheets_service.dart';

class ImportService {
  final DatabaseHelper _dbHelper;

  ImportService(this._dbHelper);

  Future<ImportResult?> importFromExcel() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final PlatformFile pickedFile = result.files.first;

    Uint8List bytes;
    if (pickedFile.bytes != null) {
      bytes = pickedFile.bytes!;
    } else if (pickedFile.path != null) {
      bytes = await File(pickedFile.path!).readAsBytes();
    } else {
      throw Exception('Impossible de lire le fichier sélectionné.');
    }

    final List<Product> products = await compute(_parseExcelInIsolate, bytes);

    await DatabaseHelper.insertProductsBatch(products);

    return ImportResult(
      importedCount: products.length,
      source: pickedFile.name,
    );
  }

  Future<ImportResult> importFromGoogleSheets() async {
    final rows = await GoogleSheetsService.fetchProducts();

    final products = rows.map((row) {
      return Product(
        code: _readValue(row, ['code', 'product_code', 'code produit']),
        designation: _readValue(row, ['designation', 'name', 'désignation']),
        barcode: _readValue(row, ['barcode', 'codebarres', 'code-barres']),
      );
    }).where((p) {
      return p.code.trim().isNotEmpty ||
          p.designation.trim().isNotEmpty ||
          p.barcode.trim().isNotEmpty;
    }).toList();

    await DatabaseHelper.insertProductsBatch(products);

    return ImportResult(
      importedCount: products.length,
      source: 'Google Sheets',
    );
  }

  static List<Product> _parseExcelInIsolate(Uint8List bytes) {
    final excel = Excel.decodeBytes(bytes);
    final List<Product> products = [];

    for (final sheetName in excel.tables.keys) {
      final sheet = excel.tables[sheetName];
      if (sheet == null || sheet.rows.isEmpty) continue;

      final headerRow = sheet.rows.first;
      final headerMap = _detectColumns(headerRow);

      for (int i = 1; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];
        if (row.isEmpty) continue;

        final code = _cellValue(row, headerMap['code']);
        final designation = _cellValue(row, headerMap['designation']);
        final barcode = _cellValue(row, headerMap['barcode']);

        if (code.isEmpty && designation.isEmpty && barcode.isEmpty) {
          continue;
        }

        products.add(
          Product(
            code: code,
            designation: designation,
            barcode: barcode,
          ),
        );
      }
    }

    return products;
  }

  static Map<String, int> _detectColumns(List<Data?> headerRow) {
    final Map<String, int> map = {};

    for (int i = 0; i < headerRow.length; i++) {
      final value = (headerRow[i]?.value?.toString() ?? '')
          .trim()
          .toLowerCase();

      if (value.isEmpty) continue;

      if (_matchesAny(value, [
        'code produit',
        'code_produit',
        'product code',
        'product_code',
        'reference',
        'référence',
        'ref',
        'code',
      ])) {
        map['code'] = i;
      } else if (_matchesAny(value, [
        'designation',
        'désignation',
        'nom',
        'name',
        'libelle',
        'libellé',
        'produit',
        'product',
      ])) {
        map['designation'] = i;
      } else if (_matchesAny(value, [
        'barcode',
        'bar code',
        'code barre',
        'code-barres',
        'code barres',
        'ean',
        'upc',
      ])) {
        map['barcode'] = i;
      }
    }

    return map;
  }

  static bool _matchesAny(String value, List<String> candidates) {
    return candidates.contains(value);
  }

  static String _cellValue(List<Data?> row, int? index) {
    if (index == null || index < 0 || index >= row.length) return '';
    return row[index]?.value?.toString().trim() ?? '';
  }

  static String _readValue(Map<String, dynamic> row, List<String> keys) {
    for (final key in keys) {
      for (final entry in row.entries) {
        if (entry.key.trim().toLowerCase() == key.trim().toLowerCase()) {
          return (entry.value ?? '').toString().trim();
        }
      }
    }
    return '';
  }
}

class ImportResult {
  final int importedCount;
  final String source;

  ImportResult({
    required this.importedCount,
    required this.source,
  });
}
