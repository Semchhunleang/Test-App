class HelpdeskTicketType {
  final int id;
  final int? sequence;
  final String name;

  HelpdeskTicketType({
    required this.id,
    this.sequence,
    required this.name,
  });

  factory HelpdeskTicketType.fromJson(Map<String, dynamic> json) {
    return HelpdeskTicketType(
      id: json['id'],
      sequence: json['sequence'],
      name: json['name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sequence': sequence,
      'name': name
    };
  }
}
