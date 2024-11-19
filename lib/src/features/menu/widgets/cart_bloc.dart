import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cart_event.dart';
import 'cart_state.dart';

/// Класс `CartBloc` отвечает за управление состоянием корзины.
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    // Обработка события добавления товара в корзину
    on<AddToCartEvent>((event, emit) {
      final currentCart = Map<String, CartItem>.from(state.cart);

      // Если товар уже есть в корзине, увеличиваем его количество
      currentCart.update(
        event.key,
        (existingItem) => CartItem(
          id: existingItem.id,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
        ifAbsent: () => CartItem(
          id: event.key,
          quantity: 1, // Если товара нет, добавляем с количеством 1
          price: event.price,
        ),
      );
      // Эмитим новое состояние с обновленной корзиной
      emit(CartUpdated(currentCart));
    });

    // Обработка события удаления товара из корзины.
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
        updatedCart.remove(event.key); // Удаляем товар, если его количество 0
      }

      emit(CartUpdated(updatedCart)); // Обновляем состояние корзины
    });

    // Обработка события очистки корзины.
    on<ClearCartEvent>((event, emit) {
      // Очищаем корзину
      emit(const CartUpdated({}));
    });

    // Обработка события оформления заказа.
    on<PlaceOrderEvent>((event, emit) async {
      try {
        final url = Uri.parse('https://your-api-endpoint.com/orders');

        // Формируем тело запроса, отправляем корзину как JSON.
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(state.cart), // Отправляем корзину в JSON-формате
        );

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
