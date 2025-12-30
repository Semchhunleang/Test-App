class ICTDeviceModel {
  int id;
  String name;

  ICTDeviceModel({
    required this.id,
    required this.name,
  });

  factory ICTDeviceModel.fromJson(Map<String, dynamic> json) {
    return ICTDeviceModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
