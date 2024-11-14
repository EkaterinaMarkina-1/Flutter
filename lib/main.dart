import 'package:flutter/material.dart';
import 'src/app.dart';
import 'package:lab_1_menu/src/features/menu/widgets/cart_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        BlocProvider<CartBloc>(create: (_) => CartBloc()),
      ],
      child: const MyApp(),
    ),
  );
}
