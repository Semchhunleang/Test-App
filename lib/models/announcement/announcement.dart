class Announcement {
  final String name;
  final String body;

  const Announcement({required this.name, required this.body});

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(name: json['name'] ?? '', body: json['body'] ?? '');
  }
}
