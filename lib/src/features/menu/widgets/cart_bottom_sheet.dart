import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1_menu/src/features/menu/data/coffee_data.dart';
import 'cart_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

/// Виджет нижнего листа для отображения корзины.
class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      // Слушаем состояние корзины.
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Список товаров в корзине.
              Expanded(
                child: ListView.builder(
                  itemCount: state.cart.length,
                  itemBuilder: (context, index) {
                    final entry = state.cart.entries.elementAt(index);
                    final key = entry.key;
                    final quantity = entry.value.quantity;
                    final category = key.split('_')[0];
                    final itemIndex = int.parse(key.split('_')[1]);

                    // Получаем имя товара и цену из данных.
                    final productName =
                        CoffeeData.coffeeInfo[category]!["products"][itemIndex];
                    final price =
                        CoffeeData.coffeeInfo[category]!["prices"][itemIndex];

                    // Создаем элемент списка с возможностью удаления.
                    return Dismissible(
                      key: Key(key),
                      onDismissed: (direction) {
                        // Удаляем товар из корзины.
                        context.read<CartBloc>().add(RemoveFromCartEvent(key));
                      },
                      child: ListTile(
                        title: Text(productName),
                        subtitle: Text('$price ₽ x $quantity'),
                      ),
                    );
                  },
                ),
              ),
              // Отображение общей стоимости корзины.
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Итого: ${_calculateTotalCost(state.cart).toStringAsFixed(2)} ₽',
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              // Кнопка "Оформить заказ".
              ElevatedButton(
                onPressed: () =>
                    context.read<CartBloc>().add(PlaceOrderEvent()),
                child: const Text('Оформить заказ'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Вспомогательный метод для подсчета общей стоимости корзины.
  double _calculateTotalCost(Map<String, CartItem> cart) {
    double total = 0;
    cart.forEach((key, value) {
      final category = key.split('_')[0];
      final itemIndex = int.parse(key.split('_')[1]);
      final price = CoffeeData.coffeeInfo[category]!["prices"][itemIndex];

      // Увеличиваем итоговую сумму: цена * количество.
      total += price * value.quantity;
    });
    return total;
  }
}
