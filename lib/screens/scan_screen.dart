import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../viewmodels/scan_viewmodel.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ScanViewModel viewModel = ScanViewModel();
  final MobileScannerController controller = MobileScannerController();

  bool _isHandlingScan = false;

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_isHandlingScan) return;

    final Barcode? barcode =
        capture.barcodes.isNotEmpty ? capture.barcodes.first : null;

    final String? code = barcode?.rawValue;

    if (code == null || code.trim().isEmpty) {
      return;
    }

    _isHandlingScan = true;

    await viewModel.searchProduct(code);

    if (!mounted) return;

    final product = viewModel.scannedProduct;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          product != null
              ? 'Produit trouvé : ${product.designation}'
              : 'Produit non trouvé : $code',
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 800));
    _isHandlingScan = false;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner de code-barres'),
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: _handleDetection,
      ),
    );
  }
}
