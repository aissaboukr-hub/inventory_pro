import 'package:flutter/material.dart';
import '../models/inventory.dart';

class ProductList extends StatelessWidget {
  final List<Inventory> products;
  final Function(Inventory) onTap;

  ProductList({required this.products, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final inventory = products[index];
        return ListTile(
          title: Text(inventory.designation),
          subtitle: Text('Code: ${inventory.code}, Quantité: ${inventory.quantity}'),
          onTap: () => onTap(inventory),
        );
      },
    );
  }
}
