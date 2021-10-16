import 'package:flutter/material.dart';
import 'favorite_buton.dart';
import 'author_card.dart';
import 'fooderlich_theme.dart';

class Card2 extends StatelessWidget {
  const Card2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = FooderlichTheme.lightTextTheme;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints.expand(width: 350, height: 500),
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/mag5.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AuthorCard(
                  authorName: 'Mike Katz',
                  title: 'Smoothie Connoisseur',
                  imageProvider: AssetImage('assets/author_katz.jpeg'),
                ),
                const FavoriteButton(),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Text('Recipe', style: theme.headline1),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 100,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text('Smoothies', style: theme.headline1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
