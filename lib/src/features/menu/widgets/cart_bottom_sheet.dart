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
      // Этот BlocBuilder слушает состояние `CartBloc` и перестраивает виджет,
      // когда состояние корзины (`CartState`) меняется.
      builder: (context, state) {
        // Основной контейнер для нижнего листа.
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Колонка занимает минимально возможную высоту.
            children: [
              // Расширяемый список товаров в корзине.
              Expanded(
                child: ListView.builder(
                  // Количество элементов в корзине.
                  itemCount: state.cart.length,
                  itemBuilder: (context, index) {
                    // Получаем текущую пару: ключ (товар) и количество (значение).
                    final entry = state.cart.entries.elementAt(index);
                    final key = entry.key; // Ключ для определения товара.
                    final quantity = entry.value; // Количество товара.

                    // Разбираем ключ, чтобы получить категорию и индекс товара.
                    final parts = key.split('_');
                    final category =
                        parts[0]; // Категория товара (например, "coffee").
                    final itemIndex =
                        int.parse(parts[1]); // Индекс товара в категории.

                    // Извлекаем имя товара из `CoffeeData`.
                    final productName =
                        CoffeeData.coffeeInfo[category]!["products"][itemIndex];
                    // Извлекаем цену товара из `CoffeeData`.
                    final priceString =
                        CoffeeData.coffeeInfo[category]!["prices"][productName];

                    // Преобразуем цену в `double`, если она представлена как строка.
                    final price =
                        double.tryParse(priceString.toString()) ?? 0.0;

                    // Создаем элемент списка с возможностью удаления.
                    return Dismissible(
                      key: Key(key), // Уникальный ключ для анимации удаления.
                      onDismissed: (direction) {
                        // Обработка удаления элемента свайпом.
                        context.read<CartBloc>().add(RemoveFromCartEvent(key));
                      },
                      child: ListTile(
                        title: Text(productName), // Название товара.
                        subtitle:
                            Text('$price ₽ x $quantity'), // Цена и количество.
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
                  // Вывод итоговой суммы с двумя знаками после запятой.
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              // Кнопка "Оформить заказ".
              ElevatedButton(
                onPressed: () =>
                    context.read<CartBloc>().add(PlaceOrderEvent()),
                // Отправляет событие оформления заказа в `CartBloc`.
                child: const Text('Оформить заказ'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Вспомогательный метод для подсчета общей стоимости корзины.
  double _calculateTotalCost(Map<String, int> cart) {
    double total = 0;
    // Проходимся по всем товарам в корзине.
    cart.forEach((key, quantity) {
      final parts = key.split('_'); // Разделяем ключ, чтобы извлечь данные.
      final category = parts[0]; // Категория товара.
      final itemIndex = int.parse(parts[1]); // Индекс товара в категории.
      final priceString = CoffeeData.coffeeInfo[category]!["prices"]
          [CoffeeData.coffeeInfo[category]!["products"][itemIndex]];

      // Преобразуем цену в `double`, если она представлена как строка.
      final price = double.tryParse(priceString.toString()) ?? 0.0;

      // Увеличиваем итоговую сумму: цена * количество.
      total += price * quantity;
    });
    return total; // Возвращаем общую сумму.
  }
}
