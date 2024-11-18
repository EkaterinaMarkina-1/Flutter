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

        // Если корзина пустая, скрываем кнопку
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Отображение общей стоимости корзины
                Text(
                  '${state.totalCost.toString()} руб.', // Форматируем стоимость с 2 знаками после запятой
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
