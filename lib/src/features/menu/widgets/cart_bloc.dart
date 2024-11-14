import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddToCartEvent>((event, emit) {
      // Создаем новую карту на основе существующей
      final updatedCart = Map<String, int>.from(state.cart);
      updatedCart.update(event.key, (value) => value + 1, ifAbsent: () => 1);
      emit(CartUpdated(updatedCart));
    });

    on<RemoveFromCartEvent>((event, emit) {
      final updatedCart = Map<String, int>.from(state.cart);
      if (updatedCart[event.key] != null && updatedCart[event.key]! > 0) {
        updatedCart.update(event.key, (value) => value - 1);
      }
      emit(CartUpdated(updatedCart));
    });

    on<ClearCartEvent>((event, emit) => emit(const CartUpdated({})));

    on<PlaceOrderEvent>((event, emit) async {
      try {
        final url = Uri.parse('https://your-api-endpoint.com/orders');
        final response = await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(state.cart));

        if (response.statusCode == 200) {
          emit(const OrderPlaced());
        } else {
          emit(OrderFailed(response.body));
        }
      } catch (e) {
        emit(OrderFailed('Ошибка: $e'));
      }
    });
  }
}
