import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';

// =============================== PRIOTIY
Widget selectImprovScope(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged,
        bool isReadOnly = false}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: 'Improvement Scope',
          isValidate: validate,
          readOnlyAndFilled: isReadOnly,
          enabled: !isReadOnly,
          selected: selected,
          items: viewModel.improvScope.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );
