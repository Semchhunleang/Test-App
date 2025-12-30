import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/home_view_model.dart';
import 'package:umgkh_mobile/views/screens/home/widgets/button_menu.dart';

class ListMenuWidget extends StatefulWidget {
  const ListMenuWidget({super.key});

  @override
  State<ListMenuWidget> createState() => _ListMenuWidgetState();
}

class _ListMenuWidgetState extends State<ListMenuWidget> {
  @override
  Widget build(BuildContext context) => Consumer<HomeViewModel>(
        builder: (context, viewModel, _) => ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: mainPadding / 2),
          itemCount: viewModel.menuItems.length,
          itemBuilder: (context, i) => ItemListMenu(
            data: viewModel.menuItems[i],
            isLastIndex: i == viewModel.menuItems.length - 1,
            imgColor: null,
          ),
        ),
      );
}
