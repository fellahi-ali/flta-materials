import 'dart:convert';

import 'package:http/http.dart';
import 'dart:io' show Platform;

class RecipeService {
  static const apiUrl = 'https://api.edamam.com/search';
  static const apiId = 'eec72b3c';
  static final apiKey = Platform.environment['EDAMAM_API_KEY'];

  Future<String> fetchData(String url) async {
    print('fetching data from: $url');
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('${response.statusCode}: ${response.reasonPhrase}');
      throw Exception("can't fetch data from $url");
    }
  }

  /// return fetched recipes and decoded as Json map
  Future fetchRecipes({
    required String query,
    int from = 0,
    int to = 10,
  }) async {
    final data = await fetchData(
        '$apiUrl?app_id=$apiId&app_key=$apiKey&q=$query&from=$from&to=$to');
    return json.decode(data);
  }
}
