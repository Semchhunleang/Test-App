class Partner {
  final int id;
  final String name;
  final String email;

  Partner({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json["id"],
      name: json["name"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
    };
  }
}
