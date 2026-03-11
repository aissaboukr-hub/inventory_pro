import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class InventoryExportRow {
  final String code;
  final String designation;
  final String barcode;
  final int quantite;
  final DateTime date;

  InventoryExportRow({
    required this.code,
    required this.designation,
    required this.barcode,
    required this.quantite,
    required this.date,
  });
}

Future<File> exportInventoryToExcel(List<InventoryExportRow> rows) async {
  final excel = Excel.createExcel();

  final historySheet = excel['Historique'];
  final totalsSheet = excel['Totaux'];

  historySheet.appendRow([
    TextCellValue('code'),
    TextCellValue('designation'),
    TextCellValue('barcode'),
    TextCellValue('quantite'),
    TextCellValue('date'),
  ]);

  final Map<String, int> totals = {};

  for (final row in rows) {
    historySheet.appendRow([
      TextCellValue(row.code),
      TextCellValue(row.designation),
      TextCellValue(row.barcode),
      IntCellValue(row.quantite),
      TextCellValue(row.date.toIso8601String()),
    ]);

    totals[row.code] = (totals[row.code] ?? 0) + row.quantite;
  }

  totalsSheet.appendRow([
    TextCellValue('code'),
    TextCellValue('quantite_totale'),
  ]);

  totals.forEach((code, total) {
    totalsSheet.appendRow([
      TextCellValue(code),
      IntCellValue(total),
    ]);
  });

  final fileBytes = excel.encode();
  if (fileBytes == null) {
    throw Exception('Impossible de générer le fichier Excel.');
  }

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/inventaire_export.xlsx');

  await file.writeAsBytes(fileBytes, flush: true);

  return file;
}
