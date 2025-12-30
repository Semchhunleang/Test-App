class AccessLevel {
  final int isDh;
  final int isHc;
  final int isHrd;
  final int isHrc;
  final int isUnderLevel;
  final int a4;
  final int tsb;
  final int isAmDh;
  final int isCrmUnit;
  final int isCrmSparepart;
  final int smallPaper;
  final int scanSmallPaper;
  final int vehicleCheck;
  final int scanVehicleCheck;
  final int fieldService;
  final int workshop;
  final int isAfterSalesGeneralManager;
  final int isFieldServiceGeneralManager;
  final int isAdminHead;
  final int isReadRequestOT;
  final int isReadOT;
  final int isSubmitRequestOT;
  final int isSubmitOT;
  final int isApproveOT;

  const AccessLevel({
    required this.isDh,
    required this.isHc,
    required this.isHrd,
    required this.isHrc,
    required this.isUnderLevel,
    required this.a4,
    required this.tsb,
    required this.isAmDh,
    required this.isCrmUnit,
    required this.isCrmSparepart,
    required this.smallPaper,
    required this.scanSmallPaper,
    required this.vehicleCheck,
    required this.scanVehicleCheck,
    required this.fieldService,
    required this.workshop,
    required this.isAfterSalesGeneralManager,
    required this.isFieldServiceGeneralManager,
    required this.isAdminHead,
    required this.isReadRequestOT,
    required this.isReadOT,
    required this.isSubmitRequestOT,
    required this.isSubmitOT,
    required this.isApproveOT,
  });

  factory AccessLevel.fromJson(Map<String, dynamic> json) {
    return AccessLevel(
      isDh: json['is_dh'] ?? 0,
      isHc: json['is_hc'] ?? 0,
      isHrd: json['is_hrd'] ?? 0,
      isHrc: json['is_hrc'] ?? 0,
      isUnderLevel: json['is_under_level'] ?? 0,
      a4: json['a4'] ?? 0,
      tsb: json['tsb'] ?? 0,
      isAmDh: json['is_am_dh'] ?? 0,
      isCrmUnit: json['is_crm_unit'] ?? 0,
      isCrmSparepart: json['is_crm_sparepart'] ?? 0,
      smallPaper: json['small_paper'] ?? 0,
      scanSmallPaper: json['scan_small_paper'] ?? 0,
      vehicleCheck: json['vehicle_check'] ?? 0,
      scanVehicleCheck: json['scan_vehicle_check'] ?? 0,
      fieldService: json['field_service'] ?? 0,
      workshop: json['workshop'] ?? 0,
      isAfterSalesGeneralManager: json['is_after_sales_general_manager'] ?? 0,
      isFieldServiceGeneralManager:
          json['is_field_service_general_manager'] ?? 0,
      isAdminHead: json['is_service_admin_head'] ?? 0,
      isReadRequestOT: json['is_read_request_ot'] ?? 0,
      isReadOT: json['is_read_ot'] ?? 0,
      isSubmitRequestOT: json['is_submit_request_ot'] ?? 0,
      isSubmitOT: json['is_submit_ot'] ?? 0,
      isApproveOT: json['is_approve_ot'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'is_dh': isDh,
      'is_hc': isHc,
      'is_hrd': isHrd,
      'is_hrc': isHrc,
      'is_under_level': isUnderLevel,
      'a4': a4,
      'tsb': tsb,
      'is_am_dh': isAmDh,
      'is_crm_unit': isCrmUnit,
      'is_crm_sparepart': isCrmSparepart,
      'small_paper': smallPaper,
      'scan_small_paper': scanSmallPaper,
      'vehicle_check': vehicleCheck,
      'scan_vehicle_check': scanVehicleCheck,
      'field_service': fieldService,
      'workshop': workshop,
      'is_after_sales_general_manager': isAfterSalesGeneralManager,
      'is_field_service_general_manager': isFieldServiceGeneralManager,
      'is_service_admin_head': isAdminHead,
      'is_read_request_ot': isReadRequestOT,
      'is_read_ot': isReadOT,
      'is_submit_request_ot': isSubmitRequestOT,
      'is_submit_ot': isSubmitOT,
      'is_approve_ot': isApproveOT,
    };
  }
}
