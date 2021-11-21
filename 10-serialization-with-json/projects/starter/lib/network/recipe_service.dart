import 'dart:io' show Platform;
import 'package:chopper/chopper.dart';
import 'recipe_model.dart';
import 'response_model.dart';
import 'model_converter.dart';

part 'recipe_service.chopper.dart';

const _apiUrl = 'https://api.edamam.com';
const _apiId = 'eec72b3c';
final _apiKey = Platform.environment['EDAMAM_API_KEY'];

@ChopperApi(baseUrl: _apiUrl)
abstract class RecipeService extends ChopperService {
  @Get(path: 'search')
  Future<Response<Result<ApiRecipesResult>>> getRecipes(
    @Query('q') String query,
    @Query('from') int from,
    @Query('to') int to,
  );

  static RecipeService create() {
    final client = ChopperClient(
      baseUrl: _apiUrl,
      interceptors: [_addApiKey, HttpLoggingInterceptor()],
      converter: ApiRecipesConverter(),
      errorConverter: const JsonConverter(),
      services: [_$RecipeService()],
    );
    return _$RecipeService(client);
  }
}

//
Request _addApiKey(Request req) {
  final params = Map<String, dynamic>.from(req.parameters);
  params['app_id'] = _apiId;
  params['app_key'] = _apiKey;
  return req.copyWith(parameters: params);
}
