import 'package:equatable/equatable.dart';

// Класс для представления товара в корзине, включая цену
class CartItem extends Equatable {
  final String id; // ID товара
  final int quantity; // Количество
  final double price; // Цена товара

  const CartItem(
      {required this.id, required this.quantity, required this.price});

  @override
  List<Object?> get props => [id, quantity, price];
}

abstract class CartState extends Equatable {
  final Map<String, CartItem> cart;

  const CartState({required this.cart});

  // Метод для вычисления общей стоимости с использованием reduce
  double get totalCost {
    // Применяем reduce для вычисления общей стоимости
    return cart.values
        .map((item) =>
            item.price *
            item.quantity) // Вычисляем стоимость для каждого товара
        .reduce((a, b) => a + b); // Суммируем все стоимости
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

class OrderPlaced extends CartState {
  const OrderPlaced() : super(cart: const {}); // Now valid
}

class OrderFailed extends CartState {
  final String errorMessage;

  const OrderFailed(this.errorMessage) : super(cart: const {}); // Now valid
}
