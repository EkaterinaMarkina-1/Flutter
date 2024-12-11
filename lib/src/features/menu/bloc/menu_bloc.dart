import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cofe_fest/src/features/menu/bloc/menu_event.dart';
import 'package:cofe_fest/src/features/menu/bloc/menu_state.dart';
import 'package:cofe_fest/src/features/menu/data/menu_repository.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;

  MenuBloc({required this.menuRepository}) : super(MenuIdleState()) {
    on<LoadMenuEvent>((event, emit) async {
      emit(MenuLoadingState());

      try {
        final categoryWithProducts =
            await menuRepository.fetchCategoriesWithProducts();

        emit(MenuLoadedState(categoryWithProducts: categoryWithProducts));
      } catch (e) {
        emit(MenuErrorState(message: 'Ошибка загрузки данных: $e'));
      }
    });
  }
}
