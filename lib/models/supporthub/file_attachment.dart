class FileAttachment {
  int id;
  String name;
  String extension;
  String megabytes;
  String downloadedFile;

  FileAttachment({
    required this.id,
    required this.name,
    required this.extension,
    required this.megabytes,
    required this.downloadedFile,
  });

  factory FileAttachment.fromJson(Map<String, dynamic> json) {
    return FileAttachment(
      id: json['id'],
      name: json['name'],
      extension: json['extension'],
      megabytes: json['megabytes'],
      downloadedFile: json['downloaded_ile'] ?? "",
    );
  }
}
