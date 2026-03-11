class Inventory {
  String code;
  String designation;
  String barcode;
  int quantity;
  DateTime date;

  Inventory({
    required this.code,
    required this.designation,
    required this.barcode,
    this.quantity = 0,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'designation': designation,
      'barcode': barcode,
      'quantity': quantity,
      'date': date.toIso8601String(),
    };
  }
}
