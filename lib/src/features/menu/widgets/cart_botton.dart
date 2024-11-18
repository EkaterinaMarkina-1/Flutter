import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1_menu/src/features/menu/widgets/cart_bottom_sheet.dart';
import 'package:lab_1_menu/src/theme/app_colors.dart';
import 'cart_bloc.dart';
import 'cart_state.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final isCartEmpty = state.cart.isEmpty;

        // Если корзина пустая, полностью скрываем кнопку
        if (isCartEmpty) return const SizedBox.shrink();

        // Иначе отображаем кнопку корзины
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => BlocProvider.value(
                value: context.read<CartBloc>(),
                child: const CartBottomSheet(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.kAppBarColor,
              borderRadius: BorderRadius.circular(50),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.kAppBarColor,
                  blurRadius: 10,
                  spreadRadius: 3,
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 28,
                  color: Colors.white,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                      color: AppColors.kRedColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        state.cart.values.reduce((a, b) => a + b).toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
