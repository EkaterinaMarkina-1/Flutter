import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddToCartEvent extends CartEvent {
  final String key;
  final double price; // Добавляем цену

  AddToCartEvent({required this.key, required this.price});

  @override
  List<Object> get props => [key, price];
}

// Событие для удаления товара из корзины
class RemoveFromCartEvent extends CartEvent {
  final String key;

  RemoveFromCartEvent(this.key);

  @override
  List<Object> get props => [key];
}

// Событие для очистки корзины
class ClearCartEvent extends CartEvent {}

// Событие для оформления заказа
class PlaceOrderEvent extends CartEvent {}
