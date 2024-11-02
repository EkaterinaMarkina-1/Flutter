import 'package:flutter/material.dart';
import 'package:lab_1_menu/src/features/menu/widgets/category_button_widget.dart';
import 'package:lab_1_menu/src/features/menu/widgets/category_section_widget.dart';
import 'package:lab_1_menu/src/features/menu/widgets/item_card_widget.dart';
import 'package:lab_1_menu/src/features/menu/data/app_categories.dart';
import 'package:lab_1_menu/src/theme/app_dimensions.dart';
import 'package:lab_1_menu/src/theme/app_colors.dart';
import 'package:lab_1_menu/src/features/menu/data/coffee_data.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Map<String, int> shoppingCart = {};

  void addtoshoppingcart(String key) {
    if (shoppingCart.containsKey(key)) {
      if (shoppingCart[key] != 10) {
        setState(() {
          shoppingCart[key] = (shoppingCart[key] ?? 0) + 1;
        });
      }
    } else {
      setState(() {
        shoppingCart[key] = 1;
      });
    }
  }

  void removefromshoppingcart(String key) {
    setState(() {
      shoppingCart[key] = (shoppingCart[key] ?? 0) - 1;
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

    int index = AppStrings.categories.indexOf(category);
    if (index != -1) {
      double totalOffset = 0;
      for (int i = 0; i < index; i++) {
        totalOffset += _getCategoryHeight(AppStrings.categories[i]);
      }

      _scrollController.jumpTo(totalOffset);
    }
  }

  double _getCategoryHeight(String category) {
    return switch (category) {
      "Классический кофе" => AppDimensions.kCategoryCoffeeHeight,
      "Авторский кофе" => AppDimensions.kCategoryCoffeeHeight,
      "Сезонное меню напитков" => AppDimensions.kCategoryDrinksHeight,
      "Горячие напитки" => AppDimensions.kCategoryHotDrinksHeight,
      "Фреши" => AppDimensions.kCategoryFreshHeight,
      _ => 0,
    };
  }

  void _scrollListener() {
    setState(() {
      int index =
          (_scrollController.offset / AppDimensions.kCategoryHeight2).floor();

      if (index >= 0 && index < AppStrings.categories.length) {
        currentCategory = AppStrings.categories[index];

        double screenWidth = MediaQuery.of(context).size.width;
        double categoryWidth =
            AppStrings.categories.length * AppDimensions.kCategoryCardWidth;
        double scrollTo = index * AppDimensions.kCategoryCardWidth -
            (screenWidth - AppDimensions.kCategoryCardWidth) / 2.0;

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

    for (int i = 0; i < AppStrings.categories.length; i++) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      double itemPosition = renderBox.localToGlobal(Offset.zero).dy;

      if (itemPosition >= 0 &&
          itemPosition < MediaQuery.of(context).size.height) {
        position = i.toDouble();
        break;
      }
    }

    categoryInView = AppStrings.categories[position.toInt()];

    return categoryInView;
  }

  bool showCartWidget = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kAppBarColor,
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
            height: AppDimensions.kCategoryHeight,
            child: Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _horizontalScrollController,
                  child: Row(
                    children: AppStrings.categories.map((category) {
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
                    height: AppDimensions.kCategoryCardWidth,
                    width: 2,
                    color: AppColors.kGrey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: _scrollController,
              children: AppStrings.categories.map((category) {
                Map<String, dynamic>? categoryInfo =
                    CoffeeData.coffeeInfo[category];
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
                        shoppingcart: shoppingCart,
                        addtoshoppingcart: addtoshoppingcart,
                        removefromshoppingcart: removefromshoppingcart,
                      );
                    }),
                  );
                }
                return const SizedBox();
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
