class Survey {
  final int id;
  final String title;
  final String accessToken;

  Survey({
    required this.id,
    required this.title,
    required this.accessToken,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json["id"],
      title: json["title"],
      accessToken: json["access_token"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "access_token": accessToken,
    };
  }
}
