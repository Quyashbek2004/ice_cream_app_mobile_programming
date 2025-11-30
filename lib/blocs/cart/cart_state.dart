// dart
// lib/blocs/cart/cart_state.dart
part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final String? errorMessage;

  const CartState({
    this.items = const [],
    this.errorMessage,
  });

  CartState copyWith({
    List<CartItem>? items,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  double get total =>
      items.fold(0, (sum, it) => sum + it.price * it.quantity);

  int get totalItems => items.fold(0, (s, it) => s + it.quantity);

  @override
  List<Object?> get props => [items, errorMessage];
}
