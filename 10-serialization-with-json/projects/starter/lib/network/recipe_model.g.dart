// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiRecipeResults _$ApiRecipeResultsFromJson(Map<String, dynamic> json) =>
    ApiRecipeResults(
      query: json['q'] as String,
      from: json['from'] as int,
      to: json['to'] as int,
      more: json['more'] as bool,
      count: json['count'] as int,
      hits: (json['hits'] as List<dynamic>)
          .map((e) => ApiHits.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$ApiRecipeResultsToJson(ApiRecipeResults instance) =>
    <String, dynamic>{
      'q': instance.query,
      'from': instance.from,
      'to': instance.to,
      'more': instance.more,
      'count': instance.count,
      'hits': instance.hits,
    };

ApiHits _$ApiHitsFromJson(Map<String, dynamic> json) => ApiHits(
      recipe: ApiRecipe.fromJson(json['recipe']),
    );

Map<String, dynamic> _$ApiHitsToJson(ApiHits instance) => <String, dynamic>{
      'recipe': instance.recipe,
    };

ApiRecipe _$ApiRecipeFromJson(Map<String, dynamic> json) => ApiRecipe(
      label: json['label'] as String,
      image: json['image'] as String,
      url: json['url'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => ApiIngredient.fromJson(e))
          .toList(),
      calories: (json['calories'] as num).toDouble(),
      totalWeight: (json['totalWeight'] as num).toDouble(),
      totalTime: (json['totalTime'] as num).toDouble(),
    );

Map<String, dynamic> _$ApiRecipeToJson(ApiRecipe instance) => <String, dynamic>{
      'label': instance.label,
      'image': instance.image,
      'url': instance.url,
      'ingredients': instance.ingredients,
      'calories': instance.calories,
      'totalWeight': instance.totalWeight,
      'totalTime': instance.totalTime,
    };

ApiIngredient _$ApiIngredientFromJson(Map<String, dynamic> json) =>
    ApiIngredient(
      name: json['text'] as String,
      weight: (json['weight'] as num).toDouble(),
    );

Map<String, dynamic> _$ApiIngredientToJson(ApiIngredient instance) =>
    <String, dynamic>{
      'text': instance.name,
      'weight': instance.weight,
    };
