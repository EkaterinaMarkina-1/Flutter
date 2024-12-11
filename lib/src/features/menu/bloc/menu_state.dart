import 'package:equatable/equatable.dart';
import 'package:cofe_fest/src/features/menu/bloc/models/menu_category_dto.dart';
import 'package:cofe_fest/src/features/menu/bloc/models/menu_product_dto.dart';

abstract class MenuState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MenuIdleState extends MenuState {}

class MenuLoadingState extends MenuState {}

class MenuLoadedState extends MenuState {
  final Map<MenuCategoryDto, List<MenuProductDto>> categoryWithProducts;

  MenuLoadedState({required this.categoryWithProducts});

  @override
  List<Object?> get props => [categoryWithProducts];
}

class MenuErrorState extends MenuState {
  final String message;

  MenuErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
