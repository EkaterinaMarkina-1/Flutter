import 'package:flutter/material.dart';
import 'package:lab_1_menu/src/theme/app_colors.dart';

class CategoryButtonWidget extends StatelessWidget {
  final String category;
  final String currentCategory;
  final VoidCallback onPressed;

  const CategoryButtonWidget({
    super.key,
    required this.category,
    required this.currentCategory,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: currentCategory == category
                ? AppColors.kRedColor
                : AppColors.kTextLightColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                color: currentCategory == category
                    ? AppColors.kWhite
                    : AppColors.kTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
