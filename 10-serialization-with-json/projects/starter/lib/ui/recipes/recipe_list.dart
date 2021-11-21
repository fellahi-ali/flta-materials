import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'recipe_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../network/recipe_model.dart';
import '../recipe_card.dart';
import '../colors.dart';
import '../widgets/custom_dropdown.dart';
import '../../network/recipe_service.dart';
import 'package:chopper/chopper.dart';
import '../../network/response_model.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  static const String prefSearchKey = 'previousSearches';

  late TextEditingController searchTextController;
  final ScrollController _scrollController = ScrollController();
  List<ApiHits> currentSearchResults = [];
  int currentCount = 0;
  int currentStartPosition = 0;
  int currentEndPosition = 20;
  int pageCount = 50;
  bool hasMore = false;
  bool loading = false;
  bool inErrorState = false;
  List<String> previousSearches = <String>[];

  @override
  void initState() {
    super.initState();
    getPreviousSearches();
    searchTextController = TextEditingController(text: '');
    _scrollController
      ..addListener(() {
        final triggerFetchMoreSize =
            0.7 * _scrollController.position.maxScrollExtent;

        if (_scrollController.position.pixels > triggerFetchMoreSize) {
          if (!inErrorState &&
              !loading &&
              hasMore &&
              currentEndPosition < currentCount) {
            setState(() {
              loading = true;
              currentStartPosition = currentEndPosition;
              currentEndPosition =
                  min(currentStartPosition + pageCount, currentCount);
            });
          }
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchTextController.dispose();
    super.dispose();
  }

  void savePreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(prefSearchKey, previousSearches);
  }

  void getPreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(prefSearchKey)) {
      final searches = prefs.getStringList(prefSearchKey);
      if (searches != null) {
        previousSearches = searches;
      } else {
        previousSearches = <String>[];
      }
    }
  }

  void startSearch(String value) {
    setState(() {
      currentSearchResults.clear();
      currentCount = 0;
      currentStartPosition = 0;
      currentEndPosition = pageCount;
      hasMore = true;
      value = value.trim();
      if (!previousSearches.contains(value)) {
        previousSearches.add(value);
        savePreviousSearches();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildSearchCard(),
            _buildRecipeLoader(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                startSearch(searchTextController.text);
                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
            ),
            const SizedBox(
              width: 6.0,
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Search'),
                    autofocus: false,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      if (!previousSearches.contains(value)) {
                        previousSearches.add(value);
                        savePreviousSearches();
                      }
                    },
                    controller: searchTextController,
                  )),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: lightGrey,
                    ),
                    onSelected: (String value) {
                      searchTextController.text = value;
                      startSearch(searchTextController.text);
                    },
                    itemBuilder: (BuildContext context) {
                      return previousSearches
                          .map<CustomDropdownMenuItem<String>>((String value) {
                        return CustomDropdownMenuItem<String>(
                          text: value,
                          value: value,
                          callback: () {
                            setState(() {
                              previousSearches.remove(value);
                              Navigator.pop(context);
                            });
                          },
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeLoader(BuildContext context) {
    if (searchTextController.text.length < 3) {
      return const Center(
        child: Text(
          'Type at least 3 letters 😎',
          style: TextStyle(fontSize: 16),
        ),
      );
    }
    return FutureBuilder<Response<Result<ApiRecipesResult>>>(
      future: RecipeService.create().getRecipes(
        searchTextController.text.trim(),
        currentStartPosition,
        currentEndPosition,
      ),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          loading = false;
          if (snapshot.hasError) {
            inErrorState = true;
            return _buildErrorReport(snapshot.error);
          }
          final response = snapshot.data!;
          if (!response.isSuccessful) {
            inErrorState = true;
            return _buildErrorReport(response.error);
          }
          final result = response.body;
          if (result is Faileur) {
            inErrorState = true;
            return _buildErrorReport((result as Faileur).exception);
          }
          final recipes = (result as Success<ApiRecipesResult>).value;
          currentCount = recipes.count;
          hasMore = recipes.more;
          currentSearchResults = recipes.hits;
          if (recipes.to < currentEndPosition) {
            currentEndPosition = recipes.to;
          }
          return _buildRecipesList(context, currentSearchResults);
        } else {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: LinearProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildErrorReport(error) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            textScaleFactor: 1.2,
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(
    BuildContext topLevelContext,
    List<ApiHits> hits,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(topLevelContext).push(RecipeDetails.page);
      },
      child: recipeCard(hits[index].recipe),
    );
  }

  Widget _buildRecipesList(context, List<ApiHits> hits) {
    final size = MediaQuery.of(context).size;
    const itemHeight = 310;
    final itemWidth = size.width / 2;

    return Flexible(
      child: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: itemWidth / itemHeight,
        ),
        itemCount: hits.length,
        itemBuilder: (_, index) => _buildRecipeCard(context, hits, index),
      ),
    );
  }
}
