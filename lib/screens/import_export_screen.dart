import 'package:flutter/material.dart';
import '../services/import_service.dart';
import '../utils/excel_utils.dart';

class ImportExportScreen extends StatelessWidget {
  final ImportService importService = ImportService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Import / Export")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => importService.importFromExcel(),
            child: Text("Importer Excel"),
          ),
          ElevatedButton(
            onPressed: () => exportToExcel(),
            child: Text("Exporter vers Excel"),
          ),
        ],
      ),
    );
  }
}
