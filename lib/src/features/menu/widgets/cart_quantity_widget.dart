import 'package:flutter/material.dart';
import 'package:cofe_fest/src/features/menu/widgets/quantity_button.dart';

class CartQuantityWidget extends StatelessWidget {
  final String productId;
  final int quantity;
  final Function(String productId) addToShoppingCart;
  final Function(String productId) removeFromShoppingCart;

  const CartQuantityWidget({
    super.key,
    required this.productId,
    required this.quantity,
    required this.addToShoppingCart,
    required this.removeFromShoppingCart,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuantityButton(
          label: '-',
          onPressed: () {
            removeFromShoppingCart(productId);
          },
        ),
        const SizedBox(width: 16),
        Text(
          quantity.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16),
        QuantityButton(
          label: '+',
          onPressed: () {
            addToShoppingCart(productId);
          },
        ),
      ],
    );
  }
}
