import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cofe_fest/src/features/menu/bloc/models/menu_category_dto.dart';
import 'package:cofe_fest/src/features/menu/bloc/models/menu_product_dto.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('menu.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final pathToDb = join(dbPath, path);
    return await openDatabase(pathToDb, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE MenuCategory(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      slug TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE MenuProduct(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      categoryId INTEGER,
      categorySlug TEXT,
      priceValue TEXT,
      priceCurrency TEXT
    )
    ''');

    await db.execute('''
     CREATE TABLE MenuProductPrice(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       productId INTEGER,
       value TEXT,
       currency TEXT
     )
     ''');
  }

  Future<void> insertCategory(MenuCategoryDto category) async {
    final db = await instance.database;
    await db.insert(
      'MenuCategory',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertProduct(MenuProductDto product) async {
    final db = await instance.database;
    await db.insert(
      'MenuProduct',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MenuCategoryDto>> getCategories() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('MenuCategory');
    return List.generate(maps.length, (i) {
      return MenuCategoryDto.fromMap(maps[i]);
    });
  }

  Future<List<MenuProductDto>> getProducts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('MenuProduct');
    return List.generate(maps.length, (i) {
      return MenuProductDto.fromMap(maps[i]);
    });
  }

  Future<MenuProductDto?> getProductsByName(String productName) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'MenuProduct',
      where: 'name = ?',
      whereArgs: [productName],
    );

    if (maps.isNotEmpty) {
      return MenuProductDto.fromMap(maps.first);
    }
    return null;
  }

  Future<void> clearDatabase() async {
    final db = await instance.database;

    // Очищаем таблицы
    await db.delete('MenuCategory');
    await db.delete('MenuProduct');
    await db.delete('MenuProductPrice');
  }
}
