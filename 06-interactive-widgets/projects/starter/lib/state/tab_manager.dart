import 'package:flutter/material.dart';
import '../screens/screens.dart';

enum HomeTab { EXPLORE, RECIPES, BUY }

class HomeTabsState extends ChangeNotifier {
  int selectedIndex = 0;

  final List<Widget> _tabs = [
    ExploreScreen(),
    RecipesScreen(),
    const GroceryScreen(),
  ];

  List<Widget> get allTabs => List.unmodifiable(_tabs);

  Widget getSelectedTab() => _tabs[selectedIndex];

  void goToTab(HomeTab tab) {
    goToIndex(tab.index);
  }

  void goToIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
