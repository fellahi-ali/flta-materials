import 'package:flutter_test/flutter_test.dart';
import 'package:fooderlich/navigation/app_link.dart';
//import 'package:test/test.dart';

void main() {
  test('Uri.decodeFull()', () => print(Uri.decodeFull(AppRoute.homePath)));
  test('AppLink toLocation() should return correct URL', () {
    expect(
      AppRoute(location: AppRoute.homePath).toLocation(),
      equals('/home'),
    );
    expect(
      AppRoute(location: 'blabla').toLocation(),
      equals('/home'),
    );
    expect(
      AppRoute(location: AppRoute.homePath, currentTab: 1).toLocation(),
      equals('/home?tab=1&'),
    );
    expect(
      AppRoute(location: AppRoute.itemPath).toLocation(),
      equals('/item'),
    );
    expect(
      AppRoute(location: AppRoute.itemPath, itemId: '2').toLocation(),
      equals('/item?id=2&'),
    );
    expect(
      AppRoute(location: AppRoute.loginPath).toLocation(),
      equals('/login'),
    );
    expect(
      AppRoute(location: AppRoute.profilePath).toLocation(),
      equals('/profile'),
    );
    expect(
      AppRoute(location: AppRoute.onboardingPath).toLocation(),
      equals('/onboarding'),
    );
  });
}
