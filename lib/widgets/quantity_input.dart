import 'package:flutter/material.dart';

class QuantityInput extends StatelessWidget {
  final int initialQuantity;
  final Function(int) onQuantityChanged;

  QuantityInput({required this.initialQuantity, required this.onQuantityChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Quantité'),
      controller: TextEditingController(text: initialQuantity.toString()),
      onChanged: (value) {
        final quantity = int.tryParse(value) ?? 0;
        onQuantityChanged(quantity);
      },
    );
  }
}
