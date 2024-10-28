import 'package:flutter/material.dart';
import '../constants.dart'; // Импорт констант
import 'cart_quantity_widget.dart';

class ItemCardWidget extends StatelessWidget {
  final String itemName;
  final String imageUrl;
  final String cost;
  final Map<String, int> shoppingcart;
  final Function(String key) addtoshoppingcart;
  final Function(String key) removefromshoppingcart;

  const ItemCardWidget({
    super.key,
    required this.itemName,
    required this.imageUrl,
    required this.cost,
    required this.shoppingcart,
    required this.addtoshoppingcart,
    required this.removefromshoppingcart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 164,
        height: 240,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: _buildDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImage(),
            const SizedBox(height: 8),
            _buildItemInfo(),
            const SizedBox(height: 8),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 4,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  Container _buildImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildItemInfo() {
    return SizedBox(
      width: 160,
      child: Text(
        itemName,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: kTextColor,
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    if (shoppingcart[itemName] == null || shoppingcart[itemName] == 0) {
      return ElevatedButton(
        onPressed: () => addtoshoppingcart(itemName),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 4),
          backgroundColor: kRedColor,
          textStyle: const TextStyle(color: Colors.white),
        ),
        child: Text(
          cost,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return CartQuantityWidget(
        itemName: itemName,
        shoppingcart: shoppingcart,
        addtoshoppingcart: addtoshoppingcart,
        removefromshoppingcart: removefromshoppingcart,
      );
    }
  }
}
