import 'package:flutter/material.dart';

import 'fooderlich_theme.dart';
import 'home.dart';

void main() {
  runApp(const Fooderlich());
}

class Fooderlich extends StatelessWidget {
  const Fooderlich({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FooderlichTheme.light(),
      darkTheme: FooderlichTheme.dark(),
      themeMode: ThemeMode.dark,
      title: 'Fooderlich',
      // TODO 8: Replace this with MultiProvider
      home: const Home(),
    );
  }
}
