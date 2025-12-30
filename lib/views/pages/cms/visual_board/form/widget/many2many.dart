import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/user/department.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class Many2ManyField extends StatelessWidget {
  final String label;
  final List<User> items;
  final List<Department>? itemDept;
  final List<String> selectedItems;

  const Many2ManyField({
    super.key,
    required this.label,
    required this.items,
    this.itemDept,
    required this.selectedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        // ==================== DEPARTMENT ====================
        itemDept != null
            ? Wrap(
                spacing: 6,
                runSpacing: -8,
                children: itemDept!
                    .map(
                      (item) => FilterChip(
                        label: Text(item.name),
                        labelStyle: TextStyle(color: primaryColor),
                        selected: selectedItems.contains(item),
                        onSelected: (_) {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust border radius as needed
                          side: BorderSide(
                            color:
                                primaryColor, // Set your desired border color here
                            width: 1.0, // Adjust border width as needed
                          ),
                        ),
                      ),
                    )
                    .toList(),
              )
            // ==================== USER ====================
            : Wrap(
                spacing: 6,
                runSpacing: -8,
                children: items
                    .map(
                      (item) => FilterChip(
                        label: Text(item.name),
                        labelStyle: TextStyle(color: primaryColor),
                        selected: selectedItems.contains(item),
                        onSelected: (_) {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust border radius as needed
                          side: BorderSide(
                            color:
                                primaryColor, // Set your desired border color here
                            width: 1.0, // Adjust border width as needed
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ],
    );
  }
}
