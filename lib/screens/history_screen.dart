import 'package:flutter/material.dart';

import '../models/inventory.dart';
import '../viewmodels/inventory_viewmodel.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = InventoryViewModel();

    return FutureBuilder<List<Inventory>>(
      future: viewModel.getCompletedInventories(),
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
            child: Text('Aucun historique disponible'),
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              leading: const Icon(Icons.history),
              title: Text(item.designation),
              subtitle: Text(
                'Code: ${item.code} | Qté: ${item.quantity}\nDate: ${item.date}',
              ),
            );
          },
        );
      },
    );
  }
}
