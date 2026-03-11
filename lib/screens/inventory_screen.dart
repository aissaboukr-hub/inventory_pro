import 'package:flutter/material.dart';

import '../models/inventory.dart';
import '../viewmodels/inventory_viewmodel.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = InventoryViewModel();

    return FutureBuilder<List<Inventory>>(
      future: viewModel.getInventories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Erreur : ${snapshot.error}'),
            ),
          );
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Aucun produit dans la base.\n\nCommencez par importer un fichier Excel ou Google Sheets.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              leading: const Icon(Icons.inventory_2),
              title: Text(
                item.designation.isEmpty ? 'Sans désignation' : item.designation,
              ),
              subtitle: Text(
                'Code: ${item.code} | Barcode: ${item.barcode} | Qté: ${item.quantity}',
              ),
            );
          },
        );
      },
    );
  }
}
