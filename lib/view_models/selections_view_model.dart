import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/am/vehicle_check/fleet_vehicle.dart';
import 'package:umgkh_mobile/models/base/data/static_selection.dart';
import 'package:umgkh_mobile/models/base/user/department.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/cms/a4/selection/selection.dart';
import 'package:umgkh_mobile/models/cms/document_number.dart';
import 'package:umgkh_mobile/models/crm/activity/activity_type.dart';
import 'package:umgkh_mobile/models/crm/country/country.dart';
import 'package:umgkh_mobile/models/crm/stage/crm_stages.dart';
import 'package:umgkh_mobile/models/crm/customer/customer.dart';
import 'package:umgkh_mobile/models/crm/team/sale_team.dart';
import 'package:umgkh_mobile/models/supporthub/ict/ict_device.dart';
import 'package:umgkh_mobile/models/supporthub/ict/ict_request_category.dart';
import 'package:umgkh_mobile/models/service-project_task/fs_action/fs_action.dart';
import 'package:umgkh_mobile/models/service-project_task/phenomenon/phenomenon.dart';
import 'package:umgkh_mobile/models/service-project_task/stage/stage.dart';
import 'package:umgkh_mobile/models/service-project_task/system_component/system_component.dart';
import 'package:umgkh_mobile/models/supporthub/marketing/marketing_product_type.dart';
import 'package:umgkh_mobile/models/umg/umg_social_media.dart';
import 'package:umgkh_mobile/services/api/crm/selection/selections_service.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';
import '../models/crm/country_state/country_state.dart';

class SelectionsViewModel extends ChangeNotifier {
  List<Customer> _customer = [];
  List<Customer> _customerAllData = [];
  List<CountryState> _state = [];
  List<Country> _country = [];
  List<SaleTeam> _saleTeam = [];
  List<ActivityType> _activityType = [];
  List<Stage> _fieldServiceStage = [];
  List<CrmStages> _stages = [];
  List<User> _employees = [];
  // List<User> _employeesFS = [];
  List<FleetVehicle> _fleetVehicle = [];
  List<StaticSelection> _jalStatus = [];
  List<StaticSelection> _customerSatisfied = [];
  List<StaticSelection> _serviceJobPoint = [];
  List<StaticSelection> _supportHubState = [];
  List<StaticSelection> _supportHubPriority = [];
  List<StaticSelection> _contactType = [];
  List<SystemComponent> _systemComponent = [];
  List<Phenomenon> _fsPhenomenon = [];
  List<FsAction> _fsAction = [];
  List<UMGSocialMedia> _umgSocialMedia = [];
  List<ICTRequestCategory> _ictRequestCategory = [];
  List<ICTDevices> _ictDevice = [];
  List<StaticSelection> _dispatchFrom = [];
  List<StaticSelection> _arriveAt = [];
  List<StaticSelection> _scheduleTruckDriverState = [];
  List<StaticSelection> _scheduleTruckDriverTag = [];

  List<Customer> get customer => _customer;
  List<Customer> get customerAllData => _customerAllData;
  List<CountryState> get state => _state;
  List<Country> get country => _country;
  List<SaleTeam> get saleTeam => _saleTeam;
  List<ActivityType> get activityType => _activityType;
  List<Stage> get fieldServiceStage => _fieldServiceStage;
  List<CrmStages> get stages => _stages;
  List<User> get employees => _employees;
  // List<User> get employeesFS => _employeesFS;
  List<FleetVehicle> get fleetVehicle => _fleetVehicle;
  List<StaticSelection> get jalStatus => _jalStatus;
  List<StaticSelection> get customerSatisfied => _customerSatisfied;
  List<StaticSelection> get serviceJobPoint => _serviceJobPoint;
  List<StaticSelection> get supportHubState => _supportHubState;
  List<StaticSelection> get supportHubPriority => _supportHubPriority;
  List<StaticSelection> get contactType => _contactType;
  List<SystemComponent> get systemComponent => _systemComponent;
  List<Phenomenon> get fsPhenomenon => _fsPhenomenon;
  List<FsAction> get fsAction => _fsAction;
  List<UMGSocialMedia> get umgSocialMedia => _umgSocialMedia;
  List<ICTRequestCategory> get ictRequestCategory => _ictRequestCategory;
  List<ICTDevices> get ictDevice => _ictDevice;

  //CMS
  List<Selection> _isoOjective1 = [];
  List<Selection> get isoOjective1 => _isoOjective1;
  List<Selection> _isoOjective2 = [];
  List<Selection> get isoOjective2 => _isoOjective2;
  List<Selection> _sheetProblem = [];
  List<Selection> get sheetProblem => _sheetProblem;
  List<StaticSelection> _improvScope = [];
  List<StaticSelection> get improvScope => _improvScope;
  DocumentNumber? _documentNumber;
  DocumentNumber? get documentNumber => _documentNumber;
  List<Selection> _productBrand = [];
  List<Selection> get productBrand => _productBrand;
  List<Selection> _tsbProductCateg = [];
  List<Selection> get tsbProductCateg => _tsbProductCateg;
  List<Selection> _engineModel = [];
  List<Selection> get engineModel => _engineModel;
  List<Selection> _componentGroup = [];
  List<Selection> get componentGroup => _componentGroup;
  List<Selection> _productModel = [];
  List<Selection> get productModel => _productModel;
  List<Selection> _stockProductionLot = [];
  List<Selection> get stockProductionLot => _stockProductionLot;
  List<StaticSelection> _typePart = [];
  List<StaticSelection> get typePart => _typePart;
  List<Selection> _product = [];
  List<Selection> get product => _product;
  List<Department> _department = [];
  List<Department> get department => _department;
  List<StaticSelection> get dispatchFrom => _dispatchFrom;
  List<StaticSelection> get arriveAt => _arriveAt;
  List<StaticSelection> get scheduleTruckDriverState =>
      _scheduleTruckDriverState;
  List<StaticSelection> get scheduleTruckDriverTag => _scheduleTruckDriverTag;

  //Marketing Ticket
  List<MarketingProductType> _marketingProductType = [];
  List<MarketingProductType> get marketingProductType => _marketingProductType;

  Map<String, String> priorities = {
    "0": "Low",
    "1": "Medium",
    "2": "High",
    "3": "Very High"
  };
  Map<String, String> transportationType = {
    "car": "Car",
    "truck": "Truck",
    "motocycle": "Motocycle"
  };
  Map<String, String> statusSmallPaper = {
    "all": "All",
    "draft": "Draft",
    "submit": "Submit",
    "approve": "Approve",
    "done": "Done",
    "reject": "Reject",
  };
  Map<String, String> people = {
    "all": "All",
    "requestor": "Requestor",
    "approver": "Approver"
  };
  Map<String, String> statusVehicleCheck = {
    "all": "All",
    "draft": "Draft",
    "submit": "Submit",
    "confirm": "Confirm",
    "approve": "Approve",
    "on_progress": "On Progress",
    "done": "Done",
    "reject": "Reject",
  };
  Map<String, String> peopleVehicleCheck = {
    "all": "All",
    "requestor": "Requestor",
    "checker": "Checker",
    "approver": "Approver",
  };

  Map<String, String> checkType = {
    "inout": "In Out",
    "check": "Check",
    "borrow": "Borrow",
    "audit": "Audit",
  };
  Map<String, String> statusLeaveApproval = {
    "all": "All",
    // "draft": "To Submit",
    "confirm": "To Approve",
    "refuse": "Refused",
    "validate1": "Second Approval",
    "validate": "Approved",
  };

  Map<String, String> monthSelection = {
    "01": "January",
    "02": "February",
    "03": "March",
    "04": "April",
    "05": "May",
    "06": "June",
    "07": "July",
    "08": "August",
    "09": "September",
    "10": "October",
    "11": "November",
    "12": "December",
  };

  Map<String, String> groupByMonthYear = {
    "year": "Year",
    "month": "Month",
  };

  // Build reverse map: "January" -> "01"
  Map<String, String> reverseMonthSelection() =>
      monthSelection.map((key, value) => MapEntry(value, key));

  Map<String, String> yearSelection = {
    for (int year = 2022; year <= DateTime.now().year + 99; year++)
      year.toString(): year.toString(),
  };

  Future<void> fetchCustomer() async {
    final response = await SelectionsAPIService().fetchCustomer();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _customer = response.data!;
      _customerAllData = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchState(int id) async {
    final response = await SelectionsAPIService().fetchCountryState(id);
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _state = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchCountry() async {
    final response = await SelectionsAPIService().fetchCountry();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _country = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchSaleTeam() async {
    final response = await SelectionsAPIService().fetchSaleTeam();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _saleTeam = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchActType() async {
    final response = await SelectionsAPIService().fetchActivityType();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _activityType = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchStages() async {
    final response = await SelectionsAPIService().fetchCrmStage();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _stages = response.data!;
      debugPrint("_success fetch stage: ${response.error}");
    }
    notifyListeners();
  }

  Future<void> fetchAllEmployee() async {
    final response = await SelectionsAPIService().fetchAllEmployee();
    if (response.error != null) {
    } else if (response.data != null) {
      _employees = response.data!;
      debugPrint("_success fetch employee: ");
    }
    notifyListeners();
  }

  Future<void> fetchFleetVehicle() async {
    final response = await SelectionsAPIService().fetchFleetVehicle();
    if (response.error != null) {
    } else if (response.data != null) {
      _fleetVehicle = response.data!;
      debugPrint("_success fetch fleet vehicle: ");
    }
    notifyListeners();
  }

  Future<void> fetchServiceStage(context) async {
    final response = await SelectionsAPIService().fetchServiceStage();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _fieldServiceStage = response.data ?? [];
      var closeStage = response.data?.where((e) => e.name == 'Close').toList();
      if (closeStage!.isNotEmpty) {
        Provider.of<FieldServiceViewModel>(context, listen: false)
            .onChangeExcludeStageByParam(closeStage[0]);
      }
    }
    notifyListeners();
  }

  Future<void> fetchSystemComponent() async {
    final response = await SelectionsAPIService().fetchSystemComponent();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _systemComponent = response.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchFSPhenomenon() async {
    final response = await SelectionsAPIService().fetchFSPhenomenon();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _fsPhenomenon = response.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchFSAction() async {
    final response = await SelectionsAPIService().fetchFSAction();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _fsAction = response.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchJobAssignLineStatus() async {
    final response = await SelectionsAPIService().fetchJobAssignLineStatus();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _jalStatus = response.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchCustomerSatisfied() async {
    final response = await SelectionsAPIService().fetchCustomerSatisfied();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _customerSatisfied = response.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchServiceJobPoint() async {
    final response = await SelectionsAPIService().fetchServiceJobPoint();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _serviceJobPoint = response.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchUMGSocialMedia() async {
    final response = await SelectionsAPIService().fetchUMGSocialMedia();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _umgSocialMedia = response.data ?? [];
    }
    notifyListeners();
  }

  //CMS
  Future<void> fetchIsoOjective1() async {
    final response = await SelectionsAPIService().fetchIsoOjective1();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _isoOjective1 = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchSupportHubState() async {
    final response = await SelectionsAPIService().fetchSupportHubState();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _supportHubState = response.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchIsoOjective2() async {
    final response = await SelectionsAPIService().fetchIsoOjective2();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _isoOjective2 = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchSupportHubPriority() async {
    final response = await SelectionsAPIService().fetchSupportHubPriority();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _supportHubPriority = response.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchSheetProblem() async {
    final response = await SelectionsAPIService().fetchSheetProblem();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _sheetProblem = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchContactType() async {
    final response = await SelectionsAPIService().fetchContactType();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _contactType = response.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchImprovScope() async {
    final response = await SelectionsAPIService().fetchImprovScope();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _improvScope = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchSupportHubICTRequestCategory() async {
    final response =
        await SelectionsAPIService().fetchSupportHubICTRequestCategory();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _ictRequestCategory = response.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchDocumentNumber(String type) async {
    final response = await SelectionsAPIService().fetchDocumentNumber(type);
    if (response.error != null) {
      debugPrint("_errorMessage doc: ${response.error}");
    } else if (response.data != null) {
      _documentNumber = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchProductBrand() async {
    final response = await SelectionsAPIService().fetchProductBrand();
    if (response.error != null) {
    } else if (response.data != null) {
      _productBrand = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchTsbProductCateg() async {
    final response = await SelectionsAPIService().fetchTsbProductCateg();
    if (response.error != null) {
    } else if (response.data != null) {
      _tsbProductCateg = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchEngineModel() async {
    final response = await SelectionsAPIService().fetchEngineModel();
    if (response.error != null) {
    } else if (response.data != null) {
      _engineModel = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchComponentGroup() async {
    final response = await SelectionsAPIService().fetchComponentGroup();
    if (response.error != null) {
    } else if (response.data != null) {
      _componentGroup = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchProductModel() async {
    final response = await SelectionsAPIService().fetchProductModel();
    if (response.error != null) {
    } else if (response.data != null) {
      _productModel = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchStockProductionLot() async {
    final response = await SelectionsAPIService().fetchStockProductionLot();
    if (response.error != null) {
    } else if (response.data != null) {
      _stockProductionLot = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchTypePartTsb() async {
    final response = await SelectionsAPIService().fetchTypePart();
    if (response.error != null) {
    } else if (response.data != null) {
      _typePart = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchProduct() async {
    final response = await SelectionsAPIService().fetchProduct();
    if (response.error != null) {
    } else if (response.data != null) {
      _product = response.data!;
    }
    notifyListeners();
  }

  Future<void> fetchSupportHubICTDevices() async {
    final response = await SelectionsAPIService().fetchSupportHubICTDevices();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _ictDevice = response.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchDepartment() async {
    final response = await SelectionsAPIService().fetchDepartment();
    if (response.error != null) {
      debugPrint("_errorMessage department: ${response.error}");
    } else if (response.data != null) {
      _department = response.data ?? [];
      // debugPrint("fetchDepartment department: ${_department[0].name}");
    }
    notifyListeners();
  }

  Future<void> fetchDispatchFrom() async {
    final response = await SelectionsAPIService().fetchDispatchFrom();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _dispatchFrom = response.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchArriveAt() async {
    final response = await SelectionsAPIService().fetchArriveAt();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _arriveAt = response.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchScheduleTruckDriverState() async {
    final response =
        await SelectionsAPIService().fetchScheduleTruckDriverState();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _scheduleTruckDriverState = response.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchScheduleTruckDriverTag() async {
    final response = await SelectionsAPIService().fetchScheduleTruckDriverTag();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _scheduleTruckDriverTag = response.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchSupportHubMarketingProductType() async {
    final response =
        await SelectionsAPIService().fetchSupportHubMarketingProductType();
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      _marketingProductType = response.data ?? [];
    }
    notifyListeners();
  }
}
