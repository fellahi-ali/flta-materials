import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final int id;
  final int recipeId;
  final String name;
  final double weight;

  const Ingredient({
    required this.id,
    required this.recipeId,
    required this.name,
    required this.weight,
  });

  @override
  List<Object?> get props => [recipeId, name, weight];
}
