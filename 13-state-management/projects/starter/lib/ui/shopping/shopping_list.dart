import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:recipes/data/memory_repo.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key}) : super(key: key);

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final checkBoxValues = Map<int, bool>();

  @override
  Widget build(BuildContext context) {
    return Consumer<MemoryRepo>(
      builder: (context, repo, child) {
        final ingredients = repo.findAllIngredients();
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
