import 'dart:async';
import 'dart:convert';
import 'package:umgkh_mobile/models/am/vehicle_check/fleet_vehicle.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/base/data/static_selection.dart';
import 'package:umgkh_mobile/models/base/user/department.dart';
import 'package:umgkh_mobile/models/cms/a4/selection/selection.dart';
import 'package:umgkh_mobile/models/cms/document_number.dart';
import 'package:umgkh_mobile/models/crm/activity/activity_type.dart';
import 'package:umgkh_mobile/models/crm/country/country.dart';
import 'package:umgkh_mobile/models/crm/team/sale_team.dart';
import 'package:umgkh_mobile/models/crm/customer/customer.dart';
import 'package:umgkh_mobile/models/supporthub/ict/ict_device.dart';
import 'package:umgkh_mobile/models/supporthub/ict/ict_request_category.dart';
import 'package:umgkh_mobile/models/service-project_task/fs_action/fs_action.dart';
import 'package:umgkh_mobile/models/service-project_task/phenomenon/phenomenon.dart';
import 'package:umgkh_mobile/models/service-project_task/stage/stage.dart';
import 'package:umgkh_mobile/models/service-project_task/system_component/system_component.dart';
import 'package:umgkh_mobile/models/supporthub/marketing/marketing_product_type.dart';
import 'package:umgkh_mobile/models/umg/umg_social_media.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/services/local_storage/models/project_task/project_task_local_storage_service.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../../models/base/user/user.dart';
import '../../../../models/crm/country_state/country_state.dart';
import '../../../../models/crm/stage/crm_stages.dart';
import '../../../../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/io_client.dart';

class SelectionsAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ProjectTaskLocalStorageService _projectTaskService =
      ProjectTaskLocalStorageService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<List<Country>>> fetchCountry() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getCountry),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<Country> data = (json.decode(response.body) as List)
            .map((json) => Country.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<CountryState>>> fetchCountryState(int id) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse('${Constants.getCountryState}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<CountryState> data = (json.decode(response.body) as List)
            .map((json) => CountryState.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<SaleTeam>>> fetchSaleTeam() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getSaleTeam),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<SaleTeam> data = (json.decode(response.body) as List)
            .map((json) => SaleTeam.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<Customer>>> fetchCustomer() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getCustomer),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<Customer> data = (json.decode(response.body) as List)
            .map((json) => Customer.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: 'Error fetching A4 data: $e', statusCode: 504);
    }
  }

  Future<ApiResponse<List<ActivityType>>> fetchActivityType() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getActivityType),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<ActivityType> data = (json.decode(response.body) as List)
            .map((json) => ActivityType.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: 'Error fetching A4 data: $e', statusCode: 504);
    }
  }

  Future<ApiResponse<List<CrmStages>>> fetchCrmStage() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getStages),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<CrmStages> data = (json.decode(response.body) as List)
            .map((json) => CrmStages.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: 'Error fetching A4 data: $e', statusCode: 504);
    }
  }

  Future<ApiResponse<List<User>>> fetchAllEmployee() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getAllEmployee),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<User> data = (json.decode(response.body) as List)
            .map((json) => User.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(
          error: 'Error fetching employee data: $e', statusCode: 504);
    }
  }

  Future<ApiResponse<List<FleetVehicle>>> fetchFleetVehicle() async {
    final token = await _tokenManager.getValidToken();

    try {
      if (token != 'server_unreachable') {
        final response = await ioClient.get(
          Uri.parse(Constants.getFleetVehicle),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
        );

        if (response.statusCode == 200) {
          final List<FleetVehicle> data = (json.decode(response.body) as List)
              .map((json) => FleetVehicle.fromJson(json))
              .toList();

          for (var element in data) {
            if (element.model != null) {
              await _projectTaskService.saveModel(element.model!);
              if (element.model!.brand != null) {
                await _projectTaskService.saveBrand(element.model!.brand!);
              }
            }
            await _projectTaskService.saveFleetVehicle(element);
          }
          return ApiResponse(data: data, statusCode: response.statusCode);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        List<FleetVehicle>? dataLocal =
            await _projectTaskService.getFleetVehicles();
        if (dataLocal != null && dataLocal.isNotEmpty) {
          return ApiResponse(data: dataLocal, statusCode: 200);
        } else {
          return ApiResponse(
              error: 'Local data is not available && Server is Unreachable',
              statusCode: 404);
        }
      }
    } on TimeoutException catch (_) {
      List<FleetVehicle>? dataLocal =
          await _projectTaskService.getFleetVehicles();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(error: 'Request timed out', statusCode: 408);
      }
    } catch (e) {
      List<FleetVehicle>? dataLocal =
          await _projectTaskService.getFleetVehicles();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(
            error: 'Error fetching fleet vehicle data: $e', statusCode: 504);
      }
    }
  }

  Future<ApiResponse<List<Stage>>> fetchServiceStage() async {
    final token = await _tokenManager.getValidToken();
    // _projectTaskService
    try {
      if (token != 'server_unreachable') {
        final response = await ioClient.get(
          Uri.parse(Constants.getServicesStage),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
        );

        if (response.statusCode == 200) {
          final List<Stage> data = (json.decode(response.body) as List)
              .map((json) => Stage.fromJson(json))
              .toList();
          return ApiResponse(data: data, statusCode: response.statusCode);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        List<Stage>? dataLocal = await _projectTaskService.getStages();
        if (dataLocal != null && dataLocal.isNotEmpty) {
          return ApiResponse(data: dataLocal, statusCode: 200);
        } else {
          return ApiResponse(
              error: 'Local data is not available && Server is Unreachable',
              statusCode: 404);
        }
      }
    } on TimeoutException catch (_) {
      List<Stage>? dataLocal = await _projectTaskService.getStages();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(error: 'Request timed out', statusCode: 408);
      }
    } catch (e) {
      List<Stage>? dataLocal = await _projectTaskService.getStages();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(
            error: 'Error fetching fleet vehicle data: $e', statusCode: 504);
      }
    }
  }

  Future<ApiResponse<List<SystemComponent>?>> fetchSystemComponent() async {
    final token = await _tokenManager.getValidToken();
    try {
      if (token != 'server_unreachable') {
        final response = await ioClient.get(
            Uri.parse(Constants.getSystemComponent),
            headers: {'Content-Type': 'application/json'});

        if (response.statusCode == 200) {
          final List<SystemComponent> data =
              (json.decode(response.body) as List)
                  .map((json) => SystemComponent.fromJson(json))
                  .toList();
          for (var element in data) {
            _projectTaskService.saveSystemComponent(element);
          }
          return ApiResponse(data: data, statusCode: response.statusCode);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        List<SystemComponent>? dataLocal =
            await _projectTaskService.getSystemComponents();
        if (dataLocal != null && dataLocal.isNotEmpty) {
          return ApiResponse(data: dataLocal, statusCode: 200);
        } else {
          return ApiResponse(
              error: 'Local data is not available && Server is Unreachable',
              statusCode: 404);
        }
      }
    } on TimeoutException catch (_) {
      List<SystemComponent>? dataLocal =
          await _projectTaskService.getSystemComponents();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(error: 'Request timed out', statusCode: 408);
      }
    } catch (e) {
      List<SystemComponent>? dataLocal =
          await _projectTaskService.getSystemComponents();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(
            error: 'Error fetching fleet vehicle data: $e', statusCode: 504);
      }
    }
  }

  Future<ApiResponse<List<Phenomenon>>> fetchFSPhenomenon() async {
    final token = await _tokenManager.getValidToken();
    try {
      if (token != 'server_unreachable') {
        final response = await ioClient.get(
            Uri.parse(Constants.getFSPhenomenon),
            headers: {'Content-Type': 'application/json'});

        if (response.statusCode == 200) {
          final List<Phenomenon> data = (json.decode(response.body) as List)
              .map((json) => Phenomenon.fromJson(json))
              .toList();

          for (var element in data) {
            _projectTaskService.savePhenomenon(element);
          }
          return ApiResponse(data: data, statusCode: response.statusCode);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        List<Phenomenon>? dataLocal =
            await _projectTaskService.getPhenomenons();
        if (dataLocal != null && dataLocal.isNotEmpty) {
          return ApiResponse(data: dataLocal, statusCode: 200);
        } else {
          return ApiResponse(
              error: 'Local data is not available && Server is Unreachable',
              statusCode: 404);
        }
      }
    } on TimeoutException catch (_) {
      List<Phenomenon>? dataLocal = await _projectTaskService.getPhenomenons();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(error: 'Request timed out', statusCode: 408);
      }
    } catch (e) {
      List<Phenomenon>? dataLocal = await _projectTaskService.getPhenomenons();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(
            error: 'Error fetching fleet vehicle data: $e', statusCode: 504);
      }
    }
  }

  Future<ApiResponse<List<FsAction>>> fetchFSAction() async {
    final token = await _tokenManager.getValidToken();
    try {
      if (token != 'server_unreachable') {
        final response = await ioClient.get(Uri.parse(Constants.getFSAction),
            headers: {'Content-Type': 'application/json'});

        if (response.statusCode == 200) {
          final List<FsAction> data = (json.decode(response.body) as List)
              .map((json) => FsAction.fromJson(json))
              .toList();

          for (var element in data) {
            _projectTaskService.saveFsAction(element);
          }
          return ApiResponse(data: data, statusCode: response.statusCode);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        List<FsAction>? dataLocal = await _projectTaskService.getFsActions();
        if (dataLocal != null && dataLocal.isNotEmpty) {
          return ApiResponse(data: dataLocal, statusCode: 200);
        } else {
          return ApiResponse(
              error: 'Local data is not available && Server is Unreachable',
              statusCode: 404);
        }
      }
    } on TimeoutException catch (_) {
      List<FsAction>? dataLocal = await _projectTaskService.getFsActions();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(error: 'Request timed out', statusCode: 408);
      }
    } catch (e) {
      List<FsAction>? dataLocal = await _projectTaskService.getFsActions();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(
            error: 'Error fetching fleet vehicle data: $e', statusCode: 504);
      }
    }
  }

  Future<ApiResponse<List<StaticSelection>>> fetchJobAssignLineStatus() async {
    final token = await _tokenManager.getValidToken();
    try {
      if (token != 'server_unreachable') {
        final response = await ioClient.get(Uri.parse(Constants.getJALStatus),
            headers: {'Content-Type': 'application/json'});

        if (response.statusCode == 200) {
          final List<StaticSelection> data =
              (json.decode(response.body) as List)
                  .map((json) => StaticSelection.fromJson(json))
                  .toList();

          for (var element in data) {
            _projectTaskService.saveStaticSelectionJALStatus(element);
          }
          return ApiResponse(data: data, statusCode: response.statusCode);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        List<StaticSelection>? dataLocal =
            await _projectTaskService.getStaticSelectionJALStatus();
        if (dataLocal != null && dataLocal.isNotEmpty) {
          return ApiResponse(data: dataLocal, statusCode: 200);
        } else {
          return ApiResponse(
              error: 'Local data is not available && Server is Unreachable',
              statusCode: 404);
        }
      }
    } on TimeoutException catch (_) {
      List<StaticSelection>? dataLocal =
          await _projectTaskService.getStaticSelectionJALStatus();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(error: 'Request timed out', statusCode: 408);
      }
    } catch (e) {
      List<StaticSelection>? dataLocal =
          await _projectTaskService.getStaticSelectionJALStatus();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(
            error: 'Error fetching fleet vehicle data: $e', statusCode: 504);
      }
    }
  }

  Future<ApiResponse<List<StaticSelection>>> fetchCustomerSatisfied() async {
    final token = await _tokenManager.getValidToken();
    try {
      if (token != 'server_unreachable') {
        final response = await ioClient.get(
            Uri.parse(Constants.getCustomerSatisfied),
            headers: {'Content-Type': 'application/json'});

        if (response.statusCode == 200) {
          final List<StaticSelection> data =
              (json.decode(response.body) as List)
                  .map((json) => StaticSelection.fromJson(json))
                  .toList();

          for (var element in data) {
            _projectTaskService.saveStaticSelectionCS(element);
          }
          return ApiResponse(data: data, statusCode: response.statusCode);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        List<StaticSelection>? dataLocal =
            await _projectTaskService.getStaticSelectionCS();
        if (dataLocal != null && dataLocal.isNotEmpty) {
          return ApiResponse(data: dataLocal, statusCode: 200);
        } else {
          return ApiResponse(
              error: 'Local data is not available && Server is Unreachable',
              statusCode: 404);
        }
      }
    } on TimeoutException catch (_) {
      List<StaticSelection>? dataLocal =
          await _projectTaskService.getStaticSelectionCS();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(error: 'Request timed out', statusCode: 408);
      }
    } catch (e) {
      List<StaticSelection>? dataLocal =
          await _projectTaskService.getStaticSelectionCS();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(
            error: 'Error fetching fleet vehicle data: $e', statusCode: 504);
      }
    }
  }

  Future<ApiResponse<List<StaticSelection>>> fetchServiceJobPoint() async {
    final token = await _tokenManager.getValidToken();
    try {
      if (token != 'server_unreachable') {
        final response = await ioClient.get(
            Uri.parse(Constants.getServiceJobPoint),
            headers: {'Content-Type': 'application/json'});

        if (response.statusCode == 200) {
          final List<StaticSelection> data =
              (json.decode(response.body) as List)
                  .map((json) => StaticSelection.fromJson(json))
                  .toList();

          for (var element in data) {
            _projectTaskService.saveStaticSelectionSJP(element);
          }
          return ApiResponse(data: data, statusCode: response.statusCode);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        List<StaticSelection>? dataLocal =
            await _projectTaskService.getStaticSelectionSJP();
        if (dataLocal != null && dataLocal.isNotEmpty) {
          return ApiResponse(data: dataLocal, statusCode: 200);
        } else {
          return ApiResponse(
              error: 'Local data is not available && Server is Unreachable',
              statusCode: 404);
        }
      }
    } on TimeoutException catch (_) {
      List<StaticSelection>? dataLocal =
          await _projectTaskService.getStaticSelectionSJP();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(error: 'Request timed out', statusCode: 408);
      }
    } catch (e) {
      List<StaticSelection>? dataLocal =
          await _projectTaskService.getStaticSelectionSJP();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(
            error: 'Error fetching fleet vehicle data: $e', statusCode: 504);
      }
    }
  }

  Future<ApiResponse<List<UMGSocialMedia>>> fetchUMGSocialMedia() async {
    try {
      final response =
          await ioClient.get(Uri.parse(Constants.getUMGSocialMedia));
      if (response.statusCode == 200) {
        final List<UMGSocialMedia> data = (json.decode(response.body) as List)
            .map((json) => UMGSocialMedia.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<Selection>>> fetchIsoOjective1() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getIsoOjective1),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<Selection> data = (json.decode(response.body) as List)
            .map((json) => Selection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<Selection>>> fetchIsoOjective2() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getIsoOjective2),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<Selection> data = (json.decode(response.body) as List)
            .map((json) => Selection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<Selection>>> fetchSheetProblem() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getSheetProblem),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<Selection> data = (json.decode(response.body) as List)
            .map((json) => Selection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<StaticSelection>>> fetchImprovScope() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getImprovScope),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<StaticSelection> data = (json.decode(response.body) as List)
            .map((json) => StaticSelection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

// start: ==================================== Support Hub
  Future<ApiResponse<List<StaticSelection>>> fetchSupportHubState() async {
    try {
      final response =
          await ioClient.get(Uri.parse(Constants.getSupoortHubState));
      if (response.statusCode == 200) {
        final List<StaticSelection> data = (json.decode(response.body) as List)
            .map((json) => StaticSelection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<DocumentNumber>> fetchDocumentNumber(String type) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getDocumentNumber(type)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final DocumentNumber data = DocumentNumber.fromJson(jsonData);

        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
          error: getResponseErrorMessage(response),
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<StaticSelection>>> fetchSupportHubPriority() async {
    try {
      final response =
          await ioClient.get(Uri.parse(Constants.getSupoortHubICTPriority));
      if (response.statusCode == 200) {
        final List<StaticSelection> data = (json.decode(response.body) as List)
            .map((json) => StaticSelection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<Selection>>> fetchProductBrand() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getProductBrand),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<Selection> data = (json.decode(response.body) as List)
            .map((json) => Selection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<Selection>>> fetchTsbProductCateg() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getTsbProductCateg),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<Selection> data = (json.decode(response.body) as List)
            .map((json) => Selection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<Selection>>> fetchEngineModel() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getEngineModel),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<Selection> data = (json.decode(response.body) as List)
            .map((json) => Selection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<Selection>>> fetchComponentGroup() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getComponentGroup),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<Selection> data = (json.decode(response.body) as List)
            .map((json) => Selection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<Selection>>> fetchProductModel() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getProductModel),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<Selection> data = (json.decode(response.body) as List)
            .map((json) => Selection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<Selection>>> fetchStockProductionLot() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getStockProductionLot),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<Selection> data = (json.decode(response.body) as List)
            .map((json) => Selection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<StaticSelection>>> fetchTypePart() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getTypePart),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<StaticSelection> data = (json.decode(response.body) as List)
            .map((json) => StaticSelection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<StaticSelection>>> fetchContactType() async {
    try {
      final response =
          await ioClient.get(Uri.parse(Constants.getSupportHubContactType));
      if (response.statusCode == 200) {
        final List<StaticSelection> data = (json.decode(response.body) as List)
            .map((json) => StaticSelection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<Selection>>> fetchProduct() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getProduct),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<Selection> data = (json.decode(response.body) as List)
            .map((json) => Selection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<ICTRequestCategory>>>
      fetchSupportHubICTRequestCategory() async {
    try {
      final response = await ioClient
          .get(Uri.parse(Constants.getSupoortHubICTRequestCategory));
      if (response.statusCode == 200) {
        final List<ICTRequestCategory> data =
            (json.decode(response.body) as List)
                .map((json) => ICTRequestCategory.fromJson(json))
                .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<ICTDevices>>> fetchSupportHubICTDevices() async {
    try {
      final response =
          await ioClient.get(Uri.parse(Constants.getSupoortHubICTDevice));
      if (response.statusCode == 200) {
        final List<ICTDevices> data = (json.decode(response.body) as List)
            .map((json) => ICTDevices.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

// end: ==================================== Support Hub

  Future<ApiResponse<List<Department>>> fetchDepartment() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getDepartment),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<Department> data = (json.decode(response.body) as List)
            .map((json) => Department.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<StaticSelection>>> fetchDispatchFrom() async {
    final token = await _tokenManager.getValidToken();
    try {
      if (token != 'server_unreachable') {
        final response = await ioClient.get(
            Uri.parse(Constants.getDispatchFrom),
            headers: {'Content-Type': 'application/json'});

        if (response.statusCode == 200) {
          final List<StaticSelection> data =
              (json.decode(response.body) as List)
                  .map((json) => StaticSelection.fromJson(json))
                  .toList();

          for (var element in data) {
            _projectTaskService.saveStaticSelectionCS(element);
          }
          return ApiResponse(data: data, statusCode: response.statusCode);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        List<StaticSelection>? dataLocal =
            await _projectTaskService.getStaticSelectionCS();
        if (dataLocal != null && dataLocal.isNotEmpty) {
          return ApiResponse(data: dataLocal, statusCode: 200);
        } else {
          return ApiResponse(
              error: 'Local data is not available && Server is Unreachable',
              statusCode: 404);
        }
      }
    } on TimeoutException catch (_) {
      List<StaticSelection>? dataLocal =
          await _projectTaskService.getStaticSelectionCS();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(error: 'Request timed out', statusCode: 408);
      }
    } catch (e) {
      List<StaticSelection>? dataLocal =
          await _projectTaskService.getStaticSelectionCS();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(
            error: 'Error fetching fleet vehicle data: $e', statusCode: 504);
      }
    }
  }

  Future<ApiResponse<List<StaticSelection>>> fetchArriveAt() async {
    final token = await _tokenManager.getValidToken();
    try {
      if (token != 'server_unreachable') {
        final response = await ioClient.get(Uri.parse(Constants.getArriveAt),
            headers: {'Content-Type': 'application/json'});

        if (response.statusCode == 200) {
          final List<StaticSelection> data =
              (json.decode(response.body) as List)
                  .map((json) => StaticSelection.fromJson(json))
                  .toList();

          for (var element in data) {
            _projectTaskService.saveStaticSelectionCS(element);
          }
          return ApiResponse(data: data, statusCode: response.statusCode);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        List<StaticSelection>? dataLocal =
            await _projectTaskService.getStaticSelectionCS();
        if (dataLocal != null && dataLocal.isNotEmpty) {
          return ApiResponse(data: dataLocal, statusCode: 200);
        } else {
          return ApiResponse(
              error: 'Local data is not available && Server is Unreachable',
              statusCode: 404);
        }
      }
    } on TimeoutException catch (_) {
      List<StaticSelection>? dataLocal =
          await _projectTaskService.getStaticSelectionCS();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(error: 'Request timed out', statusCode: 408);
      }
    } catch (e) {
      List<StaticSelection>? dataLocal =
          await _projectTaskService.getStaticSelectionCS();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(
            error: 'Error fetching fleet vehicle data: $e', statusCode: 504);
      }
    }
  }

  Future<ApiResponse<List<StaticSelection>>>
      fetchScheduleTruckDriverState() async {
    try {
      final response = await ioClient.get(
          Uri.parse(Constants.getScheduleTruckDriverState),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final List<StaticSelection> data = (json.decode(response.body) as List)
            .map((json) => StaticSelection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<StaticSelection>>>
      fetchScheduleTruckDriverTag() async {
    try {
      final response = await ioClient.get(
          Uri.parse(Constants.getScheduleTruckDriverTag),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final List<StaticSelection> data = (json.decode(response.body) as List)
            .map((json) => StaticSelection.fromJson(json))
            .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<MarketingProductType>>>
      fetchSupportHubMarketingProductType() async {
    try {
      final response = await http
          .get(Uri.parse(Constants.getSupoortHubMarketingProductType));
      if (response.statusCode == 200) {
        final List<MarketingProductType> data =
            (json.decode(response.body) as List)
                .map((json) => MarketingProductType.fromJson(json))
                .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }
}
