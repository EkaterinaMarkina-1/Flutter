import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_bloc.dart';
import 'cart_state.dart';
import 'cart_event.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  // Функция для отправки POST-запроса на сервер
  Future<void> _placeOrder(BuildContext context) async {
    final cartBloc = context.read<CartBloc>();
    final cart = cartBloc.state.cart;

    // Подготавливаем данные для запроса
    final orderData = jsonEncode({
      'order': cart.entries.map((entry) {
        final quantity = entry.value.quantity;
        final productName = entry.value.id;
        final price = entry.value.price;

        return {
          'product': productName,
          'quantity': quantity,
          'price': price,
        };
      }).toList()
    });

    try {
      final response = await http.post(
        Uri.parse('https://example.com/api/order'), // Замените на ваш URL
        headers: {'Content-Type': 'application/json'},
        body: orderData,
      );

      // Проверяем, что запрос завершился успешно
      if (response.statusCode == 200 && context.mounted) {
        // Успех: очищаем корзину и показываем SnackBar
        cartBloc.add(ClearCartEvent());
        Navigator.of(context).pop(); // Закрытие BottomSheet

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Заказ успешно оформлен!')),
          );
        }
      } else {
        // Ошибка: показываем SnackBar с ошибкой
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Ошибка при оформлении заказа. Попробуйте позже.')),
          );
        }
      }
    } catch (e) {
      // Обработка ошибок, если запрос не удался
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Ошибка при оформлении заказа. Попробуйте позже.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartUpdated) {
          final cart = state.cart;

          // Если корзина пуста, отображаем сообщение
          if (cart.isEmpty) {
            return const Center(
              child: Text(
                'Ваша корзина пуста',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Корзина',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final entry = cart.entries.elementAt(index);
                      final key = entry.key;
                      final quantity = entry.value.quantity;

                      final productName = entry.value.id;
                      final price = entry.value.price;

                      return ListTile(
                        title: Text(productName),
                        subtitle: Text('$price ₽ x $quantity'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle),
                          onPressed: () {
                            context.read<CartBloc>().add(
                                  RemoveFromCartEvent(key),
                                );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Итого: ${state.totalCost.toStringAsFixed(2)} ₽',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _placeOrder(context),
                  child: const Text('Оформить заказ'),
                ),
              ],
            ),
          );
        }

        if (state is CartInitial) {
          return const Center(
            child: Text(
              'Корзина пуста',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
