import 'package:flutter/material.dart';

class DateTimeField extends StatelessWidget {
  final String label;
  final bool readOnly;
  final DateTime? initialValue;
  final Function(DateTime)? onChanged;

  const DateTimeField({super.key, 
    required this.label,
    this.readOnly = false,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text:
          initialValue != null ? initialValue!.toString().split('.').first : '',
    );

    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: !readOnly
            ? const Icon(Icons.calendar_today)
            : const Icon(Icons.lock_outline),
      ),
      onTap: readOnly
          ? null
          : () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: initialValue ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null && onChanged != null) {
                onChanged!(picked);
              }
            },
    );
  }
}
