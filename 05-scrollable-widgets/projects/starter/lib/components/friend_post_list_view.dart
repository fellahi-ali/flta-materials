import 'package:flutter/material.dart';
import 'components.dart';
import '../models/models.dart';

class FriendPostListView extends StatelessWidget {
  final List<Post> posts;

  const FriendPostListView({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Social Chefs 👩‍🍳',
            style: Theme.of(context).textTheme.headline1,
          ),
          const SizedBox(height: 16),
          ListView.separated(
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) => FriendPostTile(
              post: posts[index],
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          ),
        ],
      ),
    );
  }
}
