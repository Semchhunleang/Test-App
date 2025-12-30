import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/view_models/tsb_view_model.dart';

import '../../../../../utils/theme.dart';
import '../../../../../widgets/textfield.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TsbViewModel>(builder: (context, provider, child) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: primaryColor.withOpacity(0.1),
        margin: EdgeInsets.symmetric(
            horizontal: mainPadding, vertical: mainPadding / 2),
        child: Padding(
          padding: EdgeInsets.all(mainPadding),
          child: Column(children: [
            SearchTextfield(
              ctrl: provider.searchController,
              onChanged: (value) {
                provider.search = value;
              },
              onEditing: () {
                FocusScope.of(context).unfocus();
              },
            ),
          ]),
        ),
      );
    });
  }
}
