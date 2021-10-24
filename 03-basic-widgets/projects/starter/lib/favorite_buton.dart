import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FavoriteState();
}

class _FavoriteState extends State<FavoriteButton> {
  var _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
      iconSize: 30,
      color: Colors.red[400],
      onPressed: () {
        const snackBar = SnackBar(content: Text('Favorite changed'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          _isFavorite = !_isFavorite;
        });
      },
    );
  }
}
