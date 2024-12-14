import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cofe_fest/src/features/menu/cart/bloc/cart_bloc.dart';
import 'package:cofe_fest/src/features/menu/cart/bloc/cart_state.dart';
import 'package:cofe_fest/src/features/menu/cart/bloc/cart_event.dart';
import 'package:cofe_fest/api/api_service.dart';
import 'package:cofe_fest/src/features/menu/bloc/menu_bloc.dart';
import 'package:cofe_fest/src/features/menu/bloc/menu_state.dart';
import 'package:cofe_fest/src/theme/app_colors.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  Future<void> _placeOrder(BuildContext context) async {
    final cartBloc = context.read<CartBloc>();
    final state = cartBloc.state;

    if (state is! CartUpdated) return;

    final cart = state.cart;

    try {
      final positions = Map<String, int>.fromEntries(
        cart.entries.map((entry) {
          final productData = _getProductById(context, entry.key);
          final quantity = entry.value.quantity;

          if (productData['name'] != '') {
            return MapEntry(productData['name'], quantity);
          } else {
            return null;
          }
        }).whereType<MapEntry<String, int>>(),
      );

      final response = await ApiService.placeOrder(positions: positions);

      if (context.mounted) {
        if (response.statusCode == 201) {
          cartBloc.add(ClearCartEvent());
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Заказ успешно оформлен!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          throw Exception(response.body);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Произошла ошибка, попробуйте снова'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Map<String, dynamic> _getProductById(BuildContext context, String id) {
    final menuState = BlocProvider.of<MenuBloc>(context).state;

    if (menuState is MenuLoadedState) {
      for (var category in menuState.categoryWithProducts.entries) {
        for (var product in category.value) {
          if (product.id.toString() == id) {
            final price = product.prices.isNotEmpty
                ? '${product.prices.first.value} ₽'
                : '0 ₽';
            return {
              'name': product.name,
              'price': price,
              'imageUrl': product.imageUrl,
            };
          }
        }
      }
    } else {}
    return {'name': '', 'price': '0 ₽', 'imageUrl': ''};
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
              const Text(
                'Корзина',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final entry = cart.entries.elementAt(index);
                    final productData = _getProductById(context, entry.key);
                    final quantity = entry.value.quantity;
                    final price = productData['price'];
                    final productImageUrl = productData['imageUrl'];

                    return ListTile(
                      leading: productImageUrl != null
                          ? Image.network(productImageUrl,
                              width: 50, height: 50)
                          : Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey,
                              child: const Center(child: Text('N/A')),
                            ),
                      title: Text(productData['name']),
                      subtitle: Text('$price x $quantity'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () {
                          context
                              .read<CartBloc>()
                              .add(RemoveFromCartEvent(entry.key));
                          if (cart.isEmpty) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _placeOrder(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRedColor,
                  foregroundColor: AppColors.kAppBarColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Оформить заказ'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<CartBloc>().add(ClearCartEvent());
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Корзина очищена'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kTextLightColor,
                  foregroundColor: AppColors.kAppBarColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
