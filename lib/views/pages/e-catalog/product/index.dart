import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/e-catalog/website_category/website_category.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/product_view_model.dart';
import 'package:umgkh_mobile/views/pages/e-catalog/widget/item_product_widget.dart';
import 'package:umgkh_mobile/views/pages/e-catalog/widget/selection_type_widget.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';

class ProductPage extends StatefulWidget {
  static const routeName = '/product-list';
  static const pageName = 'Product';
  final String categoryType;
  final List<WebsiteCategory>? children;

  const ProductPage({Key? key, this.categoryType = "", this.children})
      : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late TextEditingController _searchController;
  int selectedCategoryId = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      Provider.of<ProductPageViewModel>(context, listen: false)
          .filterCategories(_searchController.text);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
      final viewModel =
          Provider.of<ProductPageViewModel>(context, listen: false);
      final category = viewModel.findCategoryById(0);
      viewModel.filterByCategory(category!.id == 0 ? null : category);
    });
  }

  Future<void> _fetchData() async {
    if (mounted) {
      await Provider.of<ProductPageViewModel>(context, listen: false)
          .fetchWebsiteCategories();
    }
  }

  // void _showFilterDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Select Category', style: primary15Bold500),
  //         content: SizedBox(
  //           width: double.maxFinite,
  //           child: Consumer2<ECatalogViewModel, ProductPageViewModel>(
  //               builder: (context, viewModel, viewModelProduct, child) {
  //             return ListView(
  //               shrinkWrap: true,
  //               children: viewModel.filteredWebsiteCategories.map((category) {
  //                 return CategoryTile(
  //                     category: category,
  //                     level: 0,
  //                     selectedCategory: viewModelProduct.selectedCategory);
  //               }).toList(),
  //             );
  //           }),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ProductPage.pageName,
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(
            FocusNode(),
          );
        },
        behavior: HitTestBehavior.translucent,
        child: Consumer<ProductPageViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: primaryColor.withOpacity(0.1),
                  margin: EdgeInsets.symmetric(
                    vertical: mainPadding / 2,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelText: 'Search',
                                  prefixIcon: const Icon(Icons.search),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 8.0),
                                ),
                              ),
                            ),
                            // IconButton(
                            //   icon: const Icon(Icons.filter_alt_outlined),
                            //   onPressed: () {
                            //     _showFilterDialog();
                            //   },
                            // ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Center(
                            child: Text(
                              widget.categoryType,
                              style: primary15Bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                if (widget.children!.isNotEmpty)
                  SelectionTypeWidget(
                    children: widget.children,
                    initialSelected: selectedCategoryId,
                    onSelected: (selectedId) {
                      debugPrint(
                          "=============> Get id of product: $selectedId");
                      setState(() {
                        selectedCategoryId = selectedId;
                      });
                      final category = viewModel.findCategoryById(selectedId);
                      viewModel.filterByCategory(
                          category!.id == 0 ? null : category);
                    },
                  ),
                Expanded(
                  child: Column(
                    children: [
                      ListCondition(
                        viewModel: viewModel,
                        showedData: viewModel.filteredProducts,
                        onRefresh: () async {
                          _searchController.clear();
                          FocusScope.of(context).requestFocus(
                            FocusNode(),
                          );
                          await viewModel.fetchWebsiteCategories();
                          setState(() {
                            selectedCategoryId = 0;
                          });
                        },
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: viewModel.filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ItemProductWidget(
                              data: viewModel.filteredProducts[index],
                              categoryType: widget.categoryType,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
