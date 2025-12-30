import 'package:flutter/material.dart';

import '../../../../../utils/theme.dart';

class TextFieldNoBorderWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? errorText;
  final void Function(String?)? onChanged;
  final bool readOnly;
  const TextFieldNoBorderWidget(
      {super.key,
      this.controller,
      this.label,
      this.onChanged,
      this.errorText,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (readOnly) {
          FocusScope.of(context).unfocus();
        }
      },
      child: AbsorbPointer(
        absorbing: readOnly,
        child: TextFormField(
            controller: controller,
            style: titleStyle13,
            readOnly: readOnly,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: titleStyle15,
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              errorText: errorText,
            ),
            onChanged: onChanged),
      ),
    );
  }
}
