import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddToCartEvent>((event, emit) {
      final currentCart = Map<String, CartItem>.from(state.cart);
      currentCart.update(
        event.key,
        (existingItem) => CartItem(
          id: existingItem.id,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
        ifAbsent: () => CartItem(
          id: event.key,
          quantity: 1,
          price: event.price,
        ),
      );
      emit(CartUpdated(currentCart));
    });

    on<RemoveFromCartEvent>((event, emit) {
      final updatedCart = Map<String, CartItem>.from(state.cart);
      final cartItem = updatedCart[event.key];

      if (cartItem != null && cartItem.quantity > 1) {
        updatedCart.update(
          event.key,
          (existingItem) => CartItem(
            id: existingItem.id,
            quantity: existingItem.quantity - 1,
            price: existingItem.price,
          ),
        );
      } else {
        updatedCart.remove(event.key);
      }

      emit(CartUpdated(updatedCart));
    });

    on<ClearCartEvent>((event, emit) {
      emit(const CartUpdated({}));
    });
  }
}
