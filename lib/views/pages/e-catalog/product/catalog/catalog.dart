import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/e-catalog/product/product.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/detail_product_view_model.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';

class CatalogPage extends StatelessWidget {
  final Product data;
  final String url;
  final String maintenanceUrl;
  const CatalogPage(
      {super.key, required this.data, this.url = "", this.maintenanceUrl = ""});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Catalog",
      body: ChangeNotifierProvider(
        create: (_) => DetailProductViewModel(
            data: data, url: url, urlMaintenance: maintenanceUrl),
        child: Consumer<DetailProductViewModel>(
          builder: (context, viewModel, child) {
            return FutureBuilder<void>(
              future: viewModel.dividerFuture,
              builder: (context, dividerSnapshot) {
                if (dividerSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (dividerSnapshot.hasError) {
                  return Center(
                    child:
                        Text('Error loading divider: ${dividerSnapshot.error}'),
                  );
                } else {
                  return FutureBuilder<File>(
                    future: viewModel.pdfFile,
                    builder: (context, pdfSnapshot) {
                      if (pdfSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (pdfSnapshot.hasError) {
                        return Center(
                          child:
                              Text('Error loading PDF: ${pdfSnapshot.error}'),
                        );
                      } else if (!pdfSnapshot.hasData ||
                          pdfSnapshot.data == null) {
                        return const Center(
                          child:
                              Text('No PDF file available for this product.'),
                        );
                      } else {
                        return Column(
                          children: [
                            Expanded(
                              child: PDFView(
                                filePath: pdfSnapshot.data!.path,
                                enableSwipe: true,
                                swipeHorizontal: true,
                                backgroundColor: Colors.white,
                                autoSpacing: true,
                                pageFling: true,
                                pageSnap: true,
                                onRender: (pages) {
                                  viewModel.updateTotalPages(pages!);
                                },
                                onPageChanged: (page, total) {
                                  viewModel.updatePage(page!);
                                },
                              ),
                            ),
                            if (data.haveCatalog == 1)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Page ${viewModel.currentPage + 1} of ${viewModel.totalPages}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            heithSpace
                          ],
                        );
                      }
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
