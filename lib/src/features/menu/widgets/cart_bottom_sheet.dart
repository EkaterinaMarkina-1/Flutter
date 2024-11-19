import 'dart:convert'; // For jsonEncode
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:lab_1_menu/src/features/menu/data/coffee_data.dart';
import 'cart_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

/// Widget for the bottom sheet displaying the cart.
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
              // List of cart items.
              Expanded(
                child: ListView.builder(
                  itemCount: state.cart.length,
                  itemBuilder: (context, index) {
                    final entry = state.cart.entries.elementAt(index);
                    final key = entry.key;
                    final quantity = entry.value.quantity;
                    final category = key.split('_')[0];
                    final itemIndex = int.parse(key.split('_')[1]);

                    // Getting product name and price from data.
                    final productName =
                        CoffeeData.coffeeInfo[category]!["products"][itemIndex];
                    final price =
                        CoffeeData.coffeeInfo[category]!["prices"][itemIndex];

                    return Column(
                      children: [
                        ListTile(
                          title: Text(productName),
                          subtitle: Text('$price ₽ x $quantity'),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () {
                              if (quantity > 1) {
                                // Decrease quantity by 1 if greater than 1.
                                context.read<CartBloc>().add(
                                      RemoveFromCartEvent(key),
                                    );
                              } else {
                                // Remove the product completely if quantity is 1.
                                context.read<CartBloc>().add(
                                      RemoveFromCartEvent(key),
                                    );
                              }
                            },
                          ),
                        ),
                        if (quantity > 1)
                          // Display quantity if more than 1.
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('Quantity: $quantity'),
                          ),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),
              // Displaying the total cost of the cart.
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  state.cart.length.toString(),
                  // 'Total: ${_calculateTotalCost(state.cart).toStringAsFixed(2)} ₽',
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              // "Place Order" button.
              ElevatedButton(
                onPressed: () => _placeOrder(context, state.cart),
                child: const Text('Place Order'),
              ),
              // "Clear Cart" button.
              TextButton(
                onPressed: () {
                  context.read<CartBloc>().add(ClearCartEvent()); // Clear cart
                  Navigator.pop(context); // Close the BottomSheet
                },
                child: const Text('Clear Cart'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Helper method to calculate the total cost of the cart.
  //double _calculateTotalCost(Map<String, CartItem> cart) {
  //double total = 0;
  //cart.forEach((key, value) {
  //final category = key.split('_')[0];
  // final itemIndex = int.parse(key.split('_')[1]);
  // final price = CoffeeData.coffeeInfo[category]!["prices"][itemIndex];

  //total += value.price * value.quantity;
  //});
  //return total;
  //}

  /// Method to send a POST request and place the order.
  Future<void> _placeOrder(
      BuildContext context, Map<String, CartItem> cart) async {
    try {
      // Create the request body with cart data.
      final orderData = cart.map((key, value) {
        final category = key.split('_')[0];
        final itemIndex = int.parse(key.split('_')[1]);
        final price = CoffeeData.coffeeInfo[category]!["prices"][itemIndex];

        return MapEntry(key, {
          'name': CoffeeData.coffeeInfo[category]!["products"][itemIndex],
          'quantity': value.quantity,
          'price': price,
        });
      });

      // Example POST request (replace URL and data for a real API).
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/orders'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(orderData),
      );

      if (!context.mounted) return; // Check if widget is still mounted.

      if (response.statusCode == 200) {
        // If order is placed successfully
        context.read<CartBloc>().add(ClearCartEvent()); // Clear the cart
        Navigator.pop(context); // Close the BottomSheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully')),
        );
      } else {
        // If the server returns an error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      if (!context.mounted) return; // Check if widget is still mounted.
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error placing order: $e')),
      );
    }
  }
}
