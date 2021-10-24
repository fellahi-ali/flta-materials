import 'package:flutter/material.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../api/mock_fooderlich_service.dart';

class ExploreScreen extends StatelessWidget {
  final fooderlichService = MockFooderlichService();
  ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    scrollController.addListener(() {
      final minPos = scrollController.position.minScrollExtent;
      final maxPos = scrollController.position.maxScrollExtent;
      if (scrollController.offset == minPos) {
        print("I'm at the top");
      }
      if (scrollController.offset == maxPos) {
        print("I'm at the bottom");
      }
    });

    return FutureBuilder(
      future: fooderlichService.getExploreData(),
      builder: (context, AsyncSnapshot<ExploreData> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final recipes = snapshot.data?.todayRecipes ?? [];
          final posts = snapshot.data?.friendPosts ?? [];
          return ListView(
            controller: scrollController,
            children: [
              TodayRecipeListView(recipes: recipes),
              FriendPostListView(posts: posts),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
