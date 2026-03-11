class Product {
  final String code;
  final String designation;
  final String barcode;

  Product({
    required this.code,
    required this.designation,
    required this.barcode,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'designation': designation,
      'barcode': barcode,
      'quantity': 0,
      'date': DateTime.now().toIso8601String(),
    };
  }
}

