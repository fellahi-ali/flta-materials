import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final int? id;
  final int recipeId;
  final String name;
  final double weight;

  const Ingredient({
    this.id,
    required this.recipeId,
    required this.name,
    required this.weight,
  });

  Ingredient copyWith({
    int? id,
    int? recipeId,
    String? name,
    double? weight,
  }) =>
      Ingredient(
        id: id ?? this.id,
        recipeId: recipeId ?? this.recipeId,
        name: name ?? this.name,
        weight: weight ?? this.weight,
      );

  @override
  List<Object?> get props => [recipeId, name, weight];

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json['id'],
        recipeId: json['recipe_id'],
        name: json['name'],
        weight: json['weight'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'recipe_id': recipeId,
        'name': name,
        'weight': weight,
      };
}
