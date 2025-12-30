import 'package:flutter/material.dart';
import 'package:flutter_boardview/board_item.dart';
import 'package:flutter_boardview/board_list.dart';
import 'package:flutter_boardview/boardview.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/visual_board/visual_board.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/orentation_helper.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/visual_board/visual_board_form_view_model.dart';
import 'package:umgkh_mobile/view_models/visual_board/visual_board_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/visual_board/form/index.dart';

class BuildVisualBoardKanbanView extends StatefulWidget {
  const BuildVisualBoardKanbanView({super.key});

  @override
  State<BuildVisualBoardKanbanView> createState() =>
      _BuildVisualBoardKanbanViewState();
}

class _BuildVisualBoardKanbanViewState
    extends State<BuildVisualBoardKanbanView> {
  @override
  void initState() {
    super.initState();
    OrientationHelper.portrait();
  }

  @override
  void dispose() {
    OrientationHelper.portrait();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer2<VisualBoardViewModel, VisualBoardFormViewModel>(
        builder: (context, listVM, formVM, _) => listVM.isLoading
            ? const Center(child: CircularProgressIndicator())
            : listVM.apiResponse.statusCode != 200
                ? Center(
                    child: Text(listVM.apiResponse.error ?? 'Unknown error',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                        textAlign: TextAlign.center))
                : listVM.showedData.isEmpty
                    ? const Center(child: Text('No data available'))
                    : BoardView(
                        // key: update vb count when filtering
                        key: ValueKey(listVM.showedData.length),
                        boardViewController: listVM.boardCtrl,
                        width: 250,
                        lists: listVM.listStage.map((stage) {
                          List<VisualBoard> listVBByStageID = listVM.showedData
                              .where((vb) => vb.stage.id == stage.id)
                              .toList()
                            ..sort((a, b) => a.sequence.compareTo(b.sequence));
                          return BoardList(
                            // key: update vb count when moving stage
                            key: ValueKey(listVBByStageID.length),
                            draggable: false,
                            headerBackgroundColor: greyColor.withOpacity(0.2),
                            backgroundColor: greyColor.withOpacity(0.1),
                            header: [
                              Padding(
                                padding: EdgeInsets.all(mainPadding),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Text(stage.name, style: primary15Bold),
                                    Positioned(
                                      top: -6,
                                      right: -18,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text('${listVBByStageID.length}',
                                            style: titleStyle10.copyWith(
                                                color: whiteColor)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            items: List.generate(
                              listVBByStageID.length,
                              (index) => BoardItem(
                                onDropItem: (
                                  newStageIndex,
                                  newVBIndex,
                                  oldStageIndex,
                                  oldVBIndex,
                                  state,
                                ) async {
                                  debugPrint(
                                      "Index------> $index \nstageID: From------> ${listVM.listStage[oldStageIndex!].name} To------> ${listVM.listStage[newStageIndex!].name}");
                                  // UPDATE VB STAGE
                                  if (newStageIndex != oldStageIndex) {
                                    // set data
                                    VisualBoard param = listVBByStageID[index];
                                    param.stage =
                                        listVM.listStage[newStageIndex];
                                    // update VB
                                    formVM.updateVisualBoard(param);
                                    await formVM
                                        .updateMovingVBKanbanStage(context);
                                    //await listVM.reFetchDataAfterChanged();
                                  }
                                  // SINGLE STAGE ==================================================
                                  if (newStageIndex == oldStageIndex) {
                                    debugPrint("SINGLE STAGE----------------");
                                    await formVM.updateSequenceVBInSingleStage(
                                      newVBIndex: newVBIndex ?? 0,
                                      newStageID:
                                          listVM.listStage[newStageIndex].id,
                                      movedItem: listVBByStageID[oldVBIndex!],
                                      vbByStage: listVBByStageID,
                                    );
                                  } else {
                                    // ACROSS STAGE ==================================================
                                    debugPrint("ACROSS STAGE----------------");
                                    // --> base on sequece acs
                                    // await formVM.updateSequenceVBInAcrossStage(
                                    //   newStageID:
                                    //       listVM.listStage[newStageIndex].id,
                                    //   showedData: listVM.showedData,
                                    // );

                                    // --> base on moving to sepecific index
                                    final movedItem =
                                        listVBByStageID[oldVBIndex!];
                                    // STEP 1: Remove moved item from showedData entirely
                                    final filteredData = listVM.showedData
                                        .where((vb) => vb.id != movedItem.id)
                                        .toList();

                                    // STEP 2: Prepare new stage list
                                    final newStageList = filteredData
                                        .where((vb) =>
                                            vb.stage.id ==
                                            listVM.listStage[newStageIndex].id)
                                        .toList();

                                    // STEP 3: Set new stage for moved item
                                    movedItem.stage =
                                        listVM.listStage[newStageIndex];

                                    // STEP 4: Insert at target index
                                    int insertIndex = newVBIndex!
                                        .clamp(0, newStageList.length);
                                    newStageList.insert(insertIndex, movedItem);

                                    // STEP 5: Update showedData in ViewModel (for UI)
                                    listVM.updateShowedData([
                                      ...filteredData.where((vb) =>
                                          vb.stage.id !=
                                          listVM.listStage[newStageIndex].id),
                                      ...newStageList,
                                    ]);

                                    // STEP 6: Update API sequence for new stage
                                    await formVM.updateSequenceVBInAcrossStage(
                                      newStageID:
                                          listVM.listStage[newStageIndex].id,
                                      newVBIndex: newVBIndex,
                                      movedItem: movedItem,
                                      showedData: listVM.showedData,
                                    );
                                    setState(() {}); // rebuild UI
                                  }
                                },
                                onTapItem: (stageIndex, vBIndex, state) async {
                                  // force form to portrait
                                  // OrientationHelper.portrait();
                                  // bool isPortrait =
                                  //     OrientationHelper.isPortrait(context);
                                  await navPush(
                                      context,
                                      VisualBoardFormPage(
                                          data: listVBByStageID[vBIndex!]));
                                  // return back current orentation
                                  // if (context.mounted) {
                                  //   isPortrait
                                  //       ? OrientationHelper.portrait()
                                  //       : OrientationHelper.landscape();
                                  // }
                                },
                                item: _itemWidget(listVBByStageID[index]),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
      );

  Widget _itemWidget(VisualBoard data) => Card(
        margin: EdgeInsets.all(mainPadding / 3),
        child: Padding(
          padding: EdgeInsets.all(mainPadding / 3),
          child: Column(
            children: [
              Text(
                data.name,
                style: primary13Bold,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              heith5Space,
              _userRowWidget(
                Icons.person_rounded,
                Colors.indigo,
                'Assignees',
                data.assignees.map((e) => e.name).toList(),
              ),
              if (data.requestors.isNotEmpty) ...[
                _userRowWidget(
                  Icons.person_add_rounded,
                  Colors.purpleAccent,
                  'Requestors',
                  data.requestors.map((e) => e.name).toList(),
                )
              ],
              _dateRowWidget(
                Icons.date_range_rounded,
                Colors.pink,
                'Assigned',
                data.assignedDT != null
                    ? formatDDMMYYYYHHMM(data.assignedDT!)
                    : '-',
              ),
              if (data.doneDT != null) ...[
                _dateRowWidget(
                  Icons.timer_outlined,
                  Colors.green,
                  'Done On',
                  data.doneDT != null ? formatDDMMYYYYHHMM(data.doneDT!) : '-',
                )
              ],
              if (data.dueDate != null) ...[
                _dateRowWidget(
                  Icons.hourglass_top_rounded,
                  Colors.redAccent,
                  'Due Date',
                  data.dueDate != null
                      ? formatDDMMYYYYHHMM(data.dueDate!)
                      : '-',
                )
              ],
              _dateRowWidget(
                Icons.perm_contact_calendar_rounded,
                Colors.teal,
                'Lead Day',
                data.leadDay.toString(),
              ),
              _dateRowWidget(
                Icons.warning_amber_rounded,
                Colors.amber,
                'OD Day',
                data.odDay.toString(),
              ),
            ],
          ),
        ),
      );

  Widget _userRowWidget(
          IconData icon, Color color, String title, List<String> value) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: color.withOpacity(0.7),
                ),
                Text(
                  ' $title: ',
                  style: titleStyle10.copyWith(color: greyColor),
                ),
              ],
            ),
            value.isNotEmpty
                ? Wrap(
                    runSpacing: -5,
                    spacing: -5,
                    children: value
                        .map(
                          (name) => Card(
                            elevation: 0.1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(mainRadius),
                            ),
                            color: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              child: Text(
                                name,
                                style: titleStyle10.copyWith(fontSize: 9),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
                : Text('   -   ', style: titleStyle10),
          ],
        ),
      );

  Widget _dateRowWidget(
          IconData icon, Color color, String title, String value) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 15,
              color: color.withOpacity(0.7),
            ),
            Text(
              ' $title: ',
              style: titleStyle10.copyWith(color: greyColor),
            ),
            Expanded(
              child: Text(value, style: titleStyle11),
            ),
          ],
        ),
      );
}
