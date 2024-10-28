import 'package:flutter/material.dart';
import '../constants.dart';

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
            color: currentCategory == category ? kRedColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                color: currentCategory == category ? Colors.white : kTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
