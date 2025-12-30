class JobGroup {
  final int id;
  final String name;

  JobGroup({
    required this.id,
    required this.name,
  });

  factory JobGroup.fromJson(Map<String, dynamic> json) {
    return JobGroup(
      id: json['id'],
      name: json['name'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name
    };
  }
}
