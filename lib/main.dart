import 'package:flutter/material.dart';
import 'src/app.dart';
import 'package:cofe_fest/src/features/menu/cart/bloc/cart_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:cofe_fest/src/features/menu/bloc/menu_bloc.dart';
import 'package:cofe_fest/src/features/menu/data/menu_repository.dart';
import 'package:cofe_fest/api/api_service.dart';
import 'src/features/menu/data/database/sqlite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseHelper = DatabaseHelper.instance;

  try {
    final menuRepository = MenuRepository(
      menuDataSource: ApiService(),
      databaseHelper: databaseHelper,
    );

    runApp(
      MultiProvider(
        providers: [
          BlocProvider<CartBloc>(create: (context) => CartBloc()),
          BlocProvider<MenuBloc>(
            create: (context) => MenuBloc(menuRepository: menuRepository),
          ),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    Null;
  }
}
