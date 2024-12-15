import 'package:flutter/material.dart';

class CategorySectionWidget extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const CategorySectionWidget({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    const EdgeInsets padding =
        EdgeInsets.symmetric(vertical: 3, horizontal: 4.0);
    const EdgeInsets textPadding = EdgeInsets.only(left: 8);
    const TextStyle titleStyle =
        TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: textPadding,
            child: Text(
              title,
              style: titleStyle,
            ),
          ),
          const SizedBox(height: 5),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6.0,
            runSpacing: 2.0,
            children: items,
          ),
        ],
      ),
    );
  }
}
