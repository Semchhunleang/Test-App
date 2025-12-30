import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/e-catalog/website_category/website_category.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/e_catalog_view_model.dart';
import 'package:umgkh_mobile/views/pages/e-catalog/widget/item_sub_category_widget.dart';

class SubCategoryPage extends StatefulWidget {
  static const routeName = '/sub-category';
  static const pageName = 'Sub Category';
  final List<WebsiteCategory> children;

  const SubCategoryPage({Key? key, required this.children}) : super(key: key);

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  List<WebsiteCategory> filteredChildren = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredChildren = widget.children;
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredChildren = widget.children;
      });
    } else {
      setState(() {
        filteredChildren = widget.children
            .where(
                (cat) => cat.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> fetchData() async {
    if (mounted) {
      FocusScope.of(context).requestFocus(
        FocusNode(),
      );
      await Provider.of<ECatalogViewModel>(context, listen: false)
          .fetchWebsiteCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SubCategoryPage.pageName,
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(
            FocusNode(),
          );
        },
        behavior: HitTestBehavior.translucent,
        child: Consumer<ECatalogViewModel>(
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
                    child: TextField(
                      controller: searchController,
                      onChanged: filterSearchResults,
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
                ),
                Expanded(
                  child: Consumer<ECatalogViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (viewModel.apiResponse.statusCode != 200) {
                        return Center(
                          child: Text(
                            viewModel.apiResponse.error ?? 'Unknown error',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else if (viewModel.filteredWebsiteCategories.isEmpty) {
                        return const Center(
                          child: Text('No data available'),
                        );
                      } else {
                        return RefreshIndicator(
                          onRefresh: fetchData,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: filteredChildren.length,
                            itemBuilder: (context, index) {
                              return ItemSubWebsiteCategoryWidget(
                                data: filteredChildren[index],
                              );
                            },
                          ),
                        );
                      }
                    },
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
    searchController.dispose();
    super.dispose();
  }
}
