import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1_menu/src/features/menu/widgets/cart_bottom_sheet.dart'; // Импортируем BottomSheet
import 'package:lab_1_menu/src/theme/app_colors.dart'; // Импорт цветов
import 'cart_bloc.dart'; // Импорт блока для корзины
// import 'cart_event.dart'; // Импорт событий корзины
import 'cart_state.dart'; // Импорт состояния корзины
// import 'package:lab_1_menu/src/features/menu/data/coffee_data.dart'; // Импорт данных о кофе

class CartButton extends StatelessWidget {
  final String productName; // Название товара, который добавляется в корзину

  const CartButton(
      {super.key,
      required this.productName}); // Конструктор, принимающий название товара

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      // Используем BlocBuilder для слушания состояния корзины
      builder: (context, state) {
        final isCartEmpty = state.cart.isEmpty; // Проверяем, пуста ли корзина

        // Если корзина пуста, скрываем кнопку
        if (isCartEmpty) return const SizedBox.shrink();

        // Иначе отображаем кнопку с общей стоимостью корзины
        return GestureDetector(
          onTap: () {
            // Отображаем BottomSheet с содержимым корзины
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => BlocProvider.value(
                value: context.read<CartBloc>(), // Передаем существующий Bloc
                child: const CartBottomSheet(), // Отображаем виджет с корзиной
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.kAppBarColor, // Цвет фона кнопки
              borderRadius: BorderRadius.circular(50), // Скругляем углы
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
                  '${state.totalCost.toStringAsFixed(2)} руб.', // Форматируем стоимость с 2 знаками после запятой
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
