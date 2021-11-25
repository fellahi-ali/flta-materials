import 'dart:core';
import 'package:flutter/foundation.dart';
import 'repository.dart';
import 'models/models.dart';

class MemoryRepo extends Repository with ChangeNotifier {
  final _recipes = <Recipe>[];
  final _ingredients = <Ingredient>[];

  //Create
  @override
  int insertRecipe(Recipe recipe) {
    _recipes.add(recipe);
    _ingredients.addAll(recipe.ingredients);
    notifyListeners();
    return 0;
  }

  @override
  List<int> insertIngredients(List<Ingredient> ingredients) {
    ingredients.addAll(ingredients);
    notifyListeners();
    return [];
  }

  //Read
  @override
  List<Recipe> findAllRecipes() => _recipes;
  @override
  List<Ingredient> findAllIngredients() => _ingredients;
  @override
  Recipe findRecipeById(int id) =>
      _recipes.firstWhere((recipe) => recipe.id == id);
  @override
  List<Ingredient> findRecipeIngredients(int recipeId) =>
      _ingredients.where((i) => i.recipeId == recipeId).toList();

  //Delete
  @override
  bool deleteRecipe(Recipe recipe) {
    final deleted = _recipes.remove(recipe);
    _ingredients.removeWhere((ingredient) => ingredient.recipeId == recipe.id);
    notifyListeners();
    return deleted;
  }

  @override
  bool deleteIngredient(Ingredient ingredient) {
    final deleted = _ingredients.remove(ingredient);
    notifyListeners();
    return deleted;
  }

  @override
  bool deleteIngredients(List<Ingredient> ingredients) {
    ingredients.map(_ingredients.remove);
    notifyListeners();
    return true;
  }

  @override
  bool deleteRecipeIngredients(int recipeId) {
    _ingredients.removeWhere((ingredient) => ingredient.recipeId == recipeId);
    notifyListeners();
    return true;
  }

  @override
  Future init() => Future.value();

  @override
  bool close() => true;
}
