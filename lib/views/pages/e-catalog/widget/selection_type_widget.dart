import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/e-catalog/website_category/website_category.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class SelectionTypeWidget extends StatefulWidget {
  final void Function(int selected)? onSelected;
  final List<WebsiteCategory>? children;
  final int initialSelected;

  const SelectionTypeWidget(
      {super.key, this.onSelected, this.children, this.initialSelected = 0});

  @override
  State<SelectionTypeWidget> createState() => _SelectionTypeWidgetState();
}

class _SelectionTypeWidgetState extends State<SelectionTypeWidget> {
  late int selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelected;
  }

  @override
  void didUpdateWidget(covariant SelectionTypeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelected != oldWidget.initialSelected) {
      selected = widget.initialSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<WebsiteCategory> categories = [
      WebsiteCategory(
          id: 0,
          name: 'All',
          completeName: '',
          parentPath: '',
          sequence: 0,
          countProduct: 0,
          totalCountProduct: 0),
      ...(widget.children ?? []),
    ];

    return Wrap(
      spacing: 10,
      children: categories.map((category) {
        final isSelected = category.id == selected;
        return GestureDetector(
          onTap: () {
            setState(() {
              selected = category.id;
            });
            if (widget.onSelected != null) {
              widget.onSelected!(category.id);
            }
          },
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red : primaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  category.name,
                  style: white12Bold,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      }).toList(),
    );
  }
}
