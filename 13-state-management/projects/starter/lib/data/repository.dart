import 'models/models.dart';

abstract class Repository {
  Stream<List<Recipe>> watchRecipes();
  Stream<List<Ingredient>> watchIngredietns();

  // Create
  Future<int> insertRecipe(Recipe recipe);
  Future<List<int>> insertIngredients(List<Ingredient> ingredients);
  // Read
  Future<List<Recipe>> findAllRecipes();
  Future<Recipe> findRecipeById(int id);
  Future<List<Ingredient>> findAllIngredients();
  Future<List<Ingredient>> findRecipeIngredients(int recipeId);
  // Update
  // Delete
  Future<bool> deleteRecipe(Recipe recipe);
  Future<bool> deleteIngredient(Ingredient ingredient);
  Future<bool> deleteIngredients(List<Ingredient> ingredients);
  Future<bool> deleteRecipeIngredients(int recipeId);

  // init & close
  Future init();
  bool close();
}
