import 'package:flutter/material.dart';
import 'fooderlich_theme.dart';
import 'circle_image.dart';

class AuthorCard extends StatelessWidget {
  final String authorName;
  final String title;
  final ImageProvider? imageProvider;

  const AuthorCard({
    Key? key,
    required this.authorName,
    required this.title,
    this.imageProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = FooderlichTheme.lightTextTheme;
    return Row(
      children: [
        CircleImage(
          imageProvider: imageProvider,
          imageRadius: 28,
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(authorName, style: theme.headline2),
            Text(title, style: theme.headline3),
          ],
        )
      ],
    );
  }
}
