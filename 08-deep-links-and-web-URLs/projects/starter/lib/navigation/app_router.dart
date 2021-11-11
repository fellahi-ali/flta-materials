import 'package:flutter/material.dart';
import 'app_link.dart';

import '../models/models.dart';
import '../screens/screens.dart';

class AppRouter extends RouterDelegate<AppRoute>
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
      pages: [
        if (!appStateManager.isInitialized) ...[
          SplashScreen.page(),
        ] else if (!appStateManager.isLoggedIn) ...[
          LoginScreen.page(),
        ] else if (!appStateManager.isOnboardingComplete) ...[
          OnboardingScreen.page(),
        ] else ...[
          Home.page(appStateManager.getSelectedTab),
          if (groceryManager.isCreatingNewItem)
            GroceryItemScreen.page(onCreate: (item) {
              groceryManager.addItem(item);
            }, onUpdate: (item, index) {
              // No update
            }),
          if (groceryManager.selectedIndex != -1)
            GroceryItemScreen.page(
                item: groceryManager.selectedGroceryItem,
                index: groceryManager.selectedIndex,
                onCreate: (_) {
                  // No create
                },
                onUpdate: (item, index) {
                  groceryManager.updateItem(item, index);
                }),
          if (profileManager.didSelectUser)
            ProfileScreen.page(profileManager.getUser),
          if (profileManager.didTapOnRaywenderlich) WebViewScreen.page(),
        ]
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }

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

  // convert App state to an AppLink
  AppRoute getCurrentPath() {
    if (!appStateManager.isLoggedIn) {
      return AppRoute(location: AppRoute.loginPath);
    }
    if (!appStateManager.isOnboardingComplete) {
      return AppRoute(location: AppRoute.onboardingPath);
    }
    if (profileManager.didSelectUser) {
      return AppRoute(location: AppRoute.profilePath);
    }
    if (groceryManager.isCreatingNewItem) {
      return AppRoute(location: AppRoute.itemPath);
    }
    final groceryItem = groceryManager.selectedGroceryItem;
    if (groceryItem != null) {
      return AppRoute(location: AppRoute.itemPath, itemId: groceryItem.id);
    }
    return AppRoute(
      location: AppRoute.homePath,
      currentTab: appStateManager.getSelectedTab,
    );
  }

  @override
  AppRoute? get currentConfiguration => getCurrentPath();

  @override
  Future<void> setNewRoutePath(AppRoute appLink) async {
    switch (appLink.location) {
      case AppRoute.profilePath:
        profileManager.tapOnProfile(true);
        break;
      case AppRoute.itemPath:
        final id = appLink.itemId;
        if (id == null)
          groceryManager.createNewItem();
        else
          groceryManager.setSelectedGroceryItem(id);
        profileManager.tapOnProfile(false);
        break;
      case AppRoute.homePath:
        final tab = appLink.currentTab ?? 0;
        appStateManager.goToTab(tab);
        profileManager.tapOnProfile(false);
        groceryManager.groceryItemTapped(-1);
        break;
      default:
        break;
    }
  }
}
