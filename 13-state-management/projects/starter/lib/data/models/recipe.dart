import 'package:equatable/equatable.dart';
import '../../network/recipe_model.dart';
import 'ingredient.dart';

class Recipe extends Equatable {
  final int? id;
  final String label;
  final String image;
  final String url;

  List<Ingredient>? ingredients;
  final double calories;
  final double totalWeight;
  final double totalTime;

  Recipe({
    this.id,
    required this.label,
    required this.image,
    required this.url,
    this.ingredients,
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

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'],
        label: json['label'],
        image: json['image'],
        url: json['url'],
        //ingredients: [],
        calories: json['calories'],
        totalWeight: json['total_weight'],
        totalTime: json['total_time'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'label': label,
        'image': image,
        'url': url,
        //'ingredients': [],
        'calories': calories,
        'total_weight': totalWeight,
        'total_time': totalTime,
      };
}
