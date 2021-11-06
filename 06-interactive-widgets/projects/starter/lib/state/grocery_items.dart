import 'package:flutter/material.dart';
import '../models/grocery_item.dart';

class GroceryItemsState extends ChangeNotifier {
  final _items = <GroceryItem>[];

  List<GroceryItem> get groceryItems => List.unmodifiable(_items);

  void addItem(GroceryItem item) {
    _items.add(item);
    notifyListeners();
  }

  void update(GroceryItem item, int index) {
    _items[index] = item;
    notifyListeners();
  }

  void deleteItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void changeCompleted(int index, bool change) {
    final item = _items[index];
    _items[index] = item.copyWith(isComplete: change);
    notifyListeners();
  }
}
