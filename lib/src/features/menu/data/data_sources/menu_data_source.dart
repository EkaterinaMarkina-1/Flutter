import 'package:cofe_fest/src/features/menu/bloc/models/menu_category_dto.dart';

abstract class IMenuDataSource {
  Future<List<MenuCategoryDto>> fetchCategories();
  Future<List<dynamic>> fetchProducts({
    required String category,
    required int page,
    required int limit,
  });
}
