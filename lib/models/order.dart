/// Lightweight model used for confirmation UI and history queries.
class OrderSummary {
  final String id;
  final double totalAmount;
  final int itemCount;
  final DateTime createdAt;

  OrderSummary({
    required this.id,
    required this.totalAmount,
    required this.itemCount,
    required this.createdAt,
  });
}

class OrderItem {
  final String productId;
  final String name;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  double get subtotal => unitPrice * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'subtotal': subtotal,
    };
  }
}
