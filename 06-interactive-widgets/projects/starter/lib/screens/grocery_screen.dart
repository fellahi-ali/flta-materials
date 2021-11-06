import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'empty_grocery_screen.dart';
import 'grocery_list_screen.dart';
import 'grocery_item_screen.dart';
import '../state/grocery_items.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GroceryItemsState>(
        builder: (context, groceryState, child) {
          return groceryState.groceryItems.isEmpty
              ? const EmptyGroceryScreen()
              : GroceryListScreen(groceryItemsState: groceryState);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: buildGroceryItemScreen),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget buildGroceryItemScreen(context) {
    final itemsState = Provider.of<GroceryItemsState>(context, listen: false);
    return GroceryItemScreen(
      onCreate: (item) {
        itemsState.addItem(item);
        Navigator.pop(context);
      },
      onUpdate: (item) {},
      //originalItem: GroceryItem.fakeItem,
    );
  }
}
