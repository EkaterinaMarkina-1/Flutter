import 'package:cofe_fest/src/features/menu/bloc/interfaces/IMenuRepository.dart';
import 'package:cofe_fest/src/features/menu/bloc/models/menu_category_dto.dart';
import 'package:cofe_fest/src/features/menu/bloc/models/menu_product_dto.dart';
import 'package:cofe_fest/src/features/menu/data/data_sources/menu_data_source.dart'; 

class MenuRepository implements IMenuRepository {
  final IMenuDataSource _menuDataSource;

  MenuRepository({required IMenuDataSource menuDataSource})
      : _menuDataSource = menuDataSource;

  @override
  Future<Map<MenuCategoryDto, List<MenuProductDto>>>
      fetchCategoriesWithProducts({
    int limitPerCategory = 7,
    int maxCategories = 10,
  }) async {
    try {
      final categories = await _menuDataSource.fetchCategories();
      final limitedCategories = categories.take(maxCategories).toList();

      final results = await Future.wait(limitedCategories.map((category) {
        int page = limitedCategories.indexOf(category) + 1;
        return _fetchCategoryProducts(category, page, limitPerCategory);
      }).toList());

      return {
        for (int i = 0; i < limitedCategories.length; i++)
          limitedCategories[i]: results[i],
      };
    } catch (e) {
      throw Exception('Ошибка при загрузке категорий и товаров: $e');
    }
  }

  Future<List<MenuProductDto>> _fetchCategoryProducts(
    MenuCategoryDto category,
    int page,
    int limitPerCategory,
  ) async {
    try {
      final products = await _menuDataSource.fetchProducts(
        category: category.slug,
        page: page,
        limit: limitPerCategory,
      );

      return products
          .map((json) => MenuProductDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
