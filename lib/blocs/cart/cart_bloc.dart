// dart
// lib/blocs/cart/cart_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/cart_item.dart';
import 'package:flutter_app/models/ice_cream.dart';
import 'package:flutter_app/services/cart_service.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService _cartService;

  CartBloc({required CartService cartService})
      : _cartService = cartService,
        super(const CartState()) {
    on<AddCartItem>(_onAddCartItem);
    on<UpdateCartItemQuantity>(_onUpdateQuantity);
    on<LoadCart>(_onLoadCart);
  }

  Future<void> _onAddCartItem(
    AddCartItem event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartService.addToCart(event.iceCream);
      final cartItems = await _cartService.fetchCart();
      emit(CartState(items: cartItems));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to add item to cart'));
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      // Find the cart item by productId
      final existingItem = state.items
          .firstWhere((item) => item.productId == event.iceCream.id);
      await _cartService.updateQuantity(existingItem.id, event.quantity);

      final cartItems = await _cartService.fetchCart();
      emit(CartState(items: cartItems));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to update cart'));
    }
  }

  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final cartItems = await _cartService.fetchCart();
      emit(CartState(items: cartItems));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to load cart'));
    }
  }
}
