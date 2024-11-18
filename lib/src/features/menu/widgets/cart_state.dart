import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {
  final Map<String, int> cart;

  const CartState({required this.cart});

  @override
  List<Object> get props => [cart];
}

// Класс CartInitial представляет начальное состояние корзины.
// В конструкторе вызывается конструктор родительского класса super(cart: {}),
// передавая пустую карту {} (означает, что корзина изначально пуста).
class CartInitial extends CartState {
  CartInitial() : super(cart: {});
}

// Этот класс используется, когда корзина обновляется
// (например, добавляется новый товар или изменяется количество).
class CartUpdated extends CartState {
  const CartUpdated(Map<String, int> cart) : super(cart: cart);
}

// При создании состояния OrderPlaced мы передаем в корзину пустую карту {},
// так как после оформления заказа корзина должна быть очищена
class OrderPlaced extends CartState {
  const OrderPlaced() : super(cart: const {}); // Передаем пустую карту
}

// состояние, когда заказ не удалось оформить
// (корзина очищена, сообщение об ошибке).
class OrderFailed extends CartState {
  final String errorMessage;

  const OrderFailed(this.errorMessage) : super(cart: const {});
}
// Состояния (CartState) представляют текущую "снимок состояния" корзины.