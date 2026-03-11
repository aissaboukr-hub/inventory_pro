import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

Future<File> exportToExcel() async {
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

  historySheet.appendRow([
    TextCellValue('P123'),
    TextCellValue('Produit A'),
    TextCellValue('123456789'),
    IntCellValue(10),
    TextCellValue(DateTime.now().toIso8601String()),
  ]);

  totalsSheet.appendRow([
    TextCellValue('code'),
    TextCellValue('quantite_totale'),
  ]);

  totalsSheet.appendRow([
    TextCellValue('P123'),
    IntCellValue(10),
  ]);

  final fileBytes = excel.encode();
  if (fileBytes == null) {
    throw Exception('Impossible de générer le fichier Excel.');
  }

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/inventaire.xlsx');

  await file.writeAsBytes(fileBytes, flush: true);

  return file;
}
