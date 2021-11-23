import 'dart:io' show Platform;
import 'package:chopper/chopper.dart';
import '../env.dart';
import 'service_interface.dart';
import 'recipe_model.dart';
import 'model_response.dart';
import 'model_converter.dart';

part 'recipe_service.chopper.dart';

final String apiKey = Env.edamamKey;
final String apiId = Env.edamamId;
const String apiUrl = 'https://api.edamam.com';

@ChopperApi()
abstract class RecipeService extends ChopperService
    implements ServiceInterface {
  @override
  @Get(path: 'search')
  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
    @Query('q') String query,
    @Query('from') int from,
    @Query('to') int to,
  );

  static RecipeService create() {
    final client = ChopperClient(
      baseUrl: apiUrl,
      interceptors: [_addQuery, HttpLoggingInterceptor()],
      converter: ModelConverter(),
      errorConverter: const JsonConverter(),
      services: [
        _$RecipeService(),
      ],
    );
    return _$RecipeService(client);
  }
}

Request _addQuery(Request req) {
  final params = Map<String, dynamic>.from(req.parameters);
  params['app_id'] = apiId;
  params['app_key'] = apiKey;

  return req.copyWith(parameters: params);
}
