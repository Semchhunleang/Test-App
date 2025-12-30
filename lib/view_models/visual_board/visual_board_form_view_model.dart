import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/visual_board/stage.dart';
import 'package:umgkh_mobile/models/visual_board/visual_board.dart';
import 'package:umgkh_mobile/services/api/visual_board/visual_board_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';

class VisualBoardFormViewModel extends ChangeNotifier {
  VisualBoard _vb = VisualBoard(
    id: 0,
    sequence: 0,
    name: '',
    description: '',
    stage: VisualBoardStage(id: 0, name: '', sequence: 0),
    assignees: [], // These are now List<User>
    requestors: [], // These are now List<User>
  );
  bool _isLoading = false;

  VisualBoard get vb => _vb;
  bool get isLoading => _isLoading;

  // You'd also typically add a method to update the state
  void updateVisualBoard(VisualBoard newVb) {
    _isLoading = true;
    notifyListeners();
    _vb = newVb;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateVB(BuildContext context) async {
    print(_vb.toJson());
    _isLoading = true;
    notifyListeners();
    try {
      await VisualBoardAPIService().updateVB(_vb).then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'));
        }
        if (!value.message!.contains('error')) {
          if (context.mounted) {
            showResultDialog(context, '${value.message}',
                isBackToList: true, isDone: true);
            // Navigator.pop(context);
          }
        }
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('error : $e');
    }
  }

// START . PUTHEA
  Future<void> updateMovingVBKanbanStage(BuildContext context) async {
    try {
      await VisualBoardAPIService().updateVB(_vb).then((value) {
        if (value.error != null) {
          if (context.mounted) {
            showResultDialog(context, '${value.error}',
                isBackToList: true, isDone: true);
          }
        }
      });
    } catch (e) {
      debugPrint('error : $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateSequenceVBInSingleStage({
    required int newVBIndex,
    required int newStageID,
    required VisualBoard movedItem,
    required List<VisualBoard> vbByStage,
  }) async {
    try {
      List<VisualBoard> targetStageBoards =
          vbByStage.where((vb) => vb.id != movedItem.id).toList();
      int insertIndex = newVBIndex.clamp(0, targetStageBoards.length);
      targetStageBoards.insert(insertIndex, movedItem);
      for (int i = 0; i < targetStageBoards.length; i++) {
        targetStageBoards[i].sequence = i;
      }
      final body = targetStageBoards
          .map((vb) => {
                "id": vb.id,
                "stage_id": vb.stage.id,
                "sequence": vb.sequence,
              })
          .toList();
      debugPrint('body: $body');
      await VisualBoardAPIService().updateSequenceVB(body).then((response) {
        debugPrint('API response: ${response.message}');
      });
    } catch (e, s) {
      debugPrint("updateSequenceVBKanban() error: $e");
      debugPrint("Stack trace: $s");
    } finally {
      notifyListeners();
    }
  }

  // Future<void> _updateSequenceVBInAcrossStage({
  //   required int newStageID,
  //   required List<VisualBoard> showedData,
  // }) async {
  //   try {
  //     List<VisualBoard> acrossStageBoards = showedData
  //         .where((vb) => vb.stage.id == newStageID)
  //         .toList()
  //       ..sort((a, b) => a.sequence.compareTo(b.sequence));
  //     for (int i = 0; i < acrossStageBoards.length; i++) {
  //       acrossStageBoards[i].sequence = i;
  //     }
  //     final body = acrossStageBoards
  //         .map((vb) => {
  //               "id": vb.id,
  //               "stage_id": vb.stage.id,
  //               "sequence": vb.sequence,
  //             })
  //         .toList();
  //     debugPrint('body: $body');
  //     await VisualBoardAPIService().updateSequenceVB(body).then((response) {
  //       debugPrint('API response: ${response.message}');
  //     });
  //   } catch (e, s) {
  //     debugPrint("updateSequenceVBKanban() error: $e");
  //     debugPrint("Stack trace: $s");
  //   } finally {
  //     notifyListeners();
  //   }
  // }

  Future<void> updateSequenceVBInAcrossStage({
    required int newStageID,
    required int newVBIndex,
    required VisualBoard movedItem,
    required List<VisualBoard> showedData,
  }) async {
    try {
      // STEP 1: Get all items in the new stage
      List<VisualBoard> newStageBoards =
          showedData.where((vb) => vb.stage.id == newStageID).toList();

      // STEP 2: Remove moved item if somehow it exists in the new stage
      newStageBoards.removeWhere((vb) => vb.id == movedItem.id);

      // STEP 3: Set the new stage for the moved item
      movedItem.stage.id = newStageID;

      // STEP 4: Insert the moved item at the target index
      int insertIndex = newVBIndex.clamp(0, newStageBoards.length);
      newStageBoards.insert(insertIndex, movedItem);

      // STEP 5: Resequence only new stage
      for (int i = 0; i < newStageBoards.length; i++) {
        newStageBoards[i].sequence = i;
      }

      // STEP 6: Prepare API body (only new stage)
      final body = newStageBoards
          .map((vb) => {
                "id": vb.id,
                "stage_id": vb.stage.id,
                "sequence": vb.sequence,
              })
          .toList();

      debugPrint('updateSequenceVBInAcrossStage BODY: $body');

      await VisualBoardAPIService().updateSequenceVB(body).then((response) {
        debugPrint('API response: ${response.message}');
      });
    } catch (e, s) {
      debugPrint("updateSequenceVBInAcrossStage() error: $e");
      debugPrint("Stack trace: $s");
    } finally {
      notifyListeners();
    }
  }

// END . PUTHEA

  onChangeStage(VisualBoardStage v) {
    notify(v, (val) {
      // This assumes your updateVisualBoard method is available:
      print(v);
      updateField("stage", v);
    });
  }

  updateField<T>(String fieldName, T newValue) {
    bool updated = false;

    // Use a switch statement to assign the generic newValue to the correct field
    switch (fieldName) {
      case 'name':
        if (_vb.name != newValue) {
          _vb.name = newValue as String;
          updated = true;
        }
        break;
      case 'description':
        if (_vb.description != newValue) {
          _vb.description = newValue as String;
          updated = true;
        }
        break;
      case 'leadDay':
        if (_vb.leadDay != newValue) {
          _vb.leadDay = newValue as double?;
          updated = true;
        }
        break;
      case 'odDay':
        if (_vb.odDay != newValue) {
          _vb.odDay = newValue as double?;
          updated = true;
        }
        break;
      case 'stage':
        if (_vb.stage != newValue) {
          _vb.stage = newValue as VisualBoardStage;
          updated = true;
        }
        break;
      // Add cases for all other fields (assignedDT, doneDT, dueDate, stage, etc.)
      // Remember to handle casting for complex types (DateTime, VisualBoardStage, List<User>)

      default:
        // Handle unknown field name if necessary
        print('Warning: Unknown field $fieldName');
        return;
    }

    if (updated) {
      notifyListeners();
    }
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }
}
