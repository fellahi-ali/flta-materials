import 'package:flutter/material.dart';
import 'home.dart';
import 'fooderlich_theme.dart';

void main() {
  // 1
  runApp(const Fooderlich());
}

class Fooderlich extends StatelessWidget {
  // 2
  const Fooderlich({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = FooderlichTheme.dark();
    // TODO: Apply Home widget
    // 3
    return MaterialApp(
      title: 'Fooderlich',
      theme: _theme,
      // 4
      home: const Home(),
    );
  }
}
