import 'package:flutter/material.dart';
import '../components/recipes_grid_view.dart';
import '../api/mock_fooderlich_service.dart';
import '../models/models.dart';

typedef Recipes = List<SimpleRecipe>;

class RecipesScreen extends StatelessWidget {
  final fooderlichService = MockFooderlichService();

  RecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //initialData: <SimpleRecipe>[],
      future: fooderlichService.getRecipes(),
      builder: (context, AsyncSnapshot<Recipes> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final recipes = snapshot.data ?? [];
          return RecipesGridView(recipes: recipes);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
