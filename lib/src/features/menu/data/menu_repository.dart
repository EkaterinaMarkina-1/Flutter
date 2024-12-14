import 'package:cofe_fest/src/features/menu/bloc/interfaces/IMenuRepository.dart';
import 'package:cofe_fest/src/features/menu/data/data_sources/menu_data_source.dart';
import 'package:cofe_fest/src/features/menu/data/database/sqlite.dart';
import 'package:cofe_fest/src/features/menu/bloc/models/menu_category_dto.dart';
import 'package:cofe_fest/src/features/menu/bloc/models/menu_product_dto.dart';

class MenuRepository implements IMenuRepository {
  final IMenuDataSource _menuDataSource;
  final DatabaseHelper _databaseHelper;

  MenuRepository({
    required IMenuDataSource menuDataSource,
    required DatabaseHelper databaseHelper,
  })  : _menuDataSource = menuDataSource,
        _databaseHelper = databaseHelper;

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

      await _databaseHelper.clearDatabase();
      await _saveCategoriesAndProductsToDb(limitedCategories, results);

      return {
        for (int i = 0; i < limitedCategories.length; i++)
          limitedCategories[i]: results[i],
      };
    } catch (e) {
      return _loadFromDatabase();
    }
  }

  Future<void> _saveCategoriesAndProductsToDb(
    List<MenuCategoryDto> categories,
    List<List<MenuProductDto>> results,
  ) async {
    for (int i = 0; i < categories.length; i++) {
      await _databaseHelper.insertCategory(categories[i]);
      for (var product in results[i]) {
        await _databaseHelper.insertProduct(product);
      }
    }
  }

  Future<Map<MenuCategoryDto, List<MenuProductDto>>> _loadFromDatabase() async {
    final categoriesFromDb = await _databaseHelper.getCategories();
    if (categoriesFromDb.isEmpty) {
      return {};
    }
    final productsFromDb = await _databaseHelper.getProducts();
    return {
      for (var category in categoriesFromDb)
        category: productsFromDb
            .where((product) => product.category.slug == category.slug)
            .toList(),
    };
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
      final productsFromDb = await _databaseHelper.getProducts();
      return productsFromDb
          .where((product) => product.category.slug == category.slug)
          .toList();
    }
  }
}
