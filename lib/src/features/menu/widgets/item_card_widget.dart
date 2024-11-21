import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Для BlocBuilder
import 'package:cofe_fest/src/theme/app_colors.dart';
import 'cart_quantity_widget.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';

class ItemCardWidget extends StatelessWidget {
  final String itemName;
  final String imageUrl;
  final String cost;
  final Function(String key) addtoshoppingcart;
  final Function(String key) removefromshoppingcart;

  const ItemCardWidget({
    super.key,
    required this.itemName,
    required this.imageUrl,
    required this.cost,
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
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: AppColors.kWhite,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: AppColors.kTextLightColor.withOpacity(0.5),
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
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.kTextColor,
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final Map<String, int> itemQuantities = state.cart.map((key, cartItem) {
          return MapEntry(key, cartItem.quantity);
        });
        final itemQuantity = itemQuantities[itemName] ?? 0;
        if (itemQuantity == 0) {
          return ElevatedButton(
            onPressed: () => addtoshoppingcart(itemName),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 4),
              backgroundColor: AppColors.kRedColor,
              textStyle: const TextStyle(color: AppColors.kWhite),
            ),
            child: Text(
              cost,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.kWhite,
              ),
            ),
          );
        } else {
          return CartQuantityWidget(
            itemName: itemName,
            shoppingcart: itemQuantities,
            addtoshoppingcart: addtoshoppingcart,
            removefromshoppingcart: removefromshoppingcart,
          );
        }
      },
    );
  }
}
