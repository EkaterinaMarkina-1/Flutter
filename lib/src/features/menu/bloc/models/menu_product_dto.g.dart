// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuProductDto _$MenuProductDtoFromJson(Map<String, dynamic> json) =>
    MenuProductDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      category:
          MenuCategoryDto.fromJson(json['category'] as Map<String, dynamic>),
      imageUrl: json['imageUrl'] as String,
      prices: (json['prices'] as List<dynamic>)
          .map((e) => MenuProductPriceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuProductDtoToJson(MenuProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category.toJson(),
      'imageUrl': instance.imageUrl,
      'prices': instance.prices.map((e) => e.toJson()).toList(),
    };

MenuProductPriceDto _$MenuProductPriceDtoFromJson(Map<String, dynamic> json) =>
    MenuProductPriceDto(
      value: json['value'] as String,
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$MenuProductPriceDtoToJson(
        MenuProductPriceDto instance) =>
    <String, dynamic>{
      'value': instance.value,
      'currency': instance.currency,
    };
