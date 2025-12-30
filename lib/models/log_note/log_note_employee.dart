class LogNoteEmployee {
  int id;
  int profile;
  String name;

  LogNoteEmployee({
    required this.id,
    required this.profile,
    required this.name,
  });

  factory LogNoteEmployee.fromJson(Map<String, dynamic> json) {
    return LogNoteEmployee(
      id: json['id'],
      profile: json['profile'] ?? 0,
      name: json['name'],
    );
  }
}
