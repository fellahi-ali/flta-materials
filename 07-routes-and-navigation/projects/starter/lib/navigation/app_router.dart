import 'package:flutter/material.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;
  final GroceryManager groceryManager;
  final ProfileManager profileManager;

  AppRouter({
    required this.appStateManager,
    required this.groceryManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    groceryManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    groceryManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: _pages(),
    );
  }

  List<Page<dynamic>> _pages() => [
        // splash
        if (!appStateManager.isInitialized) SplashScreen.page(),
        // login
        if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
          LoginScreen.page(),
        // onboarding
        if (appStateManager.isLoggedIn && !appStateManager.isOnboardingComplete)
          OnboardingScreen.page(),
        // home
        if (appStateManager.isOnboardingComplete)
          Home.page(appStateManager.getSelectedTab),
        // new item
        if (groceryManager.isCreatingNewItem)
          GroceryItemScreen.page(
            onCreate: groceryManager.addItem,
            onUpdate: (item, index) {},
          ),
        // edit item
        if (groceryManager.selectedIndex != -1)
          GroceryItemScreen.page(
            item: groceryManager.selectedGroceryItem,
            index: groceryManager.selectedIndex,
            onCreate: (_) => throw Error(),
            onUpdate: groceryManager.updateItem,
          ),
        // profile
        if (profileManager.didSelectUser)
          ProfileScreen.page(profileManager.getUser),
        // raywenderlich.com
        if (profileManager.didTapOnRaywenderlich) WebViewScreen.page(),
      ];

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) return false;

    if (route.settings.name == FooderlichPages.onboardingPath) {
      appStateManager.logout();
    }
    if (route.settings.name == FooderlichPages.groceryItemDetails) {
      groceryManager.groceryItemTapped(-1);
    }
    if (route.settings.name == FooderlichPages.profilePath) {
      profileManager.tapOnProfile(false);
    }
    if (route.settings.name == FooderlichPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }
    return true;
  }

  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
