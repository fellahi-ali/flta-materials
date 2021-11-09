import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

import 'explore_screen.dart';
import 'grocery_screen.dart';
import 'recipes_screen.dart';

class Home extends StatefulWidget {
  static MaterialPage page(int currentTab) => MaterialPage(
        name: FooderlichPages.home,
        key: ValueKey(FooderlichPages.home),
        child: Home(currentTab: currentTab),
      );

  const Home({
    Key? key,
    required this.currentTab,
  }) : super(key: key);

  final int currentTab;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<Widget> pages = <Widget>[
    ExploreScreen(),
    RecipesScreen(),
    const GroceryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateManager>(
      builder: (context, appState, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Fooderlich',
            style: Theme.of(context).textTheme.headline6,
          ),
          actions: [
            darkModeSwitch(),
            profileButton(),
          ],
        ),
        body: IndexedStack(index: widget.currentTab, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor:
              Theme.of(context).textSelectionTheme.selectionColor,
          currentIndex: widget.currentTab,
          onTap: appState.goToTab,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Explore',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Recipes',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'To Buy',
            ),
          ],
        ),
      ),
    );
  }

  Widget darkModeSwitch() {
    final profileManager = Provider.of<ProfileManager>(
      context,
      listen: false,
    );
    return IconButton(
      padding: const EdgeInsets.only(right: 12),
      onPressed: () {
        profileManager.darkMode = !profileManager.darkMode;
      },
      icon: Icon(profileManager.darkMode ? Icons.light_mode : Icons.dark_mode),
    );
  }

  Widget profileButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        child: const CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/profile_pics/person_stef.jpeg'),
        ),
        onTap: () => Provider.of<ProfileManager>(
          context,
          listen: false,
        ).tapOnProfile(true),
      ),
    );
  }
}
