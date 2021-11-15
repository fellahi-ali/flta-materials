import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_dropdown.dart';
import '../colors.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  static const String prefSearchKey = 'previousSearches';
  late TextEditingController searchTextController;
  final ScrollController _scrollController = ScrollController();
  List currentSearchList = [];
  int currentCount = 0;
  int currentStartPosition = 0;
  int currentEndPosition = 20;
  int pageCount = 20;
  bool hasMore = false;
  bool loading = false;
  bool inErrorState = false;
  late Set<String> previousSearches;

  @override
  void initState() {
    super.initState();
    loadPreviousSearches().then((res) => previousSearches = res);
    searchTextController = TextEditingController(text: '');
    _scrollController
      ..addListener(() {
        final triggerFetchMoreSize =
            0.7 * _scrollController.position.maxScrollExtent;

        if (_scrollController.position.pixels > triggerFetchMoreSize) {
          if (hasMore &&
              currentEndPosition < currentCount &&
              !loading &&
              !inErrorState) {
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
    searchTextController.dispose();
    super.dispose();
  }

  /// save search trems in shared_prefs
  Future<bool> savePreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(prefSearchKey, previousSearches.toList());
  }

  Future<Set<String>> loadPreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    var searches = <String>[];
    if (prefs.containsKey(prefSearchKey)) {
      searches = prefs.getStringList(prefSearchKey) ?? [];
    }
    return searches.toSet();
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
      elevation: 3,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                startSearch(searchTextController.text);
                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
              },
            ),
            const SizedBox(width: 6.0),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextController,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                      autofocus: false,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (input) {
                        //TODO: why don't use startSearch()?
                        if (!previousSearches.contains(input)) {
                          previousSearches.add(input.trim());
                          savePreviousSearches();
                        }
                      },
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                    ),
                    onSelected: (value) {
                      searchTextController.text = value;
                      startSearch(value);
                    },
                    itemBuilder: (context) {
                      return previousSearches
                          .map((term) => CustomDropdownMenuItem<String>(
                                value: term,
                                text: term,
                                callback: () => setState(() {
                                  previousSearches.remove(term);
                                  // TODO: save previous searches?
                                  Navigator.pop(context);
                                }),
                              ))
                          .toList();
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

  void startSearch(String term) {
    setState(() {
      currentSearchList.clear();
      currentCount = 0;
      currentEndPosition = pageCount;
      currentStartPosition = 0;
      hasMore = true;
      previousSearches.add(term.trim());
      savePreviousSearches();
    });
  }

  Widget _buildRecipeLoader(BuildContext context) {
    if (searchTextController.text.length < 3) {
      return Container();
    }
    // Show a loading indicator while waiting for the movies
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
