// dart
// lib/models/cart_item.dart
import 'package:flutter_app/models/ice_cream.dart';

class CartItem {
  final IceCream iceCream;
  int quantity;

  CartItem({required this.iceCream, this.quantity = 1});

  double get total => iceCream.price * quantity;

  Map<String, dynamic> toMap() => {
    'id': iceCream.id,
    'quantity': quantity,
  };

  static CartItem fromMap(Map<String, dynamic> map, IceCream iceCream) =>
      CartItem(iceCream: iceCream, quantity: map['quantity'] as int);
}
