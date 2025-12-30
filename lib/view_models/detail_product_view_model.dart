import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:umgkh_mobile/models/e-catalog/product/product.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class DetailProductViewModel extends ChangeNotifier {
  final Product data;
  final String url;
  final String urlMaintenance;

  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  DetailProductViewModel(
      {required this.data, required this.url, required this.urlMaintenance}) {
    _initialize();
  }

  late Future<File> _pdfFile;
  late Future<File> _pdfFileMaintenance;
  late Future<void> _dividerFuture;
  int _totalPages = 0;
  int _currentPage = 0;
  int _totalDivider = 1;
  int _tabActive = 1;

  // Public getters
  Future<File> get pdfFile => _pdfFile;
  Future<File> get pdfFileMaintenance => _pdfFileMaintenance;
  Future<void> get dividerFuture => _dividerFuture;
  int get totalPages => _totalPages;
  int get currentPage => _currentPage;
  int get totalDivider => _totalDivider;
  int get tabActive => _tabActive;
  String pathFile = "";

  Future<void> _initialize() async {
    _pdfFile = _downloadPDF(url, 'catalog_pdf.pdf');
    _pdfFileMaintenance = _downloadPDF(urlMaintenance, 'maintenance_pdf.pdf');
    _dividerFuture = _countDivider();
    notifyListeners();
  }

  Future<void> _countDivider() async {
    _totalDivider = 0;
    if (data.textDesc != '-') _totalDivider += 1;
    if (data.parameter != '-' && data.parameter != '') _totalDivider += 1;
    if (data.features != '-' && data.features != '') _totalDivider += 1;
    notifyListeners();
  }

  Future<File> _downloadPDF(String url, String fileName) async {
    final response = await ioClient.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file;
    } else {
      throw Exception('Failed to load PDF');
    }
  }

  void setTabActive(int tabIndex) {
    _tabActive = tabIndex;
    notifyListeners();
  }

  void updatePage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void updateTotalPages(int pages) {
    _totalPages = pages;
    notifyListeners();
  }

  Future<void> downloadFile(
      String localFilePath, String fileName, BuildContext context) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = "${directory.path}/$fileName";

      File fileToSave = File(localFilePath);
      if (!await fileToSave.exists()) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("File does not exist at $localFilePath")),
          );
        }
        return;
      }

      await fileToSave.copy(filePath);

      // Open the file
      OpenFile.open(filePath);
    } catch (e) {
      debugPrint("Download error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Download failed: $e")),
        );
      }
    }
  }
}
