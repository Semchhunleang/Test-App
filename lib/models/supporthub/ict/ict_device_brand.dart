class ICTDeviceBrand {
  int id;
  String name;

  ICTDeviceBrand({
    required this.id,
    required this.name,
  });

  factory ICTDeviceBrand.fromJson(Map<String, dynamic> json) {
    return ICTDeviceBrand(
      id: json['id'],
      name: json['name'],
    );
  }
}
