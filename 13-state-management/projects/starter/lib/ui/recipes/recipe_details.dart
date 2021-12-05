import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../data/sqlite/bookmarks.dart';
import '../../data/models/recipe.dart';

import '../colors.dart';

class RecipeDetails extends StatelessWidget {
  const RecipeDetails({Key? key, required this.recipe}) : super(key: key);
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: CachedNetworkImage(
                    imageUrl: recipe.image,
                    alignment: Alignment.topLeft,
                    fit: BoxFit.fill,
                    width: size.width,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: shim),
                    child: const BackButton(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                recipe.label,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Chip(label: Text(recipe.caloriesStr))),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      floatingActionButton: _buildBookmarkButton(context),
    );
  }

  Widget _buildBookmarkButton(context) {
    final bookmarks = Provider.of<Bookmarks>(context, listen: false);
    return FutureBuilder<bool>(
      future: bookmarks.exist(recipe),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('${snapshot.error}'),
          );
        }
        if (snapshot.hasData) {
          final bookmarked = snapshot.data!;
          return ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              primary: green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            onPressed: () async {
              bookmarks.add(recipe);
              Navigator.pop(context);
            },
            icon: bookmarked
                ? const Icon(Icons.bookmark_added)
                : const Icon(Icons.bookmark_border),
            label: Text(
              bookmarked ? 'Bookmarked' : 'Bookmark',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
