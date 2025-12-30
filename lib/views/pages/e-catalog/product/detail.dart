import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/e-catalog/product/product.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/detail_product_view_model.dart';
import 'package:umgkh_mobile/view_models/product_images_view_model.dart';
import 'package:umgkh_mobile/views/pages/e-catalog/product/selection_image.dart';
import 'package:umgkh_mobile/views/pages/e-catalog/widget/button_tab.dart';
import 'package:umgkh_mobile/views/pages/e-catalog/widget/single_image_widget.dart';
import 'package:umgkh_mobile/views/pages/e-catalog/widget/slide_image_detail.dart';

class DetailProductPage extends StatefulWidget {
  final Product data;
  final String categoryType;
  final String url;
  final String maintenanceUrl;

  const DetailProductPage(
      {super.key,
      required this.url,
      required this.maintenanceUrl,
      required this.data,
      this.categoryType = ""});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final viewModel =
          Provider.of<ProductImagesViewModel>(context, listen: false);
      viewModel.fetchImagesProduct(widget.data.id);
      viewModel.resetData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailProductViewModel(
          data: widget.data,
          url: widget.url,
          urlMaintenance: widget.maintenanceUrl),
      child: Consumer2<DetailProductViewModel, ProductImagesViewModel>(
        builder: (context, viewModel, viewModel2, child) {
          return Scaffold(
            body: FutureBuilder<void>(
              future: viewModel.dividerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return FutureBuilder<List<File>>(
                    future: Future.wait(
                        [viewModel.pdfFile, viewModel.pdfFileMaintenance]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return NestedScrollView(
                              headerSliverBuilder: (BuildContext context,
                                  bool innerBoxIsScrolled) {
                                return <Widget>[
                                  SliverAppBar(
                                    expandedHeight:
                                        MediaQuery.of(context).size.width,
                                    floating: false,
                                    pinned: true,
                                    leading: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, top: 10.0),
                                      child: CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.grey.shade100,
                                        child: IconButton(
                                          iconSize: 20.0,
                                          icon: Icon(
                                            Platform.isIOS
                                                ? Icons.arrow_back_ios_new
                                                : Icons.arrow_back,
                                            color: primaryColor,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ),
                                    flexibleSpace: FlexibleSpaceBar(
                                      background: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 40.0),
                                        child: viewModel2
                                                .listProductImages.isEmpty
                                            // ||(viewModel2.listProductImages.isNotEmpty && viewModel2.listProductImages.length == 1)
                                            ? singleImageWidget(
                                                context, widget.data)
                                            : slideImageDetail(context,
                                                viewModel2, widget.data),
                                      ),
                                    ),
                                  ),
                                ];
                              },
                              body: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // if (viewModel2.listProductImages.length != 1)
                                  if (viewModel2
                                      .listProductImages.isNotEmpty) ...[
                                    heithSpace,
                                    const SelectionImage(),
                                  ],
                                  heithSpace,
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    child: Text(widget.data.name,
                                        style: primary15Bold),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.fromLTRB(
                                        10, 5, 10, 10),
                                    child: Text(
                                      widget.data.category!.completeName,
                                      style: primary12Bold,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      if (widget.data.textDesc != '-')
                                        ButtonTab(
                                          title: "Description",
                                          buttonClick: () {
                                            viewModel.setTabActive(1);
                                          },
                                          active: viewModel.tabActive == 1,
                                          dividerNumber: viewModel.totalDivider,
                                        ),
                                      if (widget.data.parameter != '-' &&
                                          widget.data.parameter != '')
                                        ButtonTab(
                                          title: "Parameter",
                                          buttonClick: () {
                                            viewModel.setTabActive(2);
                                          },
                                          active: viewModel.tabActive == 2,
                                          dividerNumber: viewModel.totalDivider,
                                        ),
                                      if (widget.data.features != '-' &&
                                          widget.data.features != '')
                                        ButtonTab(
                                          title: "Features",
                                          buttonClick: () {
                                            viewModel.setTabActive(3);
                                          },
                                          active: viewModel.tabActive == 3,
                                          dividerNumber: viewModel.totalDivider,
                                        ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 0),
                                      child: SingleChildScrollView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            if (viewModel.tabActive == 1)
                                              Text(widget.data.textDesc!,
                                                  style: primary12Bold),
                                            if (viewModel.tabActive == 2)
                                              Text(widget.data.parameter!,
                                                  style: primary12Bold),
                                            if (viewModel.tabActive == 3)
                                              Text(widget.data.features!,
                                                  style: primary12Bold),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                }
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: widget.data.haveCatalog == 1 ||
                    widget.data.haveMaintenanceSchedule == 1
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: (widget.data.haveMaintenanceSchedule == 1 &&
                                  widget.data.haveCatalog == 0) ||
                              (widget.data.haveMaintenanceSchedule == 0 &&
                                  widget.data.haveCatalog == 1)
                          ? MediaQuery.of(context).size.width * 0.45
                          : MediaQuery.of(context).size.width * 0.9,
                      height: 45,
                      child: Row(
                        children: [
                          if (widget.data.haveCatalog == 1)
                            Expanded(
                              child: FloatingActionButton(
                                onPressed: () async {
                                  final file = await viewModel.pdfFile;
                                  // navPush(
                                  //   context,
                                  //   CatalogPage(
                                  //     data: widget.data,
                                  //     url: widget.url,
                                  //   ),
                                  // );
                                  if (context.mounted) {
                                    viewModel.downloadFile(
                                        file.path, "e-catalog.pdf", context);
                                  }
                                },
                                backgroundColor: primaryColor,
                                child: Text(
                                  "Click For Catalog",
                                  style: titleStyle13.copyWith(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          widthSpace,
                          if (widget.data.haveMaintenanceSchedule == 1)
                            Expanded(
                              child: FloatingActionButton(
                                onPressed: () async {
                                  final file =
                                      await viewModel.pdfFileMaintenance;
                                  // navPush(
                                  //   context,
                                  //   CatalogPage(
                                  //     data: widget.data,
                                  //     url: widget.url,
                                  //   ),
                                  // );
                                  if (context.mounted) {
                                    viewModel.downloadFile(
                                        file.path, "e-catalog.pdf", context);
                                  }
                                },
                                backgroundColor: primaryColor,
                                child: Text(
                                  "Maintenance Schedule",
                                  style: titleStyle13.copyWith(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          );
        },
      ),
    );
  }
}
