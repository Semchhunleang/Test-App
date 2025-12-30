import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/orentation_helper.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/view_models/visual_board/visual_board_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/visual_board/widget/build_visual_board_kanban.dart';
import 'package:umgkh_mobile/views/pages/cms/visual_board/widget/build_visual_board_list.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class VisualBoardPage extends StatefulWidget {
  static const routeName = '/visual-board';
  static const pageName = 'Visual Board';
  const VisualBoardPage({super.key});

  @override
  State<VisualBoardPage> createState() => _VisualBoardPageState();
}

class _VisualBoardPageState extends State<VisualBoardPage> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<VisualBoardViewModel>(context, listen: false);
    final vm2 = Provider.of<SelectionsViewModel>(context, listen: false);
    vm.resetBool();
    vm.resetData();
    vm.fetchStage();
    vm.fetchData(isRefresh: false).then((v) => vm.defaultFilter(context));
    vm2.fetchAllEmployee();
  }

  @override
  Widget build(BuildContext context) => Consumer3<VisualBoardViewModel,
          ProfileViewModel, SelectionsViewModel>(
      builder: (context, viewModel, userVM, selectedVM, _) => CustomScaffold(
          title: VisualBoardPage.pageName,
          action: [
            // HIDE SEARCH - FILTER
            IconButton(
                icon: Icon(
                    viewModel.isShowSearch
                        ? Icons.search_off_rounded
                        : Icons.search_rounded,
                    color: primaryColor,
                    size: 25),
                tooltip: 'Hide Filtering',
                onPressed: viewModel.onHidingSearch),
            // SWITCH ORENTATION
            if (viewModel.isKanban) ...[
              IconButton(
                  icon: Icon(Icons.refresh_rounded,
                      color: primaryColor, size: 25),
                  tooltip: 'Refresh Page',
                  onPressed: () async => await viewModel.fetchData()),
              IconButton(
                  icon: Icon(Icons.screen_rotation_rounded,
                      color: primaryColor, size: 22),
                  tooltip: OrientationHelper.isPortrait(context)
                      ? 'View as Portrait'
                      : 'View as Landscape',
                  onPressed: () => OrientationHelper.isPortrait(context)
                      ? OrientationHelper.landscape()
                      : OrientationHelper.portrait())
            ],

            // SWITCH VIEW
            IconButton(
                icon: Icon(
                    viewModel.isKanban
                        ? Icons.grid_view_rounded
                        : Icons.view_list_rounded,
                    color: primaryColor,
                    size: 25),
                tooltip: viewModel.isKanban ? 'View as Kanban' : 'View as List',
                onPressed: viewModel.onKanbanView),
          ],
          body: Column(
            children: [
              // SEARCH - FILTER
              if (viewModel.isShowSearch) ...[
                Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: primaryColor.withOpacity(0.1),
                    margin: EdgeInsets.symmetric(
                        horizontal: mainPadding, vertical: mainPadding / 2),
                    child: Padding(
                        padding: EdgeInsets.all(mainPadding),
                        child: Column(children: [
                          SearchTextfield(
                              ctrl: viewModel.searchCtrl,
                              onChanged: viewModel.onSearchChanged),
                          heith10Space,
                          CustomMultiDropList(
                              hint: 'Filter Assignees',
                              selected: viewModel.selectUser,
                              items: selectedVM.employees
                                  .where((e) =>
                                      e.department?.id ==
                                          userVM.user.department?.id &&
                                      !viewModel.selectUser.any(
                                          (selected) => selected.id == e.id))
                                  .toList(),
                              itemAsString: (i) => i.name,
                              onChanged: viewModel.onChangedUser,
                              onRemove: viewModel.onRemovedUser)
                        ])))
              ],

              viewModel.isKanban
                  ? const Expanded(child: BuildVisualBoardKanbanView())
                  : const BuildVisualBoardListView(),
            ],
          )));
}
