import 'package:json_annotation/json_annotation.dart';

part 'menu_category_dto.g.dart';

@JsonSerializable()
class MenuCategoryDto {
  final int id;
  final String slug;

  MenuCategoryDto({required this.id, required this.slug});

  factory MenuCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MenuCategoryDtoToJson(this);

  @override
  String toString() {
    return 'Category(id: $id, slug: $slug)';
  }
}
