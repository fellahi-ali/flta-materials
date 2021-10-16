import 'package:flutter/material.dart';
import 'fooderlich_theme.dart';

class Card1 extends StatelessWidget {
  const Card1({Key? key}) : super(key: key);

  final String category = "Editor's Choice";
  final String title = 'The Art of Dough';
  final String description = 'Learn to make the perfect bread.';
  final String chef = 'Ray Wenderlich';

  @override
  Widget build(BuildContext context) {
    final theme = FooderlichTheme.darkTextTheme;
    return Center(
      child: Container(
        // units in flutter are logical pixels
        padding: const EdgeInsets.all(16),
        // constrain the size of the box
        constraints: const BoxConstraints.expand(width: 350, height: 500),
        // describe how to draw a box
        decoration: const BoxDecoration(
          // tells the bow to paint an image
          image: DecorationImage(
            // get the image from assets/
            image: AssetImage('assets/mag1.png'),
            // cover the entire box with the image
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Stack(
          children: [
            Text(category, style: theme.bodyText1),
            Positioned(
              child: Text(title, style: theme.headline5),
              top: 20,
            ),
            Positioned(
              child: Text(description, style: theme.bodyText2),
              bottom: 25,
              right: 0,
            ),
            Positioned(
              child: Text(chef, style: theme.bodyText2),
              bottom: 5,
              right: 0,
            ),
          ],
        ),
      ),
    );
  }
}
