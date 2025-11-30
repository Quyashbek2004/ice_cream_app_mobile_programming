import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order.dart';
import 'cart_service.dart';

class OrderService {
  OrderService({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
    CartService? cartService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _cartService = cartService ?? CartService();

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final CartService _cartService;

  /// Creates an order from the current cart contents. Validation is kept on the
  /// server side to ensure totals match what the client displays.
  Future<OrderSummary> placeOrder({
    required String address,
    required String phone,
    String? customerName,
  }) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User not authenticated');
    }

    final cartItems = await _cartService.fetchCart();
    if (cartItems.isEmpty) {
      throw Exception('Cart is empty');
    }

    double total = 0;
    final orderItems = <OrderItem>[];
    for (final item in cartItems) {
      total += item.subtotal;
      orderItems.add(
        OrderItem(
          productId: item.productId,
          name: item.name,
          quantity: item.quantity,
          unitPrice: item.price,
        ),
      );
    }

    final now = DateTime.now();
    final ordersCollection = _firestore.collection('orders');

    final orderRef = await ordersCollection.add({
      'userId': uid,
      'status': 'placed',
      'totalAmount': total,
      'address': address,
      'phone': phone,
      'customerName': customerName ?? '',
      'createdAt': Timestamp.fromDate(now),
      'itemCount': orderItems.fold<int>(0, (sum, item) => sum + item.quantity),
    });

    // Persist order items in a subcollection to keep a normalized structure.
    final batch = _firestore.batch();
    for (final item in orderItems) {
      batch.set(orderRef.collection('items').doc(), item.toMap());
    }
    await batch.commit();

    // Cart cleanup happens after order is written to avoid accidental loss.
    await _cartService.clearCart();

    return OrderSummary(
      id: orderRef.id,
      totalAmount: total,
      itemCount: orderItems.fold<int>(0, (sum, item) => sum + item.quantity),
      createdAt: now,
    );
  }

  Stream<List<OrderSummary>> userOrders() {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => OrderSummary(
                  id: doc.id,
                  totalAmount: (doc.data()['totalAmount'] as num).toDouble(),
                  itemCount: doc.data()['itemCount'] as int,
                  createdAt: (doc.data()['createdAt'] as Timestamp).toDate(),
                ),
              )
              .toList(),
        );
  }
}
