import 'dart:async';
import 'dart:core';
import 'repository.dart';
import 'models/models.dart';

class MemoryRepo extends Repository {
  final _recipes = <Recipe>[];
  final _ingredients = <Ingredient>[];

  final _recipesController = StreamController<List<Recipe>>();
  final _ingredientsController = StreamController<List<Ingredient>>();

  @override
  Stream<List<Recipe>> watchRecipes() => _recipesController.stream;

  @override
  Stream<List<Ingredient>> watchIngredietns() => _ingredientsController.stream;

  //Create
  @override
  Future<int> insertRecipe(Recipe recipe) {
    _recipes.add(recipe);
    _ingredients.addAll(recipe.ingredients);
    _recipesController.add(_recipes);
    _ingredientsController.add(_ingredients);
    return Future.value(0);
  }

  @override
  Future<List<int>> insertIngredients(List<Ingredient> ingredients) {
    _ingredients.addAll(ingredients);
    _ingredientsController.add(_ingredients);
    return Future.value([]);
  }

  //Read
  @override
  Future<List<Recipe>> findAllRecipes() => Future.value(_recipes);
  @override
  Future<List<Ingredient>> findAllIngredients() => Future.value(_ingredients);
  @override
  Future<Recipe> findRecipeById(int id) =>
      Future.value(_recipes.firstWhere((recipe) => recipe.id == id));

  @override
  Future<List<Ingredient>> findRecipeIngredients(int recipeId) => Future.value(
        _ingredients.where((i) => i.recipeId == recipeId).toList(),
      );

  //Delete
  @override
  Future<bool> deleteRecipe(Recipe recipe) {
    final deleted = _recipes.remove(recipe);
    _ingredients.removeWhere((ingredient) => ingredient.recipeId == recipe.id);
    _recipesController.add(_recipes);
    _ingredientsController.add(_ingredients);
    return Future.value(deleted);
  }

  @override
  Future<bool> deleteIngredient(Ingredient ingredient) {
    final deleted = _ingredients.remove(ingredient);
    _ingredientsController.add(_ingredients);
    return Future.value(deleted);
  }

  @override
  Future<bool> deleteIngredients(List<Ingredient> ingredients) {
    ingredients.map(_ingredients.remove);
    _ingredientsController.add(_ingredients);
    return Future.value(true);
  }

  @override
  Future<bool> deleteRecipeIngredients(int recipeId) {
    _ingredients.removeWhere((ingredient) => ingredient.recipeId == recipeId);
    _ingredientsController.add(_ingredients);
    return Future.value(true);
  }

  @override
  Future init() => Future.value();

  @override
  bool close() {
    _recipesController.close();
    _ingredientsController.close();
    return true;
  }
}
