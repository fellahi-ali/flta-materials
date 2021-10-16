import 'package:flutter/material.dart';
import 'card1.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // represent the state tracked by this state object
  int _selectedIndex = 0;

  void _onItemTaped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = <Widget>[
    const Card1(),
    Container(color: Colors.deepOrangeAccent),
    Container(color: Colors.blueAccent),
  ];

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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTaped,
        currentIndex: _selectedIndex,
        selectedItemColor: _theme.textSelectionTheme.selectionColor,
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
