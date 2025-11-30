// dart
// lib/blocs/cart/cart_event.dart
part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddCartItem extends CartEvent {
  final IceCream iceCream;

  const AddCartItem(this.iceCream);

  @override
  List<Object> get props => [iceCream];
}

class UpdateCartItemQuantity extends CartEvent {
  final IceCream iceCream;
  final int quantity;

  const UpdateCartItemQuantity(this.iceCream, this.quantity);

  @override
  List<Object> get props => [iceCream, quantity];
}

class LoadCart extends CartEvent {
  const LoadCart();

  @override
  List<Object> get props => [];
}
