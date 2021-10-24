import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'flutter_svg.dart';
import 'fooderlich_theme.dart';

class Card3 extends StatelessWidget {
  const Card3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = FooderlichTheme.darkTextTheme;
    final categories = ['Healthy', 'Vegan', 'Carrots', 'Green'];

    return Center(
      child: Container(
        //padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints.expand(width: 350, height: 500),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mag2.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(children: [
          Center(child: flutterLogo()),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.book, size: 48),
                const SizedBox(height: 8),
                Text('Recipe Trends', style: theme.headline2),
                const SizedBox(height: 30),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((category) {
                    return _buildChip(category, theme, context);
                  }).toList(),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Chip _buildChip(String category, TextTheme theme, BuildContext context) {
    return Chip(
      label: Text(category, style: theme.bodyText1),
      backgroundColor: Colors.black.withOpacity(0.7),
      onDeleted: () {
        final snackBar = SnackBar(
          content: Text('Delete ${category}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }
}
