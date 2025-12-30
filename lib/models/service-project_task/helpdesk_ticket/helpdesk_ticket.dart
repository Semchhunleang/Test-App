class HelpdeskTicket {
  final int id;
  final String? enquiryNo;
  final String name;

  HelpdeskTicket({
    required this.id,
    this.enquiryNo,
    required this.name,
  });

  factory HelpdeskTicket.fromJson(Map<String, dynamic> json) {
    return HelpdeskTicket(
      id: json['id'],
      enquiryNo: json['enquiry_no'],
      name: json['name'],
    );
  }
}
