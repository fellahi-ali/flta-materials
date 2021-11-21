import 'dart:async';

import 'package:chopper/chopper.dart';
import 'dart:convert';
import 'recipe_model.dart';
import 'response_model.dart';

class ApiRecipesConverter implements Converter {
  @override
  FutureOr<Request> convertRequest(Request request) {
    final req = applyHeader(
      request,
      contentTypeKey,
      jsonApiHeaders,
      override: false,
    );
    return encodeJson(req);
  }

  Request encodeJson(Request request) {
    final contentType = request.headers[contentTypeKey];
    if (contentType != null && contentType.contains(jsonHeaders)) {
      return request.copyWith(body: json.encode(request.body));
    }
    return request;
  }

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(
    Response response,
  ) =>
      decodeJson(response);

  Response<BodyType> decodeJson<BodyType, InnerType>(Response response) {
    final contentType = response.headers[contentTypeKey];
    var body = response.body;
    if (contentType != null && contentType.contains(jsonHeaders)) {
      body = utf8.decode(response.bodyBytes);
    }
    try {
      final jsonMap = json.decode(body);
      if (jsonMap['status'] != null) {
        return response.copyWith(
          body: Faileur(Exception(jsonMap)) as BodyType,
        );
      }
      final recipesResult = ApiRecipesResult.fromJson(jsonMap);
      return response.copyWith(
        body: Success(recipesResult) as BodyType,
      );
    } catch (e) {
      chopperLogger.warning(e);
      return response.copyWith(
        body: Faileur(e as Exception) as BodyType,
      );
    }
  }
}

class ApiErrorConverter extends ErrorConverter {
  @override
  FutureOr<Response> convertError<BodyType, InnerType>(
    Response response,
  ) {
    final error = {
      'code': response.statusCode,
      'body': response.body,
    };
    return response.copyWith(body: error);
  }
}
