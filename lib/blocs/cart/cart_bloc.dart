// dart
// lib/blocs/cart/cart_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/ice_cream.dart';
import 'package:flutter_app/models/cart_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState(items: [])) {
    on<AddCartItem>((e, emit) {
      final items = List<CartItem>.from(state.items);
      final index = items.indexWhere((it) => it.iceCream.id == e.iceCream.id);
      if (index >= 0) {
        items[index].quantity += 1;
      } else {
        items.add(CartItem(iceCream: e.iceCream));
      }
      emit(CartState(items: items));
    });

    on<RemoveCartItem>((e, emit) {
      final items = state.items.where((it) => it.iceCream.id != e.id).toList();
      emit(CartState(items: items));
    });

    on<IncreaseQuantity>((e, emit) {
      final items = state.items.map((it) {
        if (it.iceCream.id == e.id) it.quantity += 1;
        return it;
      }).toList();
      emit(CartState(items: items));
    });

    on<DecreaseQuantity>((e, emit) {
      final items = state.items.map((it) {
        if (it.iceCream.id == e.id) it.quantity = (it.quantity - 1).clamp(1, 999);
        return it;
      }).where((it) => it.quantity > 0).toList();
      emit(CartState(items: items));
    });

    on<ClearCart>((e, emit) => emit(const CartState(items: [])));
  }
}
