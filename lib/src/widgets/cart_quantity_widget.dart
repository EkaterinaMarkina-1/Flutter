import 'package:flutter/material.dart';
import '../constants.dart'; // Импорт констант

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
        GestureDetector(
          onTap: () {
            removefromshoppingcart(itemName);
          },
          child: Container(
            width: 30,
            height: 30,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: kRedColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('-',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
        const SizedBox(width: 16),
        Text(shoppingcart[itemName].toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            addtoshoppingcart(itemName);
          },
          child: Container(
            width: 30,
            height: 30,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: kRedColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('+',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ],
    );
  }
}
// Виджет для количества в корзине