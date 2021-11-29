import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../data/models/ingredient.dart';
import '../../data/repository.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key}) : super(key: key);

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final checkBoxValues = Map<int, bool>();

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<Repository>(context, listen: false);
    return StreamBuilder<List<Ingredient>>(
      stream: repo.watchIngredietns(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        final ingredients = snapshot.data ?? [];
        return ListView.builder(
            itemCount: ingredients.length,
            itemBuilder: (_, int index) {
              final checked = checkBoxValues[index] ?? false;
              return CheckboxListTile(
                value:
                    checkBoxValues.containsKey(index) && checkBoxValues[index]!,
                title: Text(
                  ingredients[index].name,
                  style: TextStyle(
                    decoration: checked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => checkBoxValues[index] = newValue);
                  }
                },
              );
            });
      },
    );
  }
}
