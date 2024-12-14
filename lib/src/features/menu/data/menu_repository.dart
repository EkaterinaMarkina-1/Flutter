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
      // Попытка загрузить данные с сайта
      print('Попытка загрузки категорий с сайта...');
      final categories = await _menuDataSource.fetchCategories();

      //  _databaseHelper.refreshDatabase();

      final limitedCategories = categories.take(maxCategories).toList();
      print('Загружено ${limitedCategories.length} категорий с сайта.');

      final results = await Future.wait(limitedCategories.map((category) {
        int page = limitedCategories.indexOf(category) + 1;
        return _fetchCategoryProducts(category, page, limitPerCategory);
      }).toList());

      // Сохраняем категории и продукты в базе данных
      await _saveCategoriesAndProductsToDb(limitedCategories, results);

      return {
        for (int i = 0; i < limitedCategories.length; i++)
          limitedCategories[i]: results[i],
      };
    } catch (e) {
      print(
          'Ошибка при загрузке с сайта, пытаемся загрузить из базы данных: $e');

      // Если произошла ошибка, загружаем из базы данных
      return _loadFromDatabase();
    }
  }

  // Сохранение категорий и продуктов в базу данных
  Future<void> _saveCategoriesAndProductsToDb(
    List<MenuCategoryDto> categories,
    List<List<MenuProductDto>> results,
  ) async {
    for (int i = 0; i < categories.length; i++) {
      // Сохраняем категорию в базу данных
      await _databaseHelper.insertCategory(categories[i]);

      // Сохраняем продукты для этой категории
      for (var product in results[i]) {
        await _databaseHelper.insertProduct(product);
        print(product.name);
      }
    }
    print('Данные успешно сохранены в базу данных.');
  }

  // Метод для загрузки данных из базы данных
  Future<Map<MenuCategoryDto, List<MenuProductDto>>> _loadFromDatabase() async {
    print("БиБА");
    // _databaseHelper.clearDatabase();
    final categoriesFromDb = await _databaseHelper.getCategories();
    print("Боба");
    if (categoriesFromDb.isEmpty) {
      print("База пуста");
      // Если данных нет в базе, возвращаем пустой результат
      return {};
    }
    print(categoriesFromDb[0].slug);
    final productsFromDb = await _databaseHelper.getProducts();
    print("База продуктов пуста");
    print(productsFromDb[0].name);

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
      print(
          'Загрузка товаров для категории ${category.slug}, страница $page...');
      final products = await _menuDataSource.fetchProducts(
        category: category.slug,
        page: page,
        limit: limitPerCategory,
      );

      return products
          .map((json) => MenuProductDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(
          'Ошибка при загрузке товаров, пытаемся загрузить из базы данных: $e');
      final productsFromDb = await _databaseHelper.getProducts();
      return productsFromDb
          .where((product) => product.category.slug == category.slug)
          .toList();
    }
  }

  // Future<void> fillDatabase(
  //     DatabaseHelper dbHelper, MenuRepository menuRepository) async {
  //   final categories = await menuRepository
  //       .fetchCategoriesWithProducts(); // Загружаем категории и продукты с API

  //   if (categories.isEmpty) {
  //     print("Не удалось загрузить данные о категориях и продуктах.");
  //     return;
  //   }

  //   print("Заполнение базы данных с сайта...");

  //   int productId = 0;
  //   for (var category in categories.keys) {
  //     final categoryDto = category;
  //     await dbHelper.insertCategory(categoryDto);

  //     // Заполнение продуктов
  //     for (var product in categories[category]!) {
  //       productId = productId + 1;

  //       // Проверяем, существует ли продукт с таким именем в базе данных
  //       final productDto = MenuProductDto(
  //         id: productId,
  //         name: product.name,
  //         category: categoryDto,
  //         prices: [
  //           MenuProductPriceDto(
  //               value: product.prices.first.value, currency: 'руб'),
  //         ],
  //       );
  //       await dbHelper.insertProduct(productDto);
  //     }
  //   }
  //   print("База данных успешно заполнена данными с сайта.");
  // }
}
