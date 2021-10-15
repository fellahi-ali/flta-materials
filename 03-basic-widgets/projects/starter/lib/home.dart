import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // TODO: Add state variables and functions

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fooderlich',
          style: _theme.textTheme.headline6,
        ),
      ),
      // TODO: Show selected tab
      body: Center(
          child: Text(
        'Let\'s get cooking 👩‍🍳',
        style: _theme.textTheme.headline1,
      )),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: _theme.textSelectionTheme.selectionColor,
        // TODO: set selected tab
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Card1',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Card2',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Card1',
          ),
        ],
      ),
    );
  }
}
