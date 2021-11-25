import 'models/models.dart';

abstract class Repository {
  // Create/insert
  int insertRecipe(Recipe recipe);
  List<int> insertIngredients(List<Ingredient> ingredients);
  // Read/find
  List<Recipe> findAllRecipes();
  Recipe findRecipeById(int id);
  List<Ingredient> findAllIngredients();
  List<Ingredient> findRecipeIngredients(int recipeId);

  // Update/edit

  // Delete/remove
  bool deleteRecipe(Recipe recipe);
  bool deleteIngredient(Ingredient ingredient);
  bool deleteIngredients(List<Ingredient> ingredients);
  bool deleteRecipeIngredients(int recipeId);

  // init & close
  Future init();
  bool close();
}
