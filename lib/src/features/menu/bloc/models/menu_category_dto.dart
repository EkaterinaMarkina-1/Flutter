import 'package:json_annotation/json_annotation.dart';

part 'menu_category_dto.g.dart';

@JsonSerializable()
class MenuCategoryDto {
  final int id;
  final String slug;

  MenuCategoryDto({required this.id, required this.slug});

  // JSON-парсинг
  factory MenuCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MenuCategoryDtoToJson(this);

  // Для работы с базой данных
  factory MenuCategoryDto.fromMap(Map<String, dynamic> map) {
    return MenuCategoryDto(
      id: map['id'],
      slug: map['slug'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'slug': slug,
    };
  }

  @override
  String toString() {
    return 'Category(id: $id, slug: $slug)';
  }
}
