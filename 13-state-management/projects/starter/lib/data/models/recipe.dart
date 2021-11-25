import 'package:equatable/equatable.dart';
import '../../network/recipe_model.dart';
import 'ingredient.dart';

class Recipe extends Equatable {
  final int id;
  final String label;
  final String image;
  final String url;

  final List<Ingredient> ingredients;
  final double calories;
  final double totalWeight;
  final double totalTime;

  const Recipe({
    required this.id,
    required this.label,
    required this.image,
    required this.url,
    required this.ingredients,
    required this.calories,
    required this.totalWeight,
    required this.totalTime,
  });

  String get caloriesStr => getCalories(calories);

  @override
  List<Object?> get props => [
        label,
        image,
        url,
        ingredients,
        calories,
        totalWeight,
        totalTime,
      ];
}
