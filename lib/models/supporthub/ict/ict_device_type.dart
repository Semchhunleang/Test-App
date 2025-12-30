class ICTDeviceType {
  int id;
  String name;

  ICTDeviceType({
    required this.id,
    required this.name,
  });

  factory ICTDeviceType.fromJson(Map<String, dynamic> json) {
    return ICTDeviceType(
      id: json['id'],
      name: json['name'],
    );
  }
}
