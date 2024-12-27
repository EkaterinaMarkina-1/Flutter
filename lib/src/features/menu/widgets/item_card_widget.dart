import 'package:cofe_fest/src/theme/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cofe_fest/src/theme/app_colors.dart';
import 'cart_quantity_widget.dart';
import '../cart/bloc/cart_bloc.dart';
import '../cart/bloc/cart_state.dart';

class ItemCardWidget extends StatelessWidget {
  final String productId;
  final String itemName;
  final String? imageUrl;
  final String cost;
  final Function(String key) addToShoppingCart;
  final Function(String key) removeFromShoppingCart;

  const ItemCardWidget({
    super.key,
    required this.productId,
    required this.itemName,
    required this.imageUrl,
    required this.cost,
    required this.addToShoppingCart,
    required this.removeFromShoppingCart,
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

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageUrl != null
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: const Center(child: Text('Ошибка загрузки')),
                );
              },
            )
          : Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage(PathLib.defaultImagePath),
                  fit: BoxFit.fill,
                ),
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
        final itemQuantity = state.cart[productId]?.quantity ?? 0;

        if (itemQuantity == 0) {
          return ElevatedButton(
            onPressed: () {
              addToShoppingCart(productId);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 4),
              backgroundColor: AppColors.kRedColor,
              textStyle: const TextStyle(color: AppColors.kWhite),
            ),
            child: FittedBox(
              child: Text(
                cost,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kWhite,
                ),
              ),
            ),
          );
        } else {
          return CartQuantityWidget(
            productId: productId,
            quantity: itemQuantity,
            addToShoppingCart: addToShoppingCart,
            removeFromShoppingCart: removeFromShoppingCart,
          );
        }
      },
    );
  }
}
