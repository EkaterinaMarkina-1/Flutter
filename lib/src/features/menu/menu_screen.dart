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
// Ключ для корзинного виджета
  final GlobalKey<_MenuScreenState> cartKey = GlobalKey<_MenuScreenState>();
  // Словарь для хранения ключей категорий
  final Map<String, GlobalKey> categoryKeys = {};

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
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Инициализируем ключи для каждой категории
    for (String category in AppStrings.categories) {
      categoryKeys[category] = GlobalKey();
    }
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

// Метод для выбора категории
  void _selectCategory(String category) {
    setState(() {
      currentCategory = category;
    });
    // Прокручиваем категорию в видимую область
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(
        categoryKeys[category]!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  // Метод для обработки скроллинга и отображения корзины
  void _scrollListener() {
    if (_scrollController.position.pixels > 200 && !showCartWidget) {
      setState(() {
        showCartWidget = true;
      });
      // Прокручиваем корзину в видимую область
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Используем метод ensureVisible() для прокрутки корзины в видимую область
        Scrollable.ensureVisible(
          cartKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else if (_scrollController.position.pixels < 200 && showCartWidget) {
      setState(() {
        showCartWidget = false;
      });
    }
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
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: AppStrings.categories.map((category) {
                  Map<String, dynamic>? categoryInfo =
                      CoffeeData.coffeeInfo[category];
                  if (categoryInfo != null) {
                    return CategorySectionWidget(
                      key: categoryKeys[category], // Добавляем ключ
                      title: category,
                      items: List.generate(categoryInfo["products"].length,
                          (index) {
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
            ),
          ),
        ],
      ),
    );
  }
}
