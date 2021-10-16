import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FavoriteState();
}

class _FavoriteState extends State<FavoriteButton> {
  var _favorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_favorite ? Icons.favorite_rounded : Icons.favorite_border),
      iconSize: 30,
      color: _favorite ? Colors.red[400] : Colors.grey[400],
      onPressed: () {
        const snackBar = SnackBar(content: Text('Favorite changed'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          _favorite = !_favorite;
        });
      },
    );
  }
}
