import 'package:json_annotation/json_annotation.dart';
import '../data/models/models.dart';

part 'recipe_model.g.dart';

@JsonSerializable()
class ApiRecipeQuery {
  factory ApiRecipeQuery.fromJson(Map<String, dynamic> json) =>
      _$ApiRecipeQueryFromJson(json);

  Map<String, dynamic> toJson() => _$ApiRecipeQueryToJson(this);
  @JsonKey(name: 'q')
  String query;
  int from;
  int to;
  bool more;
  int count;
  List<ApiHits> hits;

  ApiRecipeQuery({
    required this.query,
    required this.from,
    required this.to,
    required this.more,
    required this.count,
    required this.hits,
  });
}

@JsonSerializable()
class ApiHits {
  ApiRecipe recipe;

  ApiHits({
    required this.recipe,
  });

  factory ApiHits.fromJson(Map<String, dynamic> json) =>
      _$ApiHitsFromJson(json);

  Map<String, dynamic> toJson() => _$ApiHitsToJson(this);
}

@JsonSerializable()
class ApiRecipe {
  final int _id;
  final String label;
  final String image;
  final String url;
  final List<ApiIngredient> ingredients;
  final double calories;
  final double totalWeight;
  final double totalTime;
  ApiRecipe({
    int? id,
    required this.label,
    required this.image,
    required this.url,
    required this.ingredients,
    required this.calories,
    required this.totalWeight,
    required this.totalTime,
  }) : _id = id ?? url.hashCode;

  Recipe toModel() => Recipe(
        id: _id,
        label: label,
        image: image,
        url: url,
        ingredients: _convertIngredients(ingredients, _id),
        calories: calories,
        totalWeight: totalWeight,
        totalTime: totalTime,
      );

  List<Ingredient> _convertIngredients(
    List<ApiIngredient> apiIngredients,
    int recipeId,
  ) {
    return apiIngredients
        .map((ing) => Ingredient(
              recipeId: recipeId,
              name: ing.name,
              weight: ing.weight,
            ))
        .toList();
  }

  factory ApiRecipe.fromJson(Map<String, dynamic> json) =>
      _$ApiRecipeFromJson(json);

  Map<String, dynamic> toJson() => _$ApiRecipeToJson(this);
}

String getCalories(double? calories) {
  if (calories == null) {
    return '0 KCAL';
  }
  return calories.floor().toString() + ' KCAL';
}

String getWeight(double? weight) {
  if (weight == null) {
    return '0g';
  }
  return weight.floor().toString() + 'g';
}

@JsonSerializable()
class ApiIngredient {
  @JsonKey(name: 'text')
  String name;
  double weight;

  ApiIngredient({
    required this.name,
    required this.weight,
  });

  factory ApiIngredient.fromJson(Map<String, dynamic> json) =>
      _$ApiIngredientFromJson(json);

  Map<String, dynamic> toJson() => _$ApiIngredientToJson(this);
}
