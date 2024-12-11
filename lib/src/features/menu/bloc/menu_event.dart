import 'package:equatable/equatable.dart';

sealed class MenuEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMenuEvent extends MenuEvent {}
