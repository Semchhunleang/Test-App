import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/e-catalog/website_category/website_category.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/product_view_model.dart';

class CategoryTile extends StatefulWidget {
  final WebsiteCategory category;
  final int level;
  final WebsiteCategory? selectedCategory;

  const CategoryTile({
    Key? key,
    required this.category,
    required this.level,
    this.selectedCategory,
  }) : super(key: key);

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.selectedCategory != null &&
        widget.selectedCategory!.id == widget.category.id;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductPageViewModel>(builder: (context, viewModel, child) {
      return Padding(
        padding: EdgeInsets.only(left: widget.level * 16.0),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                viewModel.setSelectedCategory(widget.category);
              },
              selectedColor: whiteColor,
              selectedTileColor: primaryColor,
              selected: widget.selectedCategory!.id == widget.category.id,
              title: Text(
                widget.category.name,
                style: widget.selectedCategory!.id == widget.category.id
                    ? white12Bold
                    : primary12Bold,
              ),
              trailing: widget.category.children == null ||
                      widget.category.children!.isEmpty
                  ? null // No icon if there are no children
                  : IconButton(
                      icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                      ),
                      color: widget.selectedCategory!.id == widget.category.id
                          ? whiteColor
                          : primaryColor,
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    ),
            ),
            if (_isExpanded) // Only show children when expanded
              ...?widget.category.children?.map((subCategory) {
                return CategoryTile(
                  category: subCategory,
                  level: widget.level + 1,
                  selectedCategory:
                      widget.selectedCategory, // Pass selectedCategory down
                );
              }).toList(),
          ],
        ),
      );
    });
  }
}
