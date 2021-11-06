import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/tab_manager.dart';

class EmptyGroceryScreen extends StatelessWidget {
  const EmptyGroceryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.asset('assets/fooderlich_assets/empty_list.png'),
              ),
            ),
            const Text('No Groceries', style: TextStyle(fontSize: 24)),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Shopping for ingredients?\nUse ✏ button to write them down!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            MaterialButton(
              child: const Text('Browse Recipes'),
              color: Colors.green,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              onPressed: () {
                Provider.of<HomeTabsState>(
                  context,
                  listen: false,
                ).goToTab(HomeTab.RECIPES);
              },
            ),
          ],
        ),
      ),
    );
  }
}
