import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../viewmodels/scan_viewmodel.dart';

class ScanScreen extends StatelessWidget {
  final ScanViewModel viewModel = ScanViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scanner de Code-barres")),
      body: MobileScanner(
        onDetect: (barcode, args) {
          final code = barcode.rawValue;
          viewModel.searchProduct(code);
        },
      ),
    );
  }
}
