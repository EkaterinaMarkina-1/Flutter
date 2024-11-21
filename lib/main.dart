import 'package:flutter/material.dart';
import 'src/app.dart';
import 'package:cofe_fest/src/features/menu/bloc/cart_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        BlocProvider<CartBloc>(create: (context) => CartBloc()),
      ],
      child: const MyApp(),
    ),
  );
}
