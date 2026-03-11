import 'package:flutter/material.dart';
import '../models/inventory.dart';
import '../viewmodels/inventory_viewmodel.dart';

class HistoryScreen extends StatelessWidget {
  final InventoryViewModel viewModel = InventoryViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historique des Inventaires")),
      body: FutureBuilder<List<Inventory>>(
        future: viewModel.getCompletedInventories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final inventory = snapshot.data![index];
                return ListTile(
                  title: Text(inventory.designation),
                  subtitle: Text('Code: ${inventory.code}, Quantité: ${inventory.quantity}'),
                  onTap: () {
                    // Afficher les détails de l'inventaire
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
