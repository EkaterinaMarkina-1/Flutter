import 'package:cofe_fest/src/features/menu/bloc/models/menu_category_dto.dart';
import 'package:cofe_fest/src/features/menu/bloc/models/menu_product_dto.dart';

abstract class IMenuRepository {
  Future<Map<MenuCategoryDto, List<MenuProductDto>>>
      fetchCategoriesWithProducts({
    int limitPerCategory = 7,
    int maxCategories = 10,
  });
}
