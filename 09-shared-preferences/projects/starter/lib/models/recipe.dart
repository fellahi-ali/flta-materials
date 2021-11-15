class Recipe {
  final String url;
  final String label;
  Recipe({required this.url, required this.label});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      url: json['url'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() => {'url': url, 'label': label};
}
