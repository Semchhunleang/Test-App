class OfflineAction {
  final int id;
  final String? resModel;
  final int? resId;
  final String? action;
  final String? dataChange;

  OfflineAction(
      {required this.id,
      this.resModel,
      this.resId,
      this.action,
      this.dataChange});

  static OfflineAction fromJson(Map<String, dynamic> json) {
    OfflineAction result = OfflineAction(
      id: json['id'],
      resModel: json['res_model'],
      resId: json['res_id'],
      action: json['action'],
      dataChange: json['data_change'],
    );
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'res_model': resModel,
      'res_id': resId,
      'action': action,
      'data_change': dataChange,
    };
  }
}
