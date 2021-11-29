import 'package:chopper/chopper.dart';
import 'model_response.dart';
import 'recipe_model.dart';

abstract class ApiService {
  Future<Response<Result<ApiRecipeQuery>>> queryRecipes(
    String query,
    int from,
    int to,
  );
}
