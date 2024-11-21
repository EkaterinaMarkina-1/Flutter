import 'package:flutter/material.dart';
import 'package:cofe_fest/src/features/menu/widgets/quantity_button.dart';

class CartQuantityWidget extends StatelessWidget {
  final String itemName;
  final Map<String, int> shoppingcart;
  final Function(String key) addtoshoppingcart;
  final Function(String key) removefromshoppingcart;

  const CartQuantityWidget({
    super.key,
    required this.itemName,
    required this.shoppingcart,
    required this.addtoshoppingcart,
    required this.removefromshoppingcart,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QuantityButton(
          label: '-',
          onPressed: () {
            removefromshoppingcart(itemName);
          },
        ),
        const SizedBox(width: 16),
        Text(
          shoppingcart[itemName].toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16),
        QuantityButton(
          label: '+',
          onPressed: () {
            addtoshoppingcart(itemName);
          },
        ),
      ],
    );
  }
}
