import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart_event.dart';
import 'cart_state.dart';

/// Класс `CartBloc` отвечает за управление состоянием корзины.
class CartBloc extends Bloc<CartEvent, CartState> {
  // Инициализация BLoC с начальными данными.
  CartBloc() : super(CartInitial()) {
    // Суперкласс `Bloc` вызывает конструктор с начальным состоянием `CartInitial`.

    // Обработка события добавления товара в корзину.
    on<AddToCartEvent>((event, emit) {
      // Создаем копию текущей корзины из состояния.
      final updatedCart = Map<String, int>.from(state.cart);

      // Обновляем количество товара:
      // Если товар уже есть в корзине, увеличиваем количество на 1.
      // Если товара нет, добавляем его с количеством 1.
      updatedCart.update(event.key, (value) => value + 1, ifAbsent: () => 1);

      // Обновляем состояние с новой корзиной.
      emit(CartUpdated(updatedCart));
    });

    // Обработка события удаления товара из корзины.
    on<RemoveFromCartEvent>((event, emit) {
      // Создаем копию текущей корзины.
      final updatedCart = Map<String, int>.from(state.cart);

      // Если товар есть в корзине и его количество больше 0,
      // уменьшаем количество на 1.
      if (updatedCart[event.key] != null && updatedCart[event.key]! > 0) {
        updatedCart.update(event.key, (value) => value - 1);
      }

      // Обновляем состояние с новой корзиной.
      emit(CartUpdated(updatedCart));
    });

    // Обработка события очистки корзины.
    on<ClearCartEvent>((event, emit) {
      // Сбрасываем корзину до пустого состояния.
      emit(const CartUpdated({}));
    });

    // Обработка события оформления заказа.
    on<PlaceOrderEvent>((event, emit) async {
      try {
        // URL API для отправки данных о заказе.
        final url = Uri.parse('https://your-api-endpoint.com/orders');

        // Выполняем POST-запрос с содержимым корзины.
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json'
          }, // Указываем тип данных.
          body: jsonEncode(state.cart), // Преобразуем корзину в JSON.
        );

        // Если сервер вернул успешный ответ (код 200).
        if (response.statusCode == 200) {
          // Уведомляем об успешном оформлении заказа.
          emit(const OrderPlaced());
        } else {
          // Если сервер вернул ошибку, отправляем состояние ошибки.
          emit(OrderFailed(response.body));
        }
      } catch (e) {
        // Если произошла ошибка сети или другая ошибка,
        // отправляем состояние с сообщением об ошибке.
        emit(OrderFailed('Ошибка: $e'));
      }
    });
  }
}
