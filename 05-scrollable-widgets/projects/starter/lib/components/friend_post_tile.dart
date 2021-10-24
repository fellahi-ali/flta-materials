import 'package:flutter/material.dart';
import '../models/models.dart';
import 'components.dart';

class FriendPostTile extends StatelessWidget {
  final Post post;

  const FriendPostTile({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleImage(
          imageProvider: AssetImage(post.profileImageUrl),
          imageRadius: 20,
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.comment,
                style: theme.textTheme.bodyText2,
              ),
              Text(
                '${post.timestamp} min ago',
                style: theme.textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
