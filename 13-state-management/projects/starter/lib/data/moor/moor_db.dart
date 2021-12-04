import 'package:moor_flutter/moor_flutter.dart';
import '../models/models.dart';

part 'moor_db.g.dart';

class MoorRecipe extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
  TextColumn get image => text()();
  TextColumn get url => text()();
  RealColumn get calories => real()();
  RealColumn get totalWeight => real()();
  RealColumn get totalTime => real()();
}

class MoorIngredient extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId => integer()();
  TextColumn get name => text()();
  RealColumn get weight => real()();
}

@UseMoor(
  tables: [MoorRecipe, MoorIngredient],
  daos: [RecipeDao, IngredientDao],
)
class RecipeDatabase extends _$RecipeDatabase {
  RecipeDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
          path: 'recipe.sqlite',
          logStatements: true,
        ));

  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [MoorRecipe])
class RecipeDao extends DatabaseAccessor<RecipeDatabase> with _$RecipeDaoMixin {
  final RecipeDatabase db;

  RecipeDao(this.db) : super(db);

  Future<List<MoorRecipeData>> findAllRecipes() => select(moorRecipe).get();

  Stream<List<Recipe>> watchAllRecipe() {
    // TODO
  }

  Future<List<MoorRecipeData>> findRecipeById(int id) =>
      (select(moorRecipe)..where((tbl) => tbl.id.equals(id))).get();

  Future<int> insertRecipe(Insertable<MoorRecipeData> recipe) =>
      into(moorRecipe).insert(recipe);

  Future deleteRecipe(int id) {
    final stmt = delete(moorRecipe)..where((tbl) => tbl.id.equals(id));
    return stmt.go();
  }
}

@UseDao(tables: [MoorIngredient])
class IngredientDao extends DatabaseAccessor<RecipeDatabase>
    with _$IngredientDaoMixin {
  final RecipeDatabase db;

  IngredientDao(this.db) : super(db);

  Future<List<MoorIngredientData>> findAllIngredients() =>
      select(moorIngredient).get();

  Stream<List<MoorIngredientData>> watchAllIngredients() =>
      select(moorIngredient).watch();

  Future<List<MoorIngredientData>> findRecipeIngredients(int id) =>
      (select(moorIngredient)..where((tbl) => tbl.recipeId.equals(id))).get();

  Future<int> insertIngredient(Insertable<MoorIngredientData> ingredient) =>
      into(moorIngredient).insert(ingredient);

  Future deleteIngredient(int id) => Future.value(
      (delete(moorIngredient)..where((tbl) => tbl.id.equals(id))).go());
}

// TODO: Add moorRecipeToRecipe here

// TODO: Add moorIngredientToIngredient and MoorIngredientCompanion here
