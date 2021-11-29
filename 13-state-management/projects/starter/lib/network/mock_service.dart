import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:chopper/chopper.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'service_interface.dart';
import 'model_response.dart';
import 'recipe_model.dart';

class MockService implements ApiService {
  final _jsonRecipes = [];
  final _random = Random();

  void create() async {
    final recipe1 = await rootBundle.loadString('assets/recipes1.json');
    _jsonRecipes.add(json.decode(recipe1));
    final recipe2 = await rootBundle.loadString('assets/recipes2.json');
    _jsonRecipes.add(json.decode(recipe2));
  }

  @override
  Future<Response<Result<ApiRecipeQuery>>> queryRecipes(
    String query,
    int from,
    int to,
  ) {
    final next = _random.nextInt(_jsonRecipes.length);
    final recipe = ApiRecipeQuery.fromJson(_jsonRecipes[next]);
    final response = Response(
      http.Response('mock', 200),
      Success(recipe),
    );
    return Future.value(response);
  }
}
