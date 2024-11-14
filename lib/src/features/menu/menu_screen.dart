import 'package:flutter/material.dart';
import 'package:lab_1_menu/src/features/menu/widgets/category_button_widget.dart';
import 'package:lab_1_menu/src/features/menu/widgets/category_section_widget.dart';
import 'package:lab_1_menu/src/features/menu/widgets/item_card_widget.dart';
import 'package:lab_1_menu/src/features/menu/data/app_categories.dart';
import 'package:lab_1_menu/src/theme/app_dimensions.dart';
import 'package:lab_1_menu/src/theme/app_colors.dart';
import 'package:lab_1_menu/src/features/menu/data/coffee_data.dart';
import 'package:lab_1_menu/src/features/menu/widgets/cart_botton.dart';
import 'package:lab_1_menu/src/features/menu/widgets/cart_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1_menu/src/features/menu/widgets/cart_event.dart';
import 'package:lab_1_menu/src/features/menu/widgets/cart_state.dart';
import 'package:lab_1_menu/src/features/menu/widgets/cart_bottom_sheet.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final Map<String, int> shoppingCart = {};
  final Map<String, GlobalKey> categoryButtonKeys = {};
  final Map<String, GlobalKey> categorySectionKeys = {};
  Map<String, int> cart = {};

  void addToShoppingCart(String key) {
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

  void removeFromShoppingCart(String key) {
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
    for (String category in AppStrings.categories) {
      categoryButtonKeys[category] = GlobalKey();
      categorySectionKeys[category] = GlobalKey();
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

  void _selectCategory(String category) {
    final currentContext = categorySectionKeys[category]?.currentContext;
    if (currentContext != null) {
      Scrollable.ensureVisible(
        currentContext,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateCategoryAndScroll(String category) {
    setState(() {
      currentCategory = category;
    });
    final currentContext = categoryButtonKeys[category]?.currentContext;
    if (currentContext != null) {
      Scrollable.ensureVisible(
        currentContext,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollListener() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double visibleTopEdge = offset.dy;
    final double visibleBottomEdge = offset.dy + renderBox.size.height;

    for (String category in AppStrings.categories) {
      final categorySec = categorySectionKeys[category];
      final categoryRenderBox =
          categorySec?.currentContext?.findRenderObject() as RenderBox?;
      if (categoryRenderBox != null) {
        final categoryOffset = categoryRenderBox.localToGlobal(Offset.zero);
        if (categoryOffset.dy >= visibleTopEdge &&
            categoryOffset.dy <= visibleBottomEdge) {
          _updateCategoryAndScroll(category);
          break;
        }
      }
    }
  }

  void showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const CartBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kAppBarColor,
          flexibleSpace: Center(
            child: Image.asset(
              'assets/icon/icon.png',
              fit: BoxFit.contain,
            ),
          ),
          actions: const [CartButton()],
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(
                  height: AppDimensions.kCategoryHeight,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalScrollController,
                    child: Row(
                      children: AppStrings.categories.map((category) {
                        return CategoryButtonWidget(
                          key: categoryButtonKeys[category],
                          category: category,
                          currentCategory: currentCategory,
                          onPressed: () => _selectCategory(category),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: AppStrings.categories.map((category) {
                        final categoryInfo = CoffeeData.coffeeInfo[category];
                        if (categoryInfo != null) {
                          return CategorySectionWidget(
                            key: categorySectionKeys[category],
                            title: category,
                            items: List.generate(
                                categoryInfo["products"].length, (index) {
                              final itemName = categoryInfo["products"][index];
                              return ItemCardWidget(
                                  itemName: itemName,
                                  imageUrl: categoryInfo["images"][index],
                                  cost: categoryInfo["prices"][itemName],
                                  shoppingcart: shoppingCart,
                                  addtoshoppingcart: (key) {
                                    context
                                        .read<CartBloc>()
                                        .add(AddToCartEvent(key));
                                  },
                                  removefromshoppingcart: (key) {
                                    context
                                        .read<CartBloc>()
                                        .add(RemoveFromCartEvent(key));
                                  });
                            }),
                          );
                        }
                        return const SizedBox.shrink();
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
