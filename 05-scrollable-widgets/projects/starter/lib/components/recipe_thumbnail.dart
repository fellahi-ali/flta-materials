import 'package:flutter/material.dart';
import 'package:fooderlich/models/models.dart';

class RecipeThumbnail extends StatelessWidget {
  final SimpleRecipe recipe;

  const RecipeThumbnail({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              child: Image.asset(recipe.dishImage, fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(recipe.title, style: textTheme.bodyText1, maxLines: 1),
          Text(recipe.duration, style: textTheme.bodyText2),
        ],
      ),
    );
  }
}
