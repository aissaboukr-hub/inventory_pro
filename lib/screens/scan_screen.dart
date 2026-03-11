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

  bool _busy = false;

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_busy) return;

    final barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
    final code = barcode?.rawValue;

    if (code == null || code.trim().isEmpty) return;

    _busy = true;

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

    await Future.delayed(const Duration(milliseconds: 1000));
    _busy = false;
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: _handleDetection,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
