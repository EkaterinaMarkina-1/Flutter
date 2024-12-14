import 'package:json_annotation/json_annotation.dart';
import 'menu_category_dto.dart';

part 'menu_product_dto.g.dart';

@JsonSerializable()
class MenuProductDto {
  final int id;
  final String name;
  final MenuCategoryDto category;
  final String? imageUrl;

  final List<MenuProductPriceDto> prices;

  MenuProductDto({
    required this.id,
    required this.name,
    required this.category,
    required this.prices,
    this.imageUrl,
  });

  // JSON parsing
  factory MenuProductDto.fromJson(Map<String, dynamic> json) =>
      _$MenuProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MenuProductDtoToJson(this);

  // For database operations
  factory MenuProductDto.fromMap(Map<String, dynamic> map) {
    return MenuProductDto(
      id: map['id'],
      name: map['name'],
      category: MenuCategoryDto.fromMap({
        'id': map['categoryId'],
        'slug': map['categorySlug'],
      }),
      prices: [
        MenuProductPriceDto(
          value: map['priceValue'].toString(),
          currency: map['priceCurrency'] ?? 'RUB',
        ),
      ],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'categoryId': category.id,
      'categorySlug': category.slug,
      'priceValue': prices[0].value,
      'priceCurrency': 'RUB',
    };
  }

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
