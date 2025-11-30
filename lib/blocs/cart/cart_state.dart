// dart
// lib/blocs/cart/cart_state.dart
part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  const CartState({required this.items});

  double get total =>
      items.fold(0, (sum, it) => sum + it.iceCream.price * it.quantity);

  int get totalItems => items.fold(0, (s, it) => s + it.quantity);

  @override
  List<Object?> get props => [items, total];
}
