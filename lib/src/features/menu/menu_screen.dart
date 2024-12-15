import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cofe_fest/src/features/menu/bloc/menu_bloc.dart';
import 'package:cofe_fest/src/features/menu/bloc/menu_event.dart';
import 'package:cofe_fest/src/features/menu/bloc/menu_state.dart';
import 'package:cofe_fest/src/features/menu/widgets/category_button_widget.dart';
import 'package:cofe_fest/src/features/menu/widgets/category_section_widget.dart';
import 'package:cofe_fest/src/features/menu/widgets/item_card_widget.dart';
import 'package:cofe_fest/src/features/menu/widgets/cart_button.dart';
import 'package:cofe_fest/src/features/menu/widgets/cart_bottom_sheet.dart';
import 'package:cofe_fest/src/theme/app_dimensions.dart';
import 'package:cofe_fest/src/theme/app_colors.dart';
import 'cart/bloc/cart_bloc.dart';
import 'cart/bloc/cart_event.dart';
import 'bloc/models/menu_category_dto.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final Map<int, GlobalKey> categoryButtonKeys = {};
  final Map<int, GlobalKey> categorySectionKeys = {};
  int? currentCategoryId;
  String currentCategory = '';
  final ScrollController _scrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    context.read<MenuBloc>().add(LoadMenuEvent());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _selectCategory(int categoryId, String categoryName) {
    final currentContext = categorySectionKeys[categoryId]?.currentContext;
    if (currentContext != null) {
      Scrollable.ensureVisible(
        currentContext,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateCategoryAndScroll(MenuCategoryDto category) {
    setState(() {
      currentCategoryId = category.id;
      currentCategory = category.slug;
    });
    final currentContext = categoryButtonKeys[category.id]?.currentContext;
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

    final menuState = context.read<MenuBloc>().state;
    if (menuState is MenuLoadedState) {
      final categoryWithProducts = menuState.categoryWithProducts;

      for (MenuCategoryDto category in categoryWithProducts.keys) {
        final categorySec = categorySectionKeys[category.id];
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kAppBarColor,
        flexibleSpace: Center(
          child: Image.asset(
            'assets/icon/icon.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          CartButton(productName: currentCategory),
        ],
      ),
      body: BlocBuilder<MenuBloc, MenuState>(
        // Строим меню с продуктами
        builder: (context, state) {
          if (state is MenuLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MenuLoadedState) {
            final categoryWithProducts = state.categoryWithProducts;
            return Column(
              children: [
                SizedBox(
                  height: AppDimensions.kCategoryHeight,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalScrollController,
                    child: Row(
                      children: categoryWithProducts.keys.map((category) {
                        return CategoryButtonWidget(
                          category: category.slug,
                          currentCategory: currentCategory,
                          onPressed: () =>
                              _selectCategory(category.id, category.slug),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: categoryWithProducts.keys.map((category) {
                        final products = categoryWithProducts[category]!;

                        return CategorySectionWidget(
                          key: categorySectionKeys.putIfAbsent(
                              category.id, () => GlobalKey()),
                          title: category.slug,
                          items: products.map((product) {
                            final price = product.prices.isNotEmpty
                                ? product.prices.first.value
                                : '0';
                            return ItemCardWidget(
                              productId: product.id.toString(),
                              itemName: product.name,
                              imageUrl: product.imageUrl,
                              cost: '$price ₽',
                              addToShoppingCart: (productId) {
                                context.read<CartBloc>().add(
                                      AddToCartEvent(
                                        key: productId,
                                        price: double.tryParse(price) ?? 0,
                                      ),
                                    );
                              },
                              removeFromShoppingCart: (productId) {
                                context.read<CartBloc>().add(
                                      RemoveFromCartEvent(productId),
                                    );
                              },
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
