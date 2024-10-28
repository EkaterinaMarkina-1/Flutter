import 'package:flutter/material.dart';
import 'package:lab_1_menu/src/constants.dart';
import 'package:lab_1_menu/src/widgets/category_button_widget.dart';
import 'package:lab_1_menu/src/widgets/category_section_widget.dart';
import 'package:lab_1_menu/src/widgets/item_card_widget.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // Контроллер вертикального скролла
  Map<String, int> shoppingcart = {};

  void addtoshoppingcart(String key) {
    if (shoppingcart.containsKey(key)) {
      if (shoppingcart[key] != 10) {
        setState(() {
          shoppingcart[key] = (shoppingcart[key] ?? 0) + 1;
        });
      }
    } else {
      setState(() {
        shoppingcart[key] = 1;
      });
    }
  }

  void removefromshoppingcart(String key) {
    setState(() {
      shoppingcart[key] = (shoppingcart[key] ?? 0) - 1;
    });
  }

  String currentCategory = "Классический кофе";
  final ScrollController _scrollController = ScrollController();
  ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _horizontalScrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _selectCategory(String category) {
    setState(() {
      currentCategory = category;
    });

    int index = categories.indexOf(category);
    if (index != -1) {
      double totalOffset = 0;
      for (int i = 0; i < index; i++) {
        totalOffset += _getCategoryHeight(categories[i]);
      }

      _scrollController.jumpTo(totalOffset);
    }
  }

  double _getCategoryHeight(String category) {
    switch (category) {
      case "Классический кофе":
        return kCategoryCoffeeHeight;
      case "Авторский кофе":
        return kCategoryCoffeeHeight;
      case "Сезонное меню напитков":
        return kCategoryDrinksHeight;
      case "Горячие напитки":
        return kCategoryHotDrinksHeight;
      case "Фреши":
        return kCategoryFreshHeight;
      default:
        return 0;
    }
  }

  void _scrollListener() {
    setState(() {
      int index = (_scrollController.offset / kCategoryHeight2).floor();

      if (index >= 0 && index < categories.length) {
        currentCategory = categories[index];

        double screenWidth = MediaQuery.of(context).size.width;
        double categoryWidth = categories.length * kCategoryCardWidth;
        double scrollTo = index * kCategoryCardWidth -
            (screenWidth - kCategoryCardWidth) / 2.0;

        scrollTo = scrollTo.clamp(0, categoryWidth - screenWidth);

        _horizontalScrollController.animateTo(
          scrollTo,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // ignore: unused_element
  String _determineCategoryInView() {
    double position = 0.0;
    String categoryInView;

    for (int i = 0; i < categories.length; i++) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      double itemPosition = renderBox.localToGlobal(Offset.zero).dy;

      if (itemPosition >= 0 &&
          itemPosition < MediaQuery.of(context).size.height) {
        position = i.toDouble();
        break;
      }
    }

    categoryInView = categories[position.toInt()];

    return categoryInView;
  }

  bool showCartWidget = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        flexibleSpace: Center(
          child: Image.asset(
            'assets/icon/icon.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: kCategoryHeight,
            child: Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _horizontalScrollController,
                  child: Row(
                    children: categories.map((category) {
                      return CategoryButtonWidget(
                        category: category,
                        currentCategory: currentCategory,
                        onPressed: () {
                          _selectCategory(category);
                        },
                      );
                    }).toList(),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: kCategoryHeight,
                    width: 2,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Список товаров
          Expanded(
            child: ListView(
              controller: _scrollController,
              children: categories.map((category) {
                // Получаем информацию о текущей категории
                Map<String, dynamic>? categoryInfo = coffeeInfo[category];
                if (categoryInfo != null) {
                  return CategorySectionWidget(
                    title: category,
                    items:
                        List.generate(categoryInfo["products"].length, (index) {
                      String itemName = categoryInfo["products"][index];
                      String imageUrl = categoryInfo["images"][index];
                      String cost = categoryInfo["prices"][itemName];
                      return ItemCardWidget(
                        itemName: itemName,
                        imageUrl: imageUrl,
                        cost: cost,
                        shoppingcart: shoppingcart,
                        addtoshoppingcart: addtoshoppingcart,
                        removefromshoppingcart: removefromshoppingcart,
                      );
                    }),
                  );
                }
                return const SizedBox(); // Возвращаем пустой виджет, если категория не найдена
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
