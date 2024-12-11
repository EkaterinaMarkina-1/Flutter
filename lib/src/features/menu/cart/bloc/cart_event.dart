import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddToCartEvent extends CartEvent {
  final String key;
  final double price;

  AddToCartEvent({required this.key, required this.price});

  @override
  List<Object> get props => [key, price];
}

class RemoveFromCartEvent extends CartEvent {
  final String key;

  RemoveFromCartEvent(this.key);

  @override
  List<Object> get props => [key];
}

class ClearCartEvent extends CartEvent {}
