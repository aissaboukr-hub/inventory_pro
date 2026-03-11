import 'package:flutter/material.dart';
import 'screens/inventory_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/import_export_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application d\'Inventaire',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: InventoryScreen(),
      routes: {
        '/scan': (context) => ScanScreen(),
        '/import_export': (context) => ImportExportScreen(),
      },
    );
  }
}
