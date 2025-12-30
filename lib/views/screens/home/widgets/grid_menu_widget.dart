import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/base/custom_ui/menu_item.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/home_view_model.dart';
import 'package:umgkh_mobile/views/screens/home/widgets/button_menu.dart';

class GridMenuWidget extends StatefulWidget {
  const GridMenuWidget({super.key});

  @override
  State<GridMenuWidget> createState() => _GridMenuWidgetState();
}

class _GridMenuWidgetState extends State<GridMenuWidget> {
  @override
  Widget build(BuildContext context) => Consumer<HomeViewModel>(
        builder: (context, viewModel, _) => GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: mainPadding / 2),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: mainPadding / 2,
              crossAxisSpacing: mainPadding / 2),
          itemCount: viewModel.menuItems.length,
          itemBuilder: (context, index) =>
              DragTarget<MenuItem>(onAcceptWithDetails: (details) {
            setState(() {
              final oldIndex = viewModel.menuItems
                  .indexWhere((element) => element.id == details.data.id);
              final temp = viewModel.menuItems[index];
              viewModel.menuItems[index] = details.data;
              viewModel.menuItems[oldIndex] = temp;

              // Update positions in the database
              viewModel.updateMenuItemPosition(
                  viewModel.menuItems[index].id, index);
              viewModel.updateMenuItemPosition(
                  viewModel.menuItems[oldIndex].id, oldIndex);
            });
          },
                  // onAccept: (data) {
                  //   setState(() {
                  //     final oldIndex = viewModel.menuItems
                  //         .indexWhere((element) => element.id == data.id);
                  //     final temp = viewModel.menuItems[index];
                  //     viewModel.menuItems[index] = data;
                  //     viewModel.menuItems[oldIndex] = temp;

                  //     // Update positions in the database
                  //     viewModel.updateMenuItemPosition(
                  //         viewModel.menuItems[index].id, index);
                  //     viewModel.updateMenuItemPosition(
                  //         viewModel.menuItems[oldIndex].id, oldIndex);
                  //   });
                  // },
                  builder: (context, candidateData, rejectedData) {
            return ItemGridMenu(
              data: viewModel.menuItems[index],
              imgColor:null,
            );
          }),
        ),
      );
}
