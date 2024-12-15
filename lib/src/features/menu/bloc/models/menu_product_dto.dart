import 'package:json_annotation/json_annotation.dart';
import 'menu_category_dto.dart';

part 'menu_product_dto.g.dart';

@JsonSerializable()
class MenuProductDto {
  final int id;
  final String name;
  final MenuCategoryDto category;
  final String imageUrl;
  final List<MenuProductPriceDto> prices;

  MenuProductDto({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.prices,
  });

  factory MenuProductDto.fromJson(Map<String, dynamic> json) =>
      _$MenuProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MenuProductDtoToJson(this);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, category: $category, price: ${prices[0].value})';
  }
}

@JsonSerializable()
class MenuProductPriceDto {
  final String value;
  final String currency;

  MenuProductPriceDto({required this.value, required this.currency});

  factory MenuProductPriceDto.fromJson(Map<String, dynamic> json) =>
      _$MenuProductPriceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MenuProductPriceDtoToJson(this);

  @override
  String toString() {
    return 'Price(value: $value, currency: $currency)';
  }
}
