
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1_menu/src/features/menu/widgets/cart_bottom_sheet.dart';
import 'cart_bloc.dart';
import 'cart_state.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final isCartEmpty = state.cart.isEmpty;

        return Visibility(
          visible: !isCartEmpty,
          child: IconButton(
            icon: Stack(
              alignment: Alignment.topRight,
              children: [
                const Icon(Icons.shopping_cart),
                if (!isCartEmpty)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      state.cart.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),

            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => BlocProvider.value(
                value: context.read<CartBloc>(),
                child: const CartBottomSheet(),
              ),
            ),
          ),
        );
      },
    );
  }
}
