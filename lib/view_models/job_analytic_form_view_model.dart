import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/base/data/static_selection.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/service-project_task/fs_action/fs_action.dart';
import 'package:umgkh_mobile/models/service-project_task/phenomenon/phenomenon.dart';
import 'package:umgkh_mobile/models/service-project_task/system_component/system_component.dart';
import 'package:umgkh_mobile/services/api/field_service/fs_api_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';

class JobAnalytisFormViewModel extends ChangeNotifier {
  bool isSystem = false, isPhenomenon = false, isAction = false;
  bool isActionBy = false, isServicePoint = false, isNote = false;
  TextEditingController noteCtrl = TextEditingController();
  SystemComponent system =
      SystemComponent(id: 0, name: 'Select system component');
  Phenomenon phenomenon = Phenomenon(id: 0, name: 'Select phenomenon');
  FsAction action = FsAction(id: 0, name: 'Select action');
  User actionBy = User.defaultUser(id: 0, name: 'Select action by');
  List<User> selectActionBy = [];
  StaticSelection servicePoint =
      StaticSelection(id: 0, name: 'Selection service job point');
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onChangeSystem(dynamic v) =>
      notify(v, (val) => isSystem = (system = val).id == 0);

  onChangePhenomenon(dynamic v) =>
      notify(v, (val) => isPhenomenon = (phenomenon = val).id == 0);

  onChangeAction(dynamic v) =>
      notify(v, (val) => isAction = (action = val).id == 0);

  // onChangeActionBy(dynamic v) =>
  //     notify(v, (val) => isActionBy = (actionBy = val).id == 0);

  // onChangeActionBy(dynamic v) => notify(v, (val) => selectActionBy = val);
  onChangeActionBy(dynamic v) {
    notify(v, (val) {
      selectActionBy = val;
      isActionBy = val.isEmpty || (val.first.id == 0);
    });
  }

  onRemoveActionBy(User v) =>
      notify(v, (val) => selectActionBy = List.from(selectActionBy)..remove(v));

  onChangeServicePoint(dynamic v) =>
      notify(v, (val) => isServicePoint = (servicePoint = val).id == 0);

  onChangeNote(String v) => notify(v, (val) => isNote = trimStr(v).isEmpty);

  bool isValidated() {
    onChangeSystem(system);
    onChangePhenomenon(phenomenon);
    onChangeAction(action);
    onChangeActionBy(selectActionBy);
    onChangeServicePoint(servicePoint);
    onChangeNote(noteCtrl.text);
    return isServicePoint ||
        isNote ||
        isSystem ||
        isActionBy ||
        isAction ||
        isPhenomenon;
  }

  Future<void> insertData(BuildContext context, int id) async {
    _isLoading = true;
    try {
      Map<String, dynamic> data = {
        "job_analytic_project_id": id,
        "system": system.id,
        "phenomenon": phenomenon.id,
        "action": action.id,
        "actions_by": selectActionBy.map((e) => e.userId).toList(),
        "service_job_point": servicePoint.value,
        "note": noteCtrl.text
      };

      await FieldServiceAPIService().insertJobAnaylic(data).then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'));
        }
        if (!value.message!.contains('error')) {
          if (context.mounted) {
            final viewModelFS =
                Provider.of<FieldServiceViewModel>(context, listen: false);
            viewModelFS.onUpdateStageFieldService(id,
                data: viewModelFS.selectedData);
            viewModelFS.onUpdateStageFieldServiceLocal(id,
                data: viewModelFS.selectedData);
          }
        }
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  resetValidate() => isSystem =
      isPhenomenon = isAction = isActionBy = isServicePoint = isNote = false;

  resetForm() {
    _isLoading = false;
    system = SystemComponent(id: 0, name: 'Select system component');
    phenomenon = Phenomenon(id: 0, name: 'Select phenomenon');
    action = FsAction(id: 0, name: 'Select action');
    // actionBy = User.defaultUser(id: 0, name: 'Select action by');
    servicePoint = StaticSelection(id: 0, name: 'Selection service job point');
    noteCtrl.clear();
    selectActionBy = [];
  }
}
