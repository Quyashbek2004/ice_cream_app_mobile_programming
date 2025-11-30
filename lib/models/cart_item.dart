import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/ice_cream.dart';

class CartItem {
  final String id;
  final IceCream iceCream;
  int quantity;

  CartItem({
    required this.id,
    required this.iceCream,
    this.quantity = 1,
  });

  String get productId => iceCream.id;
  String get name => iceCream.name;
  String get imageUrl => iceCream.imageUrl;
  double get price => iceCream.price;
  double get total => iceCream.price * quantity;
  double get subtotal => iceCream.price * quantity;

  Map<String, dynamic> toMap() => {
    'productId': iceCream.id,
    'name': iceCream.name,
    'imageUrl': iceCream.imageUrl,
    'price': iceCream.price,
    'quantity': quantity,
  };

  factory CartItem.fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return CartItem(
      id: doc.id,
      iceCream: IceCream(
        id: data['productId'] ?? '',
        name: data['name'] ?? '',
        description: '',
        price: (data['price'] ?? 0).toDouble(),
        imageUrl: data['imageUrl'] ?? '',
        tags: [],
        macros: [],
      ),
      quantity: data['quantity'] ?? 1,
    );
  }
}
