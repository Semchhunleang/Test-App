import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/am/vehicle_check/vehicle_check.dart';
import 'package:umgkh_mobile/services/api/am/vehicle_check/vehicle_check_service.dart';

import '../models/base/custom_ui/api_response.dart';
import '../utils/utlis.dart';
import 'profile_view_model.dart';

class VehicleCheckViewModel extends ChangeNotifier {
  String selectedState = "all";
  String selectedPeople = "all";
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingDataById = false;
  bool get isLoadingDataById => _isLoadingDataById;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<VehicleCheck> _vehicleCheckDataList = [];
  List<VehicleCheck> _showedVehicleData = [];
  List<VehicleCheck> get showedVehicleData => _showedVehicleData;
  List<VehicleCheck> get vehicleCheckList => _vehicleCheckDataList;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse? get apiResponse => _apiResponse;
  final TextEditingController searchController = TextEditingController();
  String? _search;
  String? get search => _search;
  VehicleCheck? vehicleCheck = VehicleCheck();

  resetData() {
    _errorMessage = null;
    _showedVehicleData = [];
    _showedVehicleData = [];
    searchController.clear();
    _search = "";
    clearSelect();
  }

  clearFilterVehicleCheck(ProfileViewModel p) {
    clearSelect();
    _applyFilters(p);
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  Future<void> fetchAllVehicleCheck(ProfileViewModel p) async {
    _setLoading(true);
    final response = await VehicleCheckService().fetchAllVehicleCheck();
    _apiResponse = response;

    if (response.error != null) {
      _handleError(response.error!);
    } else if (response.data != null) {
      _vehicleCheckDataList = response.data!;

      _applyFilters(p);
    }

    _setLoading(false);
  }

  Future<VehicleCheck?> fetchVehicleCheckById(int id) async {
    _setLoadingDataById(true);

    try {
      final response = await VehicleCheckService().fetchVehicleCheckById(id);
      _apiResponse = response;

      notifyListeners();

      if (response.error == null && response.statusCode == 200) {
        vehicleCheck = response.data!;
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching vehicle check: $e');
      return null;
    } finally {
      _setLoadingDataById(false);
    }
  }

  void onStateChanged(String v, ProfileViewModel p) => notify(v, (val) {
        selectedState = val;
        _applyFilters(p);
      });

  void onPeopleChanged(String v, ProfileViewModel p) => notify(v, (val) {
        selectedPeople = val;
        _applyFilters(p);
      });

  set search(String? value) {
    _search = value;
    notifyListeners();
  }

  void updateSearch(String? value, ProfileViewModel p) {
    search = value;
    _applyFilters(p);
  }

  void _applyFilters(ProfileViewModel p) {
    List<VehicleCheck> filterData = vehicleCheckList;

    final searchText = _search?.toLowerCase() ?? '';
    String userId = p.user.id.toString();

    if (searchText.isNotEmpty) {
      filterData = filterData.where((vehicle) {
        final auditDatetime = vehicle.auditDatetime != null &&
            formatReadableDT(vehicle.auditDatetime!)
                .toString()
                .toLowerCase()
                .contains(searchText);

        final plannedInDatetime = vehicle.plannedDatetimeIn != null &&
            formatReadableDT(vehicle.plannedDatetimeIn!)
                .toString()
                .toLowerCase()
                .contains(searchText);

        final plannedOutDatetime = vehicle.plannedDatetimeOut != null &&
            formatReadableDT(vehicle.plannedDatetimeOut!)
                .toString()
                .toLowerCase()
                .contains(searchText);

        return auditDatetime || plannedInDatetime || plannedOutDatetime;
      }).toList();
    }

    if (selectedState != 'all') {
      filterData = filterData.where((e) => e.state == selectedState).toList();
    }

    if (selectedPeople != 'all') {
      filterData = filterData.where((e) {
        if (selectedPeople == 'requestor') {
          return e.requestor?.id.toString() == userId;
        } else if (selectedPeople == 'approver') {
          return e.approver?.id.toString() == userId;
        } else {
          return e.checker?.id.toString() == userId;
        }
      }).toList();
    }

    _showedVehicleData = filterData;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingDataById(bool loading) {
    _isLoadingDataById = loading;
    notifyListeners();
  }

  void _handleError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  clearSelect() {
    selectedState = "all";
    selectedPeople = "all";
    searchController.clear();
    _search = "";
  }
}
