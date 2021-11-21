import 'package:json_annotation/json_annotation.dart';
part 'recipe_model.g.dart';

//typedef Json = Map<String, dynamic>;
// https://developer.edamam.com/edamam-docs-recipe-api-v1?cms=published&cms_token=
@JsonSerializable()
class ApiRecipesResult {
  @JsonKey(name: 'q')
  String query;
  int from;
  int to;
  bool more;
  int count;
  List<ApiHits> hits;

  ApiRecipesResult({
    required this.query,
    required this.from,
    required this.to,
    required this.more,
    required this.count,
    required this.hits,
  });

  factory ApiRecipesResult.fromJson(json) => _$ApiRecipesResultFromJson(json);
  Map<String, dynamic> toJson() => _$ApiRecipesResultToJson(this);
}

@JsonSerializable()
class ApiHits {
  ApiRecipe recipe;
  ApiHits({required this.recipe});

  factory ApiHits.fromJson(json) => _$ApiHitsFromJson(json);
  Map<String, dynamic> toJson() => _$ApiHitsToJson(this);
}

@JsonSerializable()
class ApiRecipe {
  String label;
  String image;
  String url;
  List<ApiIngredient> ingredients;
  double calories;
  double totalWeight;
  double totalTime;

  ApiRecipe({
    required this.label,
    required this.image,
    required this.url,
    required this.ingredients,
    required this.calories,
    required this.totalWeight,
    required this.totalTime,
  });

  String get getCalories => '${calories.floor()} KCAL';
  String get getWeight => '${totalWeight.floor()}g';

  factory ApiRecipe.fromJson(json) => _$ApiRecipeFromJson(json);
  Map<String, dynamic> toJson() => _$ApiRecipeToJson(this);
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

  factory ApiIngredient.fromJson(json) => _$ApiIngredientFromJson(json);
  Map<String, dynamic> toJson() => _$ApiIngredientToJson(this);
}
