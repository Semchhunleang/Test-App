import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/e_catalog_view_model.dart';
import 'package:umgkh_mobile/views/pages/e-catalog/widget/item_category_widget.dart';

class ECatalogPage extends StatefulWidget {
  static const routeName = '/e-catalog';
  static const pageName = 'E-Catalog';

  const ECatalogPage({Key? key}) : super(key: key);

  @override
  State<ECatalogPage> createState() => _ECatalogPageState();
}

class _ECatalogPageState extends State<ECatalogPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      Provider.of<ECatalogViewModel>(context, listen: false)
          .filterCategories(_searchController.text);
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchData(),
    );
  }

  Future<void> _fetchData() async {
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
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        await Provider.of<ECatalogViewModel>(context, listen: false)
            .setFilteredFromPrev();
      },
      // onPopInvoked: (didPop) async {
      //   await Provider.of<ECatalogViewModel>(context, listen: false)
      //       .setFilteredFromPrev();
      // },
      child: Scaffold(
        appBar: AppBar(
          title: Text(ECatalogPage.pageName,
              style: Theme.of(context).textTheme.titleLarge),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(
              FocusNode(),
            );
          },
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: primaryColor.withOpacity(0.1),
                margin: EdgeInsets.symmetric(
                  // horizontal: mainPadding,
                  vertical: mainPadding / 2,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Border radius
                      ),
                      labelText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0), // Adjust padding
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
                        onRefresh: _fetchData,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 columns
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.8, // Adjust the ratio as needed
                          ),
                          itemCount: viewModel.filteredWebsiteCategories.length,
                          itemBuilder: (context, index) {
                            return ItemWebsiteCategoryWidget(
                              data: viewModel.filteredWebsiteCategories[index],
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
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
