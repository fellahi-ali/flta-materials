import 'package:flutter/material.dart';

import '../api/mock_fooderlich_service.dart';
import '../components/components.dart';
import '../models/models.dart';

class MyScrollController extends ScrollController {
  MyScrollController() {
    addListener(createListener);
  }

  void createListener() {
    if (offset == position.minScrollExtent) {
      print('top reached!');
    }
    if (offset == position.maxScrollExtent) {
      print('bottom reached');
    }
  }
}

class ExploreScreen extends StatelessWidget {
  final mockService = MockFooderlichService();
  final _controller = MyScrollController();

  ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print('ExploreScreen build() / ${_controller}');
    //_controller = MyScrollController();
    return FutureBuilder(
      future: mockService.getExploreData(),
      builder: (context, AsyncSnapshot<ExploreData> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView(
            scrollDirection: Axis.vertical,
            controller: _controller,
            children: [
              TodayRecipeListView(recipes: snapshot.data?.todayRecipes ?? []),
              const SizedBox(height: 16),
              FriendPostListView(
                friendPosts: snapshot.data?.friendPosts ?? [],
              )
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
