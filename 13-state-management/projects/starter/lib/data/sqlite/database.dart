import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:recipes/data/models/models.dart';
import 'package:recipes/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:synchronized/synchronized.dart';

class RecipesDb {
  static const _dbName = 'recipes.db';
  static const _dbVersion = 1;

  static const tableRecipe = 'recipe';
  static const tableIngredients = 'ingredient';

  RecipesDb._(); //make the constructor private
  static final RecipesDb _instance = RecipesDb._();

  factory RecipesDb.getInstance() => _instance;

  static final _lock = Lock();
  static Database? _database;
  static BriteDatabase? _reactiveDb;

  /// synchronized getter
  Future<Database> get database async {
    if (_database != null) return _database!;
    await _lock.synchronized(() async {
      _database = await _initDatabase();
    });
    return _database!;
  }

  Future<BriteDatabase> get rxDb async {
    if (_database == null) {
      _database = await database;
    }
    return _reactiveDb ??= BriteDatabase(_database!, logger: print);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableRecipe (
        id INTEGER PRIMARY KEY,
        label TEXT,
        image TEXT,
        url TEXT,
        calories REAL,
        total_weight REAL,
        total_time REAL
      );
      ''');
    await db.execute('''
      CREATE TABLE $tableIngredients (
        id INTEGER PRIMARY KEY,
        recipe_id INTEGER,
        name TEXT,
        weight REAL
      );
    ''');
  }

  Future<Database> _initDatabase() async {
    final docDir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(docDir.path, _dbName);

    return openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<Recipes> findAllRecipes() async {
    final db = await database;
    final rows = await db.query(tableRecipe);
    return rows.map(Recipe.fromJson).toList();
  }

  Stream<Recipes> watchAllRecipes() async* {
    final rxDb = await _instance.rxDb;
    yield* rxDb.createQuery(tableRecipe).mapToList(Recipe.fromJson);
  }

  Future<Ingredients> findAllIngredients() async {
    final db = await database;
    final rows = await db.query(tableIngredients);
    return rows.map(Ingredient.fromJson).toList();
  }

  Stream<Ingredients> watchAllIngredeints() async* {
    final rxDb = await _instance.rxDb;
    yield* rxDb.createQuery(tableIngredients).mapToList(Ingredient.fromJson);
  }

  Future<Recipe> findRecipeById(int id) async {
    final db = await database;
    final rows = await db.query(
      tableRecipe,
      where: 'id = $id',
    );
    return Recipe.fromJson(rows.first);
  }

  Future<Ingredients> findRecipeIngredients(int recipeId) async {
    final db = await database;
    final rows = await db.query(
      tableIngredients,
      where: 'recipe_id = $recipeId',
    );
    return rows.map(Ingredient.fromJson).toList();
  }

  Future<int> insert(String table, Row row) async {
    // if (row['id'] != null)
    // throw StateError('row.id must be null for insert!');
    final db = await RecipesDb.getInstance().rxDb;
    return db.insert(
      table,
      row,
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  Future<int> insertRecipe(Recipe recipe) async {
    return insert(tableRecipe, recipe.toJson());
  }

  Future<int> insertIngredient(Ingredient ingredient) async {
    return insert(tableIngredients, ingredient.toJson());
  }

  Future<int> _delete(String table, int id) async {
    final db = await _instance.rxDb;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteRecipe(int id) async {
    return _delete(tableRecipe, id);
  }

  Future<int> deleteIngredient(Ingredient ingredient) async {
    final id = ArgumentError.checkNotNull(
      ingredient.id,
      'ingredient.id must not be null!',
    );
    return _delete(tableIngredients, id);
  }

  Future<int> _deleteIngredients(Ingredients ingredients) async {
    final deleted = await Future.wait(ingredients.map(deleteIngredient));
    return deleted.reduce((value, element) => value + element);
  }

  // delete ingredients using delete query
  Future<int> deleteIngredients(Ingredients ingredients) async {
    final ids = ingredients.map((i) => i.id).whereType<int>();
    final db = await _instance.rxDb;
    return db.delete(
      tableIngredients,
      where: 'id IN (?)',
      whereArgs: [ids.join(',')],
    );
  }

  Future<int> deleteRecipeIngredients(int recipeId) async {
    final db = await _instance.rxDb;
    return db.delete(tableIngredients, where: 'recipe_id = $recipeId');
  }

  void close() {
    if (_reactiveDb != null) _reactiveDb?.close();
  }
}

typedef Row = Map<String, dynamic>;

typedef Recipes = List<Recipe>;
typedef Ingredients = List<Ingredient>;
