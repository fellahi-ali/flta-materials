import 'package:flutter/material.dart';
import 'app_link.dart';

class AppRouteParser extends RouteInformationParser<AppRoute> {
  @override
  Future<AppRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    return AppRoute.fromLocation(routeInformation.location ?? '');
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoute appLink) {
    return RouteInformation(location: appLink.toLocation());
  }
}
