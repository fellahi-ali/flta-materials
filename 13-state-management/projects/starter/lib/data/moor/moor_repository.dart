import 'package:recipes/data/models/models.dart';
import 'package:recipes/data/moor/moor_db.dart';
import 'package:recipes/data/repository.dart';

class MoorRepository implements Repository {
  late RecipeDatabase _db;
  late RecipeDao _recipeDao;
  late IngredientDao _ingredientDao;
  Stream<List<Recipe>>? recipeStream;
  Stream<List<Ingredient>>? ingredientStream;

  @override
  Future<List<Recipe>> findAllRecipes() async {
    final data = await _recipeDao.findAllRecipes();
    final recipes = data.map(moorRecipeToRecipe).map((e) async {
      if (e.id == null) return e;
      final ingredients = await findRecipeIngredients(e.id!);
      return e..ingredients = ingredients;
    });
    return Future.wait(recipes);
  }

  @override
  Stream<List<Recipe>> watchRecipes() =>
      recipeStream ??= _recipeDao.watchAllRecipe();

  @override
  Stream<List<Ingredient>> watchIngredietns() =>
      ingredientStream ??= _ingredientDao.watchAllIngredients();

  @override
  Future<Recipe> findRecipeById(int id) async {
    final data = await _recipeDao.findRecipeById(id);
    final recipe = moorRecipeToRecipe(data.first);
    recipe.ingredients = await findRecipeIngredients(id);
    return recipe;
  }

  @override
  Future<List<Ingredient>> findAllIngredients() async {
    final d = await _ingredientDao.findAllIngredients();
    return d.map(moorIngredientToModel).toList();
  }

  @override
  Future<List<Ingredient>> findRecipeIngredients(int recipeId) async {
    final data = await _ingredientDao.findRecipeIngredients(recipeId);
    return data.map(moorIngredientToModel).toList();
  }

  @override
  Future<int> insertRecipe(Recipe recipe) => _recipeDao.insertRecipe(recipe);

  @override
  Future<List<int>> insertIngredients(List<Ingredient> ingredients) {
    final inserts = ingredients
        .map(ingredientToInsetable)
        .map(_ingredientDao.insertIngredient);
    return Future.wait(inserts);
  }

  @override
  Future<bool> deleteRecipe(Recipe recipe) => recipe.id != null
      ? _recipeDao.deleteRecipe(recipe.id!)
      : Future.value(false);

  @override
  Future<bool> deleteIngredient(Ingredient ingredient) {
    _ingredientDao.deleteIngredient(ingredient.id ?? 0);
    return Future.value(true);
  }

  @override
  Future<bool> deleteIngredients(List<Ingredient> ingredients) {
    ingredients.forEach(deleteIngredient);
    return Future.value(true);
  }

  @override
  Future<bool> deleteRecipeIngredients(int recipeId) {
    findRecipeIngredients(recipeId)
        .then((value) => value.forEach(deleteIngredient));
    return Future.value(true);
  }

  @override
  Future init() async {
    _db = RecipeDatabase();
    _recipeDao = _db.recipeDao;
    _ingredientDao = _db.ingredientDao;
  }

  @override
  bool close() {
    _db.close();
    return true;
  }
}
