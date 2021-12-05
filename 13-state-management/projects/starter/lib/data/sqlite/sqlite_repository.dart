import 'package:recipes/data/models/recipe.dart';
import 'package:recipes/data/models/ingredient.dart';
import 'package:recipes/data/repository.dart';
import 'package:recipes/data/sqlite/database.dart';

class SqliteRepository implements Repository {
  final db = RecipesDb.getInstance();
  @override
  Future init() async {
    await db.database; //TODO: this is very bad code, please REFACTOR!
    return Future.value();
  }

  @override
  Stream<List<Recipe>> watchRecipes() => db.watchAllRecipes();

  @override
  Stream<List<Ingredient>> watchIngredietns() => db.watchAllIngredeints();

  @override
  Future<List<Recipe>> findAllRecipes() => db.findAllRecipes();
  @override
  Future<List<Ingredient>> findAllIngredients() => db.findAllIngredients();

  @override
  Future<Recipe> findRecipeById(int id) => db.findRecipeById(id);

  @override
  Future<List<Ingredient>> findRecipeIngredients(int recipeId) =>
      db.findRecipeIngredients(recipeId);

  @override
  Future<int> insertRecipe(Recipe recipe) async {
    final id = await db.insertRecipe(recipe);
    final ingredients = recipe.ingredients;
    if (ingredients != null) {
      final i = ingredients.map((e) => e.copyWith(recipeId: id));
      insertIngredients(i.toList());
    }
    return id;
  }

  @override
  Future<List<int>> insertIngredients(List<Ingredient> ingredients) {
    final inserts = ingredients.map(db.insertIngredient);
    return Future.wait(inserts);
  }

  @override
  Future<bool> deleteIngredient(Ingredient ingredient) async {
    final deleted = await db.deleteIngredient(ingredient);
    return deleted > 0;
  }

  @override
  Future<bool> deleteIngredients(List<Ingredient> ingredients) async {
    final deleted = await db.deleteIngredients(ingredients);
    return deleted > 0;
  }

  @override
  Future<bool> deleteRecipe(Recipe recipe) async {
    final id = ArgumentError.checkNotNull(recipe.id);
    deleteRecipeIngredients(id);
    final deleted = await db.deleteRecipe(id);
    return deleted > 0;
  }

  @override
  Future<bool> deleteRecipeIngredients(int recipeId) async {
    final deleted = await db.deleteRecipeIngredients(recipeId);
    return deleted > 0;
  }

  @override
  bool close() {
    db.close();
    return true;
  }
}
