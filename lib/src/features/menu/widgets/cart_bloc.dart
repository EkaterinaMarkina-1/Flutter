import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart_event.dart';
import 'cart_state.dart';

/// Класс `CartBloc` отвечает за управление состоянием корзины.
class CartBloc extends Bloc<CartEvent, CartState> {
  // Инициализация BLoC с начальными данными.
  CartBloc() : super(CartInitial()) {
    // Обработка события добавления товара в корзину.
    on<AddToCartEvent>((event, emit) {
      final updatedCart = Map<String, CartItem>.from(state.cart);

      // Обновляем количество товара в корзине или добавляем новый товар, если его нет.
      updatedCart.update(
        event.key,
        (value) => CartItem(
          id: value.id,
          quantity: value.quantity + 1, // Увеличиваем количество товара
          price: event.price, // Цена товара
        ),
        ifAbsent: () => CartItem(
          id: event.key,
          quantity: 1, // Если товара нет в корзине, добавляем с количеством 1
          price: event.price, // Преобразуем строковую цену в double
        ),
      );

      // Отправляем обновлённое состояние корзины
      emit(CartUpdated(updatedCart));
    });

    // Обработка события удаления товара из корзины.
    on<RemoveFromCartEvent>((event, emit) {
      final updatedCart = Map<String, CartItem>.from(state.cart);
      final cartItem = updatedCart[event.key];

      // Уменьшаем количество товара или удаляем его, если количество стало 0.
      if (cartItem != null && cartItem.quantity > 1) {
        updatedCart.update(
          event.key,
          (value) => CartItem(
            id: value.id,
            quantity: value.quantity - 1, // Уменьшаем количество товара
            price: value.price,
          ),
        );
      } else {
        updatedCart.remove(event.key); // Удаляем товар, если его количество 0
      }

      // Отправляем обновлённое состояние корзины
      emit(CartUpdated(updatedCart));
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
