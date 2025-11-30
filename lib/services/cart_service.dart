import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cart_item.dart';
import '../models/ice_cream.dart';

class CartService {
  CartService({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  CollectionReference<Map<String, dynamic>> _cartCollection(String uid) =>
      _firestore.collection('users').doc(uid).collection('cart');

  /// Stream of cart items for the signed-in user. Used in Cart and Checkout
  /// screens so we always render the same state.
  Stream<List<CartItem>> cartStream() {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return const Stream.empty();
    }
    return _cartCollection(uid).snapshots().map(
      (snapshot) => snapshot.docs.map(CartItem.fromDocument).toList(),
    );
  }

  Future<List<CartItem>> fetchCart() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return [];
    }
    final snapshot = await _cartCollection(uid).get();
    return snapshot.docs.map(CartItem.fromDocument).toList();
  }

  Future<void> addToCart(IceCream iceCream) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return;

    final cartCollection = _cartCollection(uid);
    // Match cart items by productId so multiple taps increment quantity.
    final existing = await cartCollection
        .where('productId', isEqualTo: iceCream.id)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      final doc = existing.docs.first;
      final currentQty = (doc.data()['quantity'] as int);
      await doc.reference.update({'quantity': currentQty + 1});
    } else {
      await cartCollection.add({
        'productId': iceCream.id,
        'name': iceCream.name,
        'imageUrl': iceCream.imageUrl,
        'price': iceCream.price,
        'quantity': 1,
      });
    }
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return;
    if (quantity <= 0) {
      await _cartCollection(uid).doc(cartItemId).delete();
    } else {
      await _cartCollection(uid).doc(cartItemId).update({'quantity': quantity});
    }
  }

  Future<void> clearCart() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return;
    final batch = _firestore.batch();
    final items = await _cartCollection(uid).get();
    for (final doc in items.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
