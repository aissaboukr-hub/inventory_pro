import 'package:flutter/material.dart';

import '../models/inventory.dart';
import '../viewmodels/inventory_viewmodel.dart';

class InventoryScreen extends StatelessWidget {
  InventoryScreen({super.key});

  final InventoryViewModel viewModel = InventoryViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des inventaires')),
      body: FutureBuilder<List<Inventory>>(
        future: viewModel.getInventories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text('Aucun produit'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final inventory = items[index];
              return ListTile(
                title: Text(inventory.designation),
                subtitle: Text(
                  'Code: ${inventory.code} | Qté: ${inventory.quantity}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
