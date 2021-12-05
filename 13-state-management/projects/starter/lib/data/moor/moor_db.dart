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

@UseDao(tables: [MoorRecipe, MoorIngredient])
class RecipeDao extends DatabaseAccessor<RecipeDatabase> with _$RecipeDaoMixin {
  final RecipeDatabase db;

  RecipeDao(this.db) : super(db);

  Future<List<MoorRecipeData>> findAllRecipes() => select(moorRecipe).get();

  Stream<List<Recipe>> watchAllRecipe() {
    select(moorRecipe).get().then((value) {
      value.map(print);
    });
    return select(moorRecipe)
        .watch()
        .map((data) => data.map(moorRecipeToRecipe).toList());
  }

  Future<List<MoorRecipeData>> findRecipeById(int id) =>
      (select(moorRecipe)..where((tbl) => tbl.id.equals(id))).get();

  Future<int> insertRecipe(Recipe recipe) => transaction(() async {
        final id = await into(moorRecipe).insert(recipeToInsertable(recipe));
        recipe.ingredients
            ?.map(ingredientToInsetable)
            .forEach((i) => into(moorIngredient).insert(i));
        return id;
      });

  Future<bool> deleteRecipe(int id) async {
    final stmt = delete(moorRecipe)..where((tbl) => tbl.id.equals(id));
    final row = await stmt.go();
    return row > 0;
  }
}

@UseDao(tables: [MoorIngredient])
class IngredientDao extends DatabaseAccessor<RecipeDatabase>
    with _$IngredientDaoMixin {
  final RecipeDatabase db;

  IngredientDao(this.db) : super(db);

  Future<List<MoorIngredientData>> findAllIngredients() =>
      select(moorIngredient).get();

  Stream<List<Ingredient>> watchAllIngredients() => select(moorIngredient)
      .watch()
      .map((data) => data.map(moorIngredientToModel).toList());

  Future<List<MoorIngredientData>> findRecipeIngredients(int id) =>
      (select(moorIngredient)..where((tbl) => tbl.recipeId.equals(id))).get();

  Future<int> insertIngredient(Insertable<MoorIngredientData> ingredient) =>
      into(moorIngredient).insert(ingredient);

  Future deleteIngredient(int id) => Future.value(
      (delete(moorIngredient)..where((tbl) => tbl.id.equals(id))).go());
}

Recipe moorRecipeToRecipe(MoorRecipeData data) => Recipe(
      id: data.id,
      label: data.label,
      image: data.image,
      url: data.url,
      calories: data.calories,
      totalWeight: data.totalWeight,
      totalTime: data.totalTime,
    );

Insertable<MoorRecipeData> recipeToInsertable(Recipe recipe) =>
    MoorRecipeCompanion.insert(
      label: recipe.label,
      image: recipe.image,
      url: recipe.url,
      calories: recipe.calories,
      totalWeight: recipe.totalWeight,
      totalTime: recipe.totalTime,
    );

Ingredient moorIngredientToModel(MoorIngredientData data) => Ingredient(
      recipeId: data.recipeId,
      name: data.name,
      weight: data.weight,
    );

MoorIngredientCompanion ingredientToInsetable(Ingredient ingredient) =>
    MoorIngredientCompanion.insert(
      recipeId: ingredient.recipeId,
      name: ingredient.name,
      weight: ingredient.weight,
    );
