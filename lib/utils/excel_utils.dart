import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> exportToExcel() async {
  var excel = Excel.createExcel();
  var sheet = excel['Historique'];

  // Ajout de données fictives
  sheet.appendRow(['Code', 'Désignation', 'Code-barres', 'Quantité', 'Date']);
  sheet.appendRow(['P123', 'Produit A', '123456789', '10', DateTime.now().toString()]);

  var fileBytes = excel.encode();
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/inventaire.xlsx');
  file.writeAsBytesSync(fileBytes!);
}
