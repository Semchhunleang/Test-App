class UMGSocialMedia {
  int id;
  String name;
  String code;
  String link;
  List<UMGSocialMedia> links;

  UMGSocialMedia({
    required this.id,
    required this.name,
    required this.code,
    required this.link,
    required this.links,
  });

  factory UMGSocialMedia.fromJson(Map<String, dynamic> json) {
    return UMGSocialMedia(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      link: json['link'] ?? '',
      links: json['links'] != null
          ? List<UMGSocialMedia>.from(
              json['links'].map((item) => UMGSocialMedia.fromJson(item)))
          : [],
    );
  }
}
