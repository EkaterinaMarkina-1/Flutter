import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1_menu/src/features/menu/widgets/cart_bottom_sheet.dart';
import 'package:lab_1_menu/src/theme/app_colors.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';

class CartButton extends StatelessWidget {
  final String productName;
  const CartButton({super.key, required this.productName});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final isCartEmpty = state.cart.isEmpty;
        if (isCartEmpty) return const SizedBox.shrink();
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
            decoration: const BoxDecoration(
              color: AppColors.kAppBarColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  '${state.totalCost.toStringAsFixed(2)} руб.',
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
