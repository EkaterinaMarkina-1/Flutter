import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1_menu/src/features/menu/data/coffee_data.dart';
import 'cart_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.cart.length,
                  itemBuilder: (context, index) {
                    final entry = state.cart.entries.elementAt(index);
                    final key = entry.key;
                    final quantity = entry.value;
                    final parts = key.split('_');
                    final category = parts[0];
                    final itemIndex = int.parse(parts[1]);
                    final productName =
                        CoffeeData.coffeeInfo[category]!["products"][itemIndex];
                    final price =
                        CoffeeData.coffeeInfo[category]!["prices"][productName];

                    return Dismissible(
                      key: Key(key),
                      onDismissed: (direction) {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Итого: ${_calculateTotalCost(state.cart).toStringAsFixed(2)} ₽',
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
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

  double _calculateTotalCost(Map<String, int> cart) {
    double total = 0;
    cart.forEach((key, quantity) {
      final parts = key.split('_');
      final category = parts[0];
      final itemIndex = int.parse(parts[1]);
      final price = CoffeeData.coffeeInfo[category]!["prices"]
          [CoffeeData.coffeeInfo[category]!["products"][itemIndex]];
      total += price * quantity;
    });
    return total;
  }
}
