import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'state/grocery_items.dart';
import 'package:provider/provider.dart';
import 'fooderlich_theme.dart';
import 'home.dart';
import 'state/tab_manager.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const Fooderlich(),
    ),
  );
}

class Fooderlich extends StatelessWidget {
  const Fooderlich({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeTabsState()),
        ChangeNotifierProvider(create: (context) => GroceryItemsState())
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        theme: FooderlichTheme.light(),
        darkTheme: FooderlichTheme.dark(),
        themeMode: ThemeMode.dark,
        title: 'Fooderlich',
        home: const Home(),
      ),
    );
  }
}
