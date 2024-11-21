import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_bloc.dart';
import 'cart_state.dart';
import 'cart_event.dart';
import 'package:lab_1_menu/src/api/api_service.dart';
import 'package:lab_1_menu/src/features/menu/data/coffee_data.dart';
import 'package:lab_1_menu/src/theme/app_colors.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  Future<void> _placeOrder(BuildContext context) async {
    final cartBloc = context.read<CartBloc>();
    final state = cartBloc.state;

    if (state is! CartUpdated) return;

    final cart = state.cart;

    try {
      // Формирование данных заказа
      final positions = Map<String, int>.fromEntries(
        cart.entries.map((entry) {
          final productId = _getProductIdByName(entry.key);
          final quantity = entry.value.quantity;

          // Если ID найден, создаём MapEntry с продуктом, иначе пропускаем
          if (productId != null) {
            return MapEntry(
                productId.toString(), quantity); // Преобразуем ID в строку
          } else {
            return null; // Пропускаем если ID не найден
          }
        }).whereType<MapEntry<String, int>>(),
      );

      print('Подготовка данных для отправки заказа: $positions');

      // Отправка заказа через API
      final response = await ApiService.placeOrder(positions: positions);

      if (context.mounted) {
        if (response.statusCode == 201) {
          cartBloc.add(ClearCartEvent());
          Navigator.of(context).pop(); // Закрытие BottomSheet
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Заказ успешно оформлен!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          throw Exception(
              response.body); // Вызываем исключение для обработки ошибки
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Закрываем BottomSheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Произошла ошибка, попробуйте снова'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  int? _getProductIdByName(String name) {
    final products = <String, int>{};

    const categories = CoffeeData.coffeeInfo;
    int idCounter = 1;

    categories.forEach((category, data) {
      final productsInCategory = data['products'] as List<String>;
      for (var product in productsInCategory) {
        products[product] = idCounter++;
      }
    });

    return products[name];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      if (state is CartUpdated) {
        final cart = state.cart;

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Корзина',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final entry = cart.entries.elementAt(index);
                    final productName = entry.key;
                    final quantity = entry.value.quantity;

                    final price = CoffeeData.coffeeInfo.entries
                        .expand((entry) => entry.value['prices'].entries)
                        .firstWhere(
                            (priceEntry) => priceEntry.key == productName)
                        .value;

                    return ListTile(
                      leading: Image.asset(
                        CoffeeData.coffeeInfo.entries
                            .expand((entry) => entry.value['images'])
                            .toList()[index % 8],
                        width: 50,
                        height: 50,
                      ),
                      title: Text(productName),
                      subtitle: Text('$price ₽ x $quantity'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () {
                          context
                              .read<CartBloc>()
                              .add(RemoveFromCartEvent(productName));
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _placeOrder(context),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.kRedColor),
                  foregroundColor:
                      MaterialStateProperty.all(AppColors.kAppBarColor),
                ),
                child: const Text('Оформить заказ'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<CartBloc>().add(ClearCartEvent());
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.kTextLightColor),
                  foregroundColor:
                      MaterialStateProperty.all(AppColors.kAppBarColor),
                ),
                child: const Text('Очистить корзину'),
              ),
            ],
          ),
        );
      }

      return const Center(child: CircularProgressIndicator());
    });
  }
}
