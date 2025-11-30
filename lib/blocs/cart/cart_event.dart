// dart
// lib/blocs/cart/cart_event.dart
part of 'cart_bloc.dart';

abstract class CartEvent {}

class AddCartItem extends CartEvent {
  final IceCream iceCream;
  AddCartItem(this.iceCream);
}

class RemoveCartItem extends CartEvent {
  final String id;
  RemoveCartItem(this.id);
}

class IncreaseQuantity extends CartEvent {
  final String id;
  IncreaseQuantity(this.id);
}

class DecreaseQuantity extends CartEvent {
  final String id;
  DecreaseQuantity(this.id);
}

class ClearCart extends CartEvent {}
