import 'package:flutter/material.dart';
import 'grocery_item_screen.dart';
import '../state/grocery_items.dart';
import '../components/components.dart';

class GroceryListScreen extends StatelessWidget {
  final GroceryItemsState groceryItemsState;
  const GroceryListScreen({
    Key? key,
    required this.groceryItemsState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groceryItems = groceryItemsState.groceryItems;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          final item = groceryItems[index];
          return Dismissible(
            key: Key(item.id),
            background: Container(
              child: const Icon(Icons.delete_forever, size: 48),
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 8),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              groceryItemsState.deleteItem(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.name} has been deleted!'),
                  backgroundColor: item.color,
                ),
              );
            },
            child: InkWell(
              child: GroceryTile(
                key: Key(item.id),
                item: item,
                onComplete: (checked) {
                  if (checked != null)
                    groceryItemsState.changeCompleted(index, checked);
                },
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return GroceryItemScreen(
                      originalItem: item,
                      onUpdate: (item) {
                        groceryItemsState.update(item, index);
                        Navigator.pop(context);
                      },
                      onCreate: (item) {},
                    );
                  },
                ));
              },
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
      ),
    );
  }
}
