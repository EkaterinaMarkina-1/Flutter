import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Событие для добавления товара в корзину
class AddToCartEvent extends CartEvent {
  final String key;

  AddToCartEvent(this.key);

  @override
  List<Object> get props => [key];
}

// Событие для удаления товара из корзины
class RemoveFromCartEvent extends CartEvent {
  final String key;

  RemoveFromCartEvent(this.key);

  @override
  List<Object> get props => [key];
}

// Событие для очистки корзины
class ClearCartEvent extends CartEvent {
  @override
  List<Object> get props => [];
}

// Событие для оформления заказа.
class PlaceOrderEvent extends CartEvent {
  @override
  List<Object> get props => [];
}

// События (CartEvent) описывают действия,
// которые могут быть выполнены в отношении корзины.