import '../repository.dart';
import '../models/models.dart';

class Bookmarks {
  final Repository _repo;
  Bookmarks(this._repo) {
    print('Bookmarks ctor');
  }

  Future<int> add(Recipe recipe) => _repo.insertRecipe(recipe);

  Future<bool> exist(Recipe recipe) async {
    if (recipe.id == null) return false;
    //await _repo.findRecipeById(recipe.id!);
    return false;
  }
}
