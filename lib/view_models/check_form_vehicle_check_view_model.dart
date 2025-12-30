import 'package:flutter/material.dart';

import '../models/am/vehicle_check/row.dart';
import '../models/am/vehicle_check/row_inout.dart';
import '../services/api/am/vehicle_check/vehicle_check_service.dart';
import '../utils/show_dialog.dart';

class CheckFormVehicleCheckViewModel extends ChangeNotifier {
  List<String?> _selectedCheckValues = [];
  List<String?> get selectedCheckValues => _selectedCheckValues;
  List<TextEditingController> remarkControllers = [];
  List<int> _rowIds = [];
  List<int> get rowIds => _rowIds;
  List<int> _rowIdsLocal = [];
  List<int> get rowIdsLocal => _rowIdsLocal;

  List<String?> _selectedCheckValuesIn = [];
  List<String?> get selectedCheckValuesIn => _selectedCheckValuesIn;
  List<TextEditingController> remarkInControllers = [];
  List<int> _rowIdsInout = [];
  List<int> get rowIdsInout => _rowIdsInout;
  List<int> _rowIdsLocalInout = [];
  List<int> get rowIdsLocalInout => _rowIdsLocalInout;

  List<String?> _selectedCheckValuesOut = [];
  List<String?> get selectedCheckValuesOut => _selectedCheckValuesOut;
  List<TextEditingController> remarkOutControllers = [];
  bool notCompletedForm = false;
  bool notCompletedFormIn = false;
  bool notCompletedFormOut = false;

  bool isDisableSelection = false;

  bool _isInitialized = false;
  bool _isInitializedInout = false;
  bool isSubmitted = false;

  set rowIds(List<int> value) {
    _rowIds = value;
    notifyListeners();
  }

  set rowIdsInout(List<int> value) {
    _rowIdsInout = value;
    notifyListeners();
  }

  void initializeCheckValues(List<Rows> rows) {
    if (_isInitialized) return;

    rows.sort((a, b) => (a.sequence ?? 0).compareTo(b.sequence ?? 0),);

    _selectedCheckValues = List.generate(
      rows.length,
      (index) => _getSelectedCheckValue(rows[index]),
    );

    _rowIdsLocal = List.generate(
      rows.length,
      (index) => rows[index].id!,
    );
    remarkControllers = List.generate(rows.length,
        (index) => TextEditingController(text: rows[index].remark ?? ''),);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    _isInitialized = true;
  }

  String? _getSelectedCheckValue(Rows data) {
    if (data.goodCheck == true) {
      return 'good';
    } else if (data.badCheck == true) {
      return 'bad';
    } else if (data.nonCheck == true) {
      return 'non';
    }
    return null;
  }

  void updateCheckValue(int index, String? value, int id) {
    if (index >= 0 &&
        index < _selectedCheckValues.length &&
        index < _rowIdsLocal.length) {
      _selectedCheckValues[index] = value;
      _rowIdsLocal[index] = id;
      notifyListeners();
    }
  }

  void clearState() {
    _selectedCheckValues.clear();
    remarkControllers.clear();
    _rowIds.clear();
    _rowIdsLocal.clear();
    _isInitialized = false;

    _selectedCheckValuesIn.clear();
    _selectedCheckValuesOut.clear();
    remarkInControllers.clear();
    remarkOutControllers.clear();
    _rowIdsInout.clear();
    _rowIdsLocalInout.clear();
    _isInitializedInout = false;
    notCompletedForm = false;
    isSubmitted = false;
    notCompletedFormIn = false;
    notCompletedFormOut = false;
    notifyListeners();
  }

  void initializeCheckValuesInout(List<RowInout> rowInout) {
    if (_isInitializedInout) return;
    rowInout.sort((a, b) => (a.sequence ?? 0).compareTo(b.sequence ?? 0),);
    _selectedCheckValuesIn = List.generate(
      rowInout.length,
      (index) => _getSelectedCheckValueIn(rowInout[index]),
    );
    _selectedCheckValuesOut = List.generate(
      rowInout.length,
      (index) => _getSelectedCheckValueOut(rowInout[index]),
    );
    _rowIdsLocalInout = List.generate(
      rowInout.length,
      (index) => rowInout[index].id!,
    );
    remarkInControllers = List.generate(
      rowInout.length,
      (index) => TextEditingController(text: rowInout[index].remarkIn ?? ''),
    );
    remarkOutControllers = List.generate(
      rowInout.length,
      (index) => TextEditingController(text: rowInout[index].remarkOut ?? ''),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    _isInitializedInout = true;
  }

  String? _getSelectedCheckValueIn(RowInout data) {
    if (data.goodCheckIn == true) {
      return 'goodIn';
    } else if (data.badCheckIn == true) {
      return 'badIn';
    } else if (data.nonCheckIn == true) {
      return 'nonIn';
    }
    return null;
  }

  String? _getSelectedCheckValueOut(RowInout data) {
    if (data.goodCheckOut == true) {
      return 'goodOut';
    } else if (data.badCheckOut == true) {
      return 'badOut';
    } else if (data.nonCheckOut == true) {
      return 'nonOut';
    }
    return null;
  }

  void updateCheckValueIn(int index, String? value, int id) {
    if (index >= 0 &&
        index < _selectedCheckValuesIn.length &&
        index < _rowIdsLocalInout.length) {
      _selectedCheckValuesIn[index] = value;
      _rowIdsLocalInout[index] = id;
      notifyListeners();
    }
  }

  void updateCheckValueOut(int index, String? value, int id) {
    if (index >= 0 &&
        index < _selectedCheckValuesOut.length &&
        index < _rowIdsLocalInout.length) {
      _selectedCheckValuesOut[index] = value;
      _rowIdsLocalInout[index] = id;
      notifyListeners();
    }
  }

  Map<String, dynamic> buildMap(int id) {
    return {
      'row': List.generate(_selectedCheckValues.length, (index) {
        return {
          'id': _rowIds[index],
          'good_check': _selectedCheckValues[index] == 'good',
          'bad_check': _selectedCheckValues[index] == 'bad',
          'non_check': _selectedCheckValues[index] == 'non',
          'remark': remarkControllers[index].text,
        };
      }),
    };
  }

  Map<String, dynamic> buildMapInout(int id) {
    return {
      'row': List.generate(
          _selectedCheckValuesIn.isNotEmpty
              ? _selectedCheckValuesIn.length
              : _selectedCheckValuesOut.length, (index) {
        return {
          'id': _rowIdsInout[index],
          'good_check_in': _selectedCheckValuesIn[index] == 'goodIn',
          'bad_check_in': _selectedCheckValuesIn[index] == 'badIn',
          'non_check_in': _selectedCheckValuesIn[index] == 'nonIn',
          'good_check_out': _selectedCheckValuesOut[index] == 'goodOut',
          'bad_check_out': _selectedCheckValuesOut[index] == 'badOut',
          'non_check_out': _selectedCheckValuesOut[index] == 'nonOut',
          'remark_in': remarkInControllers[index].text,
          'remark_out': remarkOutControllers[index].text,
        };
      }),
    };
  }

  Future<bool> updateRowsById(BuildContext context, int id) async {
    Map<String, dynamic> data = buildMap(id);
    try {
      final response = await VehicleCheckService().updateRowById(data, id);

      if (response.message != null && response.message!.contains('error')) {
        if (context.mounted) {
          showResultDialog(context, response.message!, isBackToList: false);
        }
        return false;
      } else {
        if (context.mounted) {
          showResultDialog(context, response.message!,
              isBackToList: true, isDone: true);
        }
        notifyListeners();
        return true;
      }
    } catch (e) {
      if (context.mounted) {
        showResultDialog(context, 'An error occurred while updating: $e',
            isBackToList: false);
      }
      return false;
    }
  }

  Future<bool> updateRowsByIdInout(BuildContext context, int id) async {
    Map<String, dynamic> data = buildMapInout(id);
    try {
      final response = await VehicleCheckService().updateRowInoutById(data, id);
      if (response.message != null && response.message!.contains('error')) {
        if (context.mounted) {
          showResultDialog(context, response.message!, isBackToList: false);
        }
        return false;
      } else {
        if (context.mounted) {
          showResultDialog(context, response.message!,
              isBackToList: true, isDone: true);
        }
        notifyListeners();
        return true;
      }
    } catch (e) {
      if (context.mounted) {
        showResultDialog(context, 'An error occurred while updating: $e',
            isBackToList: false);
      }
      return false;
    }
  }
}
