import 'package:flutter/material.dart';
import '../models/explore_recipe.dart';
import '../models/models.dart';
import 'components.dart';

class TodayRecipeListView extends StatelessWidget {
  final List<ExploreRecipe> recipes;

  const TodayRecipeListView({
    Key? key,
    required this.recipes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recipes of the Day 🍳',
            style: Theme.of(context).textTheme.headline1,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 400,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recipes.length,
              itemBuilder: (context, index) => buildCard(recipes[index]),
              separatorBuilder: (context, index) => const SizedBox(width: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCard(ExploreRecipe recipe) {
    switch (recipe.cardType) {
      case RecipeCardType.card1:
        return Card1(recipe: recipe);
      case RecipeCardType.card2:
        return Card2(recipe: recipe);
      case RecipeCardType.card3:
        return Card3(recipe: recipe);
      default:
        throw Exception("This Card doesn't exist");
    }
  }
}
