import 'package:test/test.dart';
import '../lib/network/recipe_model.dart';

void main() {
  test('create ApiRecipe from Json', () {
    final recipeFromJson = ApiRecipe.fromJson(json);

    expect(recipeFromJson.label, 'Chicken Vesuvio');
    expect(recipeFromJson.ingredients, hasLength(4));
  });

  test('getters', () {
    final recipe = ApiRecipe.fromJson(json);

    expect(recipe.getCalories, '4228 KCAL');
    expect(recipe.getWeight, '2976g');
  });
}

final json = <String, dynamic>{
  'label': 'Chicken Vesuvio',
  'image':
      'https://www.edamam.com/web-img/e42/e42f9119813e890af34c259785ae1cfb.jpg',
  'url':
      'http://www.seriouseats.com/recipes/2011/12/chicken-vesuvio-recipe.html',
  'calories': 4228.043058200812,
  'totalWeight': 2976.8664549004047,
  'totalTime': 60.0,
  'ingredients': [
    {
      'text': '1/2 cup olive oil',
      'weight': 108.0,
    },
    {
      'text': '5 cloves garlic, peeled',
      'weight': 15.0,
    },
    {
      'text': '2 large russet potatoes, peeled and cut into chunks',
      'weight': 738.0,
    },
    {
      'text':
          '1 3-4 pound chicken, cut into 8 pieces (or 3 pound chicken legs)',
      'weight': 1587.5732950000001,
    },
  ],
};
