import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../services/import_service.dart';
import '../utils/excel_utils.dart' as excel_utils;

class ImportExportScreen extends StatefulWidget {
  const ImportExportScreen({super.key});

  @override
  State<ImportExportScreen> createState() => _ImportExportScreenState();
}

class _ImportExportScreenState extends State<ImportExportScreen> {
  final ImportService importService = ImportService(DatabaseHelper());

  bool _loading = false;

  Future<void> _importExcel() async {
    setState(() => _loading = true);

    try {
      final result = await importService.importFromExcel();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result == null
                ? 'Import annulé'
                : '${result.importedCount} produits importés depuis ${result.source}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur import Excel : $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _importGoogleSheets() async {
    setState(() => _loading = true);

    try {
      final result = await importService.importFromGoogleSheets();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${result.importedCount} produits importés depuis ${result.source}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur import Google Sheets : $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _exportExcel() async {
    setState(() => _loading = true);

    try {
      final file = await excel_utils.exportToExcel();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fichier exporté : ${file.path}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur export Excel : $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import / Export'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _loading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: _importExcel,
                      child: const Text('Importer Excel'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _importGoogleSheets,
                      child: const Text('Importer Google Sheets'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _exportExcel,
                      child: const Text('Exporter Excel'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
