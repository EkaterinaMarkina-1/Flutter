import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id;
  final int quantity;
  final double price;

  const CartItem(
      {required this.id, required this.quantity, required this.price});

  @override
  List<Object?> get props => [id, quantity, price];
}

abstract class CartState extends Equatable {
  final Map<String, CartItem> cart;

  const CartState({required this.cart});

  double get totalCost {
    return cart.values
        .map((item) => item.price * item.quantity)
        .reduce((a, b) => a + b);
  }

  @override
  List<Object> get props => [cart];
}

class CartInitial extends CartState {
  CartInitial() : super(cart: {});
}

class CartUpdated extends CartState {
  const CartUpdated(Map<String, CartItem> cart) : super(cart: cart);
}
