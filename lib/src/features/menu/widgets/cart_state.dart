import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {
  final Map<String, int> cart;

  const CartState(
      {this.cart = const {}}); // Используем константное значение по умолчанию

  @override
  List<Object> get props => [cart];
}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  const CartUpdated(Map<String, int> cart) : super(cart: cart);
}

class OrderPlaced extends CartState {
  const OrderPlaced() : super(cart: const {}); // Передаем пустую карту
}

class OrderFailed extends CartState {
  final String errorMessage;

  const OrderFailed(this.errorMessage) : super(cart: const {});
}
