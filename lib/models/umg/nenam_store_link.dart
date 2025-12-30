class NenamStoreLink {
  int id;
  String name;
  String code;
  String link;

  NenamStoreLink({
    required this.id,
    required this.name,
    required this.code,
    required this.link,
  });

  factory NenamStoreLink.fromJson(Map<String, dynamic> json) {
    return NenamStoreLink(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      link: json['link'] ?? '',
    );
  }
}
