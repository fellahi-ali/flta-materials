class AppRoute {
  static const String homePath = '/home';
  static const onboardingPath = '/onboarding';
  static const loginPath = '/login';
  static const profilePath = '/profile';
  static const itemPath = '/item';

  static const String tabParam = 'tab';
  static const String idParam = 'id';

  String location;
  int? currentTab;
  String? itemId;

  AppRoute({
    required this.location,
    this.currentTab,
    this.itemId,
  });

  static AppRoute fromLocation(String location) {
    location = Uri.decodeFull(location);
    final uri = Uri.parse(location);
    final params = uri.queryParameters;

    final currentTab = int.tryParse(params[tabParam] ?? '');
    final itemId = params[idParam];

    return AppRoute(
      location: uri.path,
      currentTab: currentTab,
      itemId: itemId,
    );
  }

  String toLocation() {
    String encodeKeyValPair({required String key, String? value}) {
      return value == null ? '' : '$key=$value&';
    }

    switch (location) {
      case loginPath:
      case onboardingPath:
      case profilePath:
        return location;
      case homePath:
        var loc = '$homePath';
        loc += currentTab == null ? '' : '?';
        loc += encodeKeyValPair(key: tabParam, value: currentTab?.toString());
        return Uri.encodeFull(loc);
      case itemPath:
        var loc = '$itemPath';
        loc += itemId == null ? '' : '?';
        loc += encodeKeyValPair(key: idParam, value: itemId);
        return Uri.encodeFull(loc);
      default:
        return homePath;
    }
  }
}
