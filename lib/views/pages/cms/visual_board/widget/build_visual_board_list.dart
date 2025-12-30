import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/view_models/visual_board/visual_board_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/visual_board/widget/item_visual_board_widget.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';

class BuildVisualBoardListView extends StatelessWidget {
  const BuildVisualBoardListView({super.key});

  @override
  Widget build(BuildContext context) =>
      Consumer3<VisualBoardViewModel, ProfileViewModel, SelectionsViewModel>(
          builder: (context, viewModel, userVM, selectedVM, _) => ListCondition(
              viewModel: viewModel,
              showedData: viewModel.showedData,
              onRefresh: () => viewModel.fetchData(),
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: mainPadding, vertical: mainPadding / 2),
                  itemCount: viewModel.showedData.length,
                  itemBuilder: (context, i) => ItemVisualBoardAsListWidget(
                      data: viewModel.showedData[i]))));
}
