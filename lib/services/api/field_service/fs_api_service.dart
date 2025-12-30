import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/service-project_task/job_assign_line/job_assign_line.dart';
import 'package:umgkh_mobile/models/service-project_task/project_task/project_task.dart';
import 'package:umgkh_mobile/models/service-project_task/timesheet_project_task/timesheet_project_task.dart';
import 'package:umgkh_mobile/services/local_storage/models/offline_actions_local_storage_service.dart';
import 'package:umgkh_mobile/services/local_storage/models/project_task/project_task_local_storage_service.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../utils/constants.dart';
import '../base/auth/token_service.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/io_client.dart';

class FieldServiceAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ProjectTaskLocalStorageService _projectTaskService =
      ProjectTaskLocalStorageService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

// ============================= GET =============================
  Future<ApiResponse<dynamic>> fetchData(String serviceType,
      int excludedStageId, DateTime startDate, DateTime endDate) async {
    final token = await _tokenManager.getValidToken();
    try {
      if (token != 'server_unreachable') {
        final response = await ioClient.get(
            Uri.parse(
                '${Constants.getFieldServiceLite}/$serviceType/$excludedStageId/${DateFormat('yyyy-MM-dd').format(startDate)}/${DateFormat('yyyy-MM-dd').format(endDate)}'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json'
            });
        if (response.statusCode == 200) {
          final jsonMap = json.decode(response.body);
          final List<ProjectTask> responsePT =
              (jsonMap['project_tasks'] as List)
                  .map(
                    (json) => ProjectTask.fromJson(json),
                  )
                  .toList();
          // final List<TripProjectTask> responseTPT =
          //     (jsonMap['trip_project_tasks'] as List)
          //         .map(
          //           (json) => TripProjectTask.fromJson(json),
          //         )
          //         .toList();
          // final List<TripProjectTaskRel> responseTPTR =
          //     (jsonMap['trip_project_task_rels'] as List)
          //         .map(
          //           (json) => TripProjectTaskRel.fromJson(json),
          //         )
          //         .toList();
          // final List<ProjectTaskRel> responsePTR =
          //     (jsonMap['project_task_rels'] as List)
          //         .map(
          //           (json) => ProjectTaskRel.fromJson(json),
          //         )
          //         .toList();
          await _projectTaskService.deleteJobAssignLineAll();
          await _projectTaskService.deleteTimesheetProjectTaskAll();
          await _projectTaskService.deleteOverallCheckingAll();
          await _projectTaskService.deleteServiceReportAll();
          await _projectTaskService.deleteJobFinishAll();
          await _projectTaskService.deleteJobAnalyticAll();
          await _projectTaskService.deleteProjectTaskAll();
          // await _projectTaskService.deleteTripProjectTaskAll();
          // await _projectTaskService.deleteTripProjectTaskRelAll();
          // await _projectTaskService.deleteProjectTaskRelAll();
          for (var element in responsePT) {
            await _projectTaskService.saveProjectTask(element);
          }
          // for (var element in responseTPT) {
          //   await _projectTaskService.saveTripProjectTask(element);
          // }
          // for (var element in responseTPTR) {
          //   await _projectTaskService.saveTripProjectTaskRel(element);
          // }
          // for (var element in responsePTR) {
          //   await _projectTaskService.saveProjectTaskRel(element);
          // }
          return ApiResponse(data: {
            "project_tasks": responsePT,
            // "trip_project_tasks": responseTPT,
            // "trip_project_task_rels": responseTPTR,
            // "project_task_rels": responsePTR,
          }, statusCode: response.statusCode);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        List<ProjectTask>? dataLocal =
            await _projectTaskService.getProjectTaskAll();
        // List<TripProjectTask>? dataLocalTPT =
        //     await _projectTaskService.getTripProjectTaskAll();
        // List<TripProjectTaskRel>? dataLocalTPTRel =
        //     await _projectTaskService.getTripProjectTaskRelAll();
        // List<ProjectTaskRel>? dataLocalPTRel =
        //     await _projectTaskService.getProjectTaskRelAll();
        if (dataLocal != null && dataLocal.isNotEmpty) {
          return ApiResponse(data: {
            "project_tasks": dataLocal,
            // "trip_project_tasks": dataLocalTPT,
            // "trip_project_task_rels": dataLocalTPTRel,
            // "project_task_rels": dataLocalPTRel,
          }, statusCode: 200);
        } else {
          return ApiResponse(
              error: 'Local data is not available && Server is Unreachable',
              statusCode: 404);
        }
      }
    } on TimeoutException catch (_) {
      List<ProjectTask>? dataLocal =
          await _projectTaskService.getProjectTaskAll();
      // List<TripProjectTask>? dataLocalTPT =
      //     await _projectTaskService.getTripProjectTaskAll();
      // List<TripProjectTaskRel>? dataLocalTPTRel =
      //     await _projectTaskService.getTripProjectTaskRelAll();
      // List<ProjectTaskRel>? dataLocalPTRel =
      //     await _projectTaskService.getProjectTaskRelAll();
      if (dataLocal != null && dataLocal.isNotEmpty) {
        return ApiResponse(data: {
          "project_tasks": dataLocal,
          // "trip_project_tasks": dataLocalTPT,
          // "trip_project_task_rels": dataLocalTPTRel,
          // "project_task_rels": dataLocalPTRel,
        }, statusCode: 200);
      } else {
        return ApiResponse(error: 'Request timed out', statusCode: 408);
      }
    } catch (e) {
      List<ProjectTask>? dataLocal =
          await _projectTaskService.getProjectTaskAll();

      if (dataLocal != null && dataLocal.isNotEmpty) {
        // List<TripProjectTask>? dataLocalTPT =
        //     await _projectTaskService.getTripProjectTaskAll();
        // List<TripProjectTaskRel>? dataLocalTPTRel =
        //     await _projectTaskService.getTripProjectTaskRelAll();
        // List<ProjectTaskRel>? dataLocalPTRel =
        //     await _projectTaskService.getProjectTaskRelAll();
        return ApiResponse(data: {
          "project_tasks": dataLocal,
          // "trip_project_tasks": dataLocalTPT,
          // "trip_project_task_rels": dataLocalTPTRel,
          // "project_task_rels": dataLocalPTRel,
        }, statusCode: 200);
      } else {
        return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
      }
    }
  }

  Future<ApiResponse<dynamic>> fetchDataById(int id, String serviceType) async {
    final token = await _tokenManager.getValidToken();
    try {
      if (token != 'server_unreachable') {
        final response = await ioClient.get(
            Uri.parse('${Constants.getFieldServiceLite}/$serviceType/$id'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json'
            });
        if (response.statusCode == 200) {
          final jsonMap = json.decode(response.body);
          final ProjectTask responsePT = ProjectTask.fromJson(
            jsonMap['project_task'],
          );
          // final List<TripProjectTask> responseTPT =
          //     (jsonMap['trip_project_tasks'] as List)
          //         .map((taskMap) => TripProjectTask.fromJson(taskMap))
          //         .toList();
          // final List<TripProjectTaskRel> responseTPTR =
          //     (jsonMap['trip_project_task_rels'] as List)
          //         .map((taskMap) => TripProjectTaskRel.fromJson(taskMap))
          //         .toList();
          // final List<TripProjectTaskRel> responsePTR =
          //     (jsonMap['project_task_rels'] as List)
          //         .map((taskMap) => TripProjectTaskRel.fromJson(taskMap))
          //         .toList();
          await _projectTaskService.saveProjectTask(responsePT);
          return ApiResponse(data: {
            "project_task": responsePT,
            // "trip_project_task": responseTPT,
            // "trip_project_task_rel": responseTPTR,
            // "project_task_rel": responsePTR,
          }, statusCode: response.statusCode);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        ProjectTask? dataLocal =
            await _projectTaskService.getProjectTaskById(id);
        // List<TripProjectTaskRel>? dataLocalTPTRel =
        //     await _projectTaskService.getTripProjectTaskRelByTaskId(id);
        // List<TripProjectTask>? dataLocalLTPT;
        // var index = 0;
        // for (var data in dataLocalTPTRel!) {
        //   TripProjectTask? dataLocalTPT = await _projectTaskService
        //       .getTripProjectTaskById(data.tripId!, data.tripOffId);
        //   if (dataLocalTPT != null) {
        //     dataLocalLTPT![index] = dataLocalTPT;
        //     index = 1 + index;
        //   }
        // }
        // List<ProjectTaskRel>? dataLocalPTR =
        //     await _projectTaskService.getProjectTaskRelByTaskId(id);
        if (dataLocal != null) {
          return ApiResponse(data: {
            "project_task": dataLocal,
            // "trip_project_task": dataLocalLTPT,
            // "trip_project_task_rel": dataLocalTPTRel,
            // "project_task_rel": dataLocalPTR,
          }, statusCode: 200);
        } else {
          return ApiResponse(
              error: 'Local data is not available && Server is Unreachable',
              statusCode: 404);
        }
      }
    } on TimeoutException catch (_) {
      ProjectTask? dataLocal = await _projectTaskService.getProjectTaskById(id);
      // List<TripProjectTaskRel>? dataLocalTPTRel =
      //     await _projectTaskService.getTripProjectTaskRelByTaskId(id);
      // List<TripProjectTask>? dataLocalLTPT;
      // var index = 0;
      // for (var data in dataLocalTPTRel!) {
      //   TripProjectTask? dataLocalTPT = await _projectTaskService
      //       .getTripProjectTaskById(data.tripId, data.tripOffId);
      //   if (dataLocalTPT != null) {
      //     dataLocalLTPT![index] = dataLocalTPT;
      //     index = 1 + index;
      //   }
      // }
      // List<ProjectTaskRel>? dataLocalPTR =
      //     await _projectTaskService.getProjectTaskRelByTaskId(id);
      if (dataLocal != null) {
        return ApiResponse(data: {
          "project_task": dataLocal,
          // "trip_project_task": dataLocalLTPT,
          // "trip_project_task_rel": dataLocalTPTRel,
          // "project_task_rel": dataLocalPTR,
        }, statusCode: 200);
      } else {
        return ApiResponse(error: 'Request timed out', statusCode: 408);
      }
    } catch (e) {
      ProjectTask? dataLocal = await _projectTaskService.getProjectTaskById(id);
      // List<TripProjectTaskRel>? dataLocalTPTRel =
      //     await _projectTaskService.getTripProjectTaskRelByTaskId(id);
      // List<TripProjectTask>? dataLocalLTPT;
      // var index = 0;

      // if (dataLocalTPTRel != null) {
      //   dataLocalLTPT = [];
      //   for (var data in dataLocalTPTRel) {
      //     TripProjectTask? dataLocalTPT = await _projectTaskService
      //         .getTripProjectTaskById(data.tripId, data.tripOffId);
      //     if (dataLocalTPT != null) {
      //       if (index < dataLocalLTPT.length) {
      //         dataLocalLTPT[index] = dataLocalTPT;
      //       } else {
      //         dataLocalLTPT.add(dataLocalTPT);
      //       }
      //       index++;
      //     }
      //   }
      // }
      // List<ProjectTaskRel>? dataLocalPTR =
      //     await _projectTaskService.getProjectTaskRelByTaskId(id);
      if (dataLocal != null) {
        return ApiResponse(data: {
          "project_task": dataLocal,
          // "trip_project_task": dataLocalLTPT,
          // "trip_project_task_rel": dataLocalTPTRel,
          // "project_task_rel": dataLocalPTR,
        }, statusCode: 200);
      } else {
        return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
      }
    }
  }

// ============================= PUT =============================
  Future<ApiResponse<dynamic>> updateStateJobAssign(
      {required int jobAssignId,
      required String state,
      required String reason,
      required JobAssignLine jobAssignLine,
      required String dtAction}) async {
    final token = await _tokenManager.getValidToken();

    try {
      if (token != 'server_unreachable') {
        final response = await ioClient.put(
          Uri.parse(Constants.updateJobAssignState),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json
              .encode({'id': jobAssignId, 'state': state, 'reason': reason}),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final responseMessage = responseData['message'];
          final resultData = responseData['result'];

          return ApiResponse(
              data: resultData,
              statusCode: response.statusCode,
              message: responseMessage);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        await ProjectTaskLocalStorageService().updateJobAssignLine(
            jobAssignId, state, reason, jobAssignLine, dtAction);
        return ApiResponse(
            data: jobAssignLine, statusCode: 200, message: 'responseMessage');
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<dynamic>> updateTimesheet(Map<String, dynamic> data,
      TimesheetProjectTask timesheet, int taskId) async {
    final token = await _tokenManager.getValidToken();
    try {
      if (token != 'server_unreachable') {
        var validData = true;
        // if (data['arrive_at_office_dt'] != null) {
        //   List<TimesheetProjectTask>? relatedTimesheets =
        //       await _projectTaskService.getTimesheetProjectTaskByTripId(
        //           // timesheet.tripId,
        //           // timesheet.tripOffId,
        //           timesheet.id,
        //           timesheet.offId);

        //   if (relatedTimesheets != null) {
        //     for (var rt in relatedTimesheets) {
        //       if (rt.leaveFromSiteDt == null) {
        //         validData = false;
        //       }
        //     }
        //   }
        // }
        if (validData) {
          final response = await ioClient.put(
            Uri.parse(Constants.createTimesheet),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json'
            },
            body: jsonEncode(data),
          );
          if (response.statusCode == 201) {
            final res = json.decode(response.body);
            return ApiResponse(
                data: res['result'],
                statusCode: response.statusCode,
                message: res['message']);
          } else {
            return ApiResponse(
                error: getResponseErrorMessage(response),
                statusCode: response.statusCode);
          }
        }
        // else {
        //   return ApiResponse(
        //       data: timesheet,
        //       statusCode: 408,
        //       error:
        //           "Can't Fill Leave, because the related task not yet fill the completed task!");
        // }
      } else {
        // var validData = true;
        // if (data['arrive_at_office_dt'] != null) {
        //   List<TimesheetProjectTask>? relatedTimesheets =
        //       await _projectTaskService.getTimesheetProjectTaskByTripId(
        //           // timesheet.tripId,
        //           // timesheet.tripOffId,
        //           timesheet.id,
        //           timesheet.offId);

        //   if (relatedTimesheets != null) {
        //     for (var rt in relatedTimesheets) {
        //       if (rt.leaveFromSiteDt == null) {
        //         validData = false;
        //       }
        //     }
        //   }
        // }
        // if (validData) {
        TimesheetProjectTask timesheetUpdate = TimesheetProjectTask(
          id: timesheet.id,
          trip: timesheet.trip,
          totalMileage: 0,
          odometerStart: timesheet.odometerStart,
          odometerEnd:
              data['odometer_end'] != null && data['odometer_end'] != ''
                  ? int.parse(data['odometer_end'])
                  : 0,
          dispatchDt: timesheet.dispatchDt,
          arrivalAtSiteDt: data['arrival_at_site_dt'] != null
              ? DateTime.tryParse(data['arrival_at_site_dt'])
              : null,
          jobStartDt: data['job_start_dt'] != null
              ? DateTime.tryParse(data['job_start_dt'])
              : null,
          jobCompleteDt: data['job_complete_dt'] != null
              ? DateTime.tryParse(data['job_complete_dt'])
              : null,
          leaveFromSiteDt: data['leave_from_site_dt'] != null
              ? DateTime.tryParse(data['leave_from_site_dt'])
              : null,
          arriveAtOfficeDt: data['arrive_at_office_dt'] != null
              ? DateTime.tryParse(data['arrive_at_office_dt'])
              : null,
          totalTimeStore: timesheet.totalTimeStore,
          offId: timesheet.offId,
          fleetVehicle: timesheet.fleetVehicle,
          pauseContinue: timesheet.pauseContinue,
          projectTaskId: timesheet.projectTaskId,
          dispatchFrom: timesheet.dispatchFrom,
          arriveAt: data['arrive_at'],
        );
        await OfflineActionStorageService().saveOfflineAction(
          'timesheet.project.task',
          0,
          'update',
          jsonEncode(timesheetUpdate),
        );
        await ProjectTaskLocalStorageService()
            .updateTimesheetProjectTask(timesheetUpdate, taskId);
        // TripProjectTask tripProjectTask = TripProjectTask(
        //   id: timesheet.tripId,
        //   name: '-',
        //   arriveAtOfficeDt: data['arrive_at_office_dt'] != null
        //       ? DateTime.tryParse(data['arrive_at_office_dt'])
        //       : null,
        //   odometerStart: timesheet.odometerStart,
        //   odometerEnd:
        //       data['odometer_end'] != null && data['odometer_end'] != ''
        //           ? int.parse(data['odometer_end'])
        //           : 0,
        //   offId: timesheet.tripOffId,
        // );
        // await ProjectTaskLocalStorageService()
        //     .updateTripProjectTask(tripProjectTask);

        //   List<TimesheetProjectTask>? tpts =
        //       await _projectTaskService.getTimesheetProjectTaskByTripId(
        //           timesheet.tripId,
        //           timesheet.tripOffId,
        //           timesheet.id,
        //           timesheet.offId);
        //   await OfflineActionStorageService().saveOfflineAction(
        //     'trip.project.tasks',
        //     0,
        //     'update',
        //     jsonEncode(tripProjectTask),
        //   );
        //   if (tpts != null) {
        //     for (var tpt in tpts) {
        //       TimesheetProjectTask timesheetUpdate = TimesheetProjectTask(
        //         id: tpt.id,
        //         trip: tpt.trip,
        //         totalMileage: 0,
        //         odometerStart: tpt.odometerStart,
        //         odometerEnd:
        //             data['odometer_end'] != null && data['odometer_end'] != ''
        //                 ? int.parse(data['odometer_end'])
        //                 : 0,
        //         dispatchDt: tpt.dispatchDt,
        //         arrivalAtSiteDt: tpt.arrivalAtSiteDt,
        //         jobStartDt: tpt.jobStartDt,
        //         jobCompleteDt: tpt.jobCompleteDt,
        //         leaveFromSiteDt: tpt.leaveFromSiteDt,
        //         arriveAtOfficeDt: data['arrive_at_office_dt'] != null
        //             ? DateTime.tryParse(data['arrive_at_office_dt'])
        //             : null,
        //         totalTimeStore: tpt.totalTimeStore,
        //         offId: tpt.offId,
        //         fleetVehicle: tpt.fleetVehicle,
        //         pauseContinue: tpt.pauseContinue,
        //         projectTaskId: tpt.projectTaskId,
        //         arriveAt: tpt.arriveAt,
        //       );
        //       await ProjectTaskLocalStorageService().updateTimesheetProjectTask(
        //           timesheetUpdate, tpt.projectTaskId!);
        //       await OfflineActionStorageService().saveOfflineAction(
        //         'timesheet.project.task',
        //         0,
        //         'update',
        //         jsonEncode(timesheetUpdate),
        //       );
        //     }
        //   }
        //   return ApiResponse(
        //       data: timesheet, statusCode: 200, message: "Success");
        // } else {
        //   return ApiResponse(
        //       data: timesheet,
        //       statusCode: 408,
        //       error:
        //           "Can't Fill Leave, because the related task not yet fill the completed task!");

        return ApiResponse(
            data: timesheet, statusCode: 200, message: "Success");
        // }
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<dynamic>> updateContinueTask(
      Map<String, dynamic> data) async {
    final token = await _tokenManager.getValidToken();

    try {
      final response = await ioClient.put(
        Uri.parse(Constants.pauseContinue),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        final res = json.decode(response.body);
        return ApiResponse(
            data: res['result'],
            statusCode: response.statusCode,
            message: res['message']);
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

  Future<ApiResponse<dynamic>> updateUpdateStageFieldService(
      Map<String, dynamic> data) async {
    final token = await _tokenManager.getValidToken();

    try {
      final response = await ioClient.put(
        Uri.parse(Constants.stageFieldService),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        final res = json.decode(response.body);
        return ApiResponse(
            data: res['result'],
            statusCode: response.statusCode,
            message: res['message']);
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

  Future<ApiResponse<dynamic>> updateTimesheetWorkshop(
      Map<String, dynamic> data) async {
    final token = await _tokenManager.getValidToken();

    try {
      final response = await ioClient.put(
        Uri.parse(Constants.timesheetWorkshop),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        final res = json.decode(response.body);
        return ApiResponse(
            data: res['result'],
            statusCode: response.statusCode,
            message: res['message']);
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

// ============================= POST =============================
  Future<ApiResponse<String>> insertOverallChecking(
      List<File>? files, Map<String, dynamic> data) async {
    final token = await _tokenManager.getValidToken();
    try {
      if (token != 'server_unreachable') {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(Constants.createOverallChecking),
        );
        request.headers['Authorization'] = 'Bearer $token';
        request.fields.addAll(
          data.map(
            (key, value) => MapEntry(
              key,
              value.toString(),
            ),
          ),
        );
        if (files != null) {
          for (var file in files) {
            var stream = http.ByteStream(
              file.openRead(),
            );
            var length = await file.length();
            var multipartFile = http.MultipartFile(
              'pictures',
              stream,
              length,
              filename: basename(file.path),
            );
            request.files.add(multipartFile);
          }
        }

        var streamedResponse = await ioClient.send(request);
        final response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 201) {
          return ApiResponse(
            statusCode: response.statusCode,
            message: getResponseMessage(response),
          );
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        await ProjectTaskLocalStorageService().saveOverallCheckingLite(
            data, data['tab_overall_checking_id'], data['image_paths']);
        await OfflineActionStorageService().saveOfflineAction(
          'tab.overall.checking',
          0,
          'create',
          jsonEncode(data),
        );
        return ApiResponse(statusCode: 201, message: "Success");
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<String>> insertServiceReport(
      List<File>? files, Map<String, dynamic> data) async {
    final token = await _tokenManager.getValidToken();
    try {
      if (token != 'server_unreachable') {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(Constants.createServiceReport),
        );
        request.headers['Authorization'] = 'Bearer $token';
        request.fields.addAll(
          data.map(
            (key, value) => MapEntry(
              key,
              value.toString(),
            ),
          ),
        );
        if (files != null) {
          for (var file in files) {
            var stream = http.ByteStream(
              file.openRead(),
            );
            var length = await file.length();
            var multipartFile = http.MultipartFile(
              'pictures',
              stream,
              length,
              filename: basename(file.path),
            );
            request.files.add(multipartFile);
          }
        }

        var streamedResponse = await ioClient.send(request);
        final response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 201) {
          return ApiResponse(
            statusCode: response.statusCode,
            message: getResponseMessage(response),
          );
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        await ProjectTaskLocalStorageService().saveServiceReportLite(
            data, data['service_report_project_id'], data['image_paths']);
        await OfflineActionStorageService().saveOfflineAction(
          'service.report.project',
          0,
          'create',
          jsonEncode(data),
        );
        return ApiResponse(statusCode: 201, message: "Success");
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<String>> insertJobFinish(
      List<File> pictures, Map<String, dynamic> data) async {
    final token = await _tokenManager.getValidToken();
    try {
      if (token != 'server_unreachable') {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(Constants.createJobFinish),
        );
        request.headers['Authorization'] = 'Bearer $token';
        request.fields.addAll(
          data.map(
            (key, value) => MapEntry(
              key,
              value.toString(),
            ),
          ),
        );

        // if (picture != null) {
        //   request.files.add(
        //     await ioClient.MultipartFile.fromPath('picture', picture.path),
        //   );
        // }
        for (var picture in pictures) {
          request.files.add(
            await http.MultipartFile.fromPath('picture', picture.path),
          );
        }
        var streamedResponse = await ioClient.send(request);
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 201) {
          return ApiResponse(
            statusCode: response.statusCode,
            message: getResponseMessage(response),
          );
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        final imagePaths = <String, String>{};
        if (pictures.isNotEmpty) {
          imagePaths['sign'] = pictures[0].path;
        }
        if (pictures.length > 1) {
          imagePaths['mechanic_sign'] = pictures[1].path;
        }

        await ProjectTaskLocalStorageService().saveJobFinishLite(
          data,
          data['job_finish_project_id'],
          imagePaths,
        );
        await OfflineActionStorageService().saveOfflineAction(
          'job.finish.project',
          0,
          'create',
          jsonEncode(data),
        );
        return ApiResponse(statusCode: 201, message: "Success");
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<dynamic>> insertJobAnaylic(
      Map<String, dynamic> data) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.post(
        Uri.parse(Constants.createJobAnalytic),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        final res = json.decode(response.body);
        return ApiResponse(
            data: res['result'],
            statusCode: response.statusCode,
            message: res['message']);
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

  Future<ApiResponse<dynamic>> insertTimesheet(
      TimesheetProjectTask data, int taskId) async {
    final token = await _tokenManager.getValidToken();
    final codeLock = DateTime.now().toIso8601String();
    try {
      if (token != 'server_unreachable') {
        final response = await ioClient.post(
          Uri.parse(Constants.createTimesheet),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'timesheet_task_project_id': data.projectTaskId,
            'trip': data.trip,
            'fleet_id': data.fleetVehicle!.id,
            'odometer_start': data.odometerStart,
            'off_id': data.offId,
            // 'trip_data': dataTrip,
            // 'trip_pt_rel': dataTripPTRel,
            'dispatch_from': data.dispatchFrom
          }),
        );
        if (response.statusCode == 201) {
          final res = json.decode(response.body);
          return ApiResponse(
              data: res['result'],
              statusCode: response.statusCode,
              message: res['message']);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        await ProjectTaskLocalStorageService()
            .saveTimesheetProjectTaskLite(data, taskId, codeLock);

        // List<ProjectTaskRel>? dataLocalPTR =
        //     await ProjectTaskLocalStorageService()
        //         .getProjectTaskRelByTaskId(taskId);
        // await OfflineActionStorageService().saveOfflineAction(
        //   'trip.project.tasks',
        //   0,
        //   'create',
        //   jsonEncode({'trip': dataTrip, 'trip_task_rel': dataTripPTRel}),
        // );
        await OfflineActionStorageService().saveOfflineAction(
          'timesheet.project.task',
          0,
          'create',
          jsonEncode(data),
        );

        await ProjectTaskLocalStorageService()
            .getTimesheetProjectTaskByTaskId(taskId);

        // if (dataLocalPTR != null) {
        //   for (var ptr in dataLocalPTR) {
        //     // TripProjectTaskRel insertTripPTRelatedTask = TripProjectTaskRel(
        //     //   taskId: ptr.relatedTaskId,
        //     //   tripId: dataTrip.id,
        //     //   tripOffId: dataTripPTRel.tripOffId,
        //     // );
        //     // await OfflineActionStorageService().saveOfflineAction(
        //     //   'trip.project.tasks',
        //     //   0,
        //     //   'create',
        //     //   jsonEncode(
        //     //       {'trip': dataTrip, 'trip_task_rel': insertTripPTRelatedTask}),
        //     // );
        //     var trip = 1;
        //     var timesheets = await ProjectTaskLocalStorageService()
        //         .getTimesheetProjectTaskByTaskId(ptr.relatedTaskId!);
        //     if (timesheets != null) {
        //       for (var timesheet in timesheets) {
        //         if (timesheet.trip != null) {
        //           if (trip <= timesheet.trip!) {
        //             trip = timesheet.trip! + 1;
        //           }
        //         }
        //       }
        //     }
        //     TimesheetProjectTask insertData = TimesheetProjectTask(
        //         trip: trip,
        //         fleetVehicle: data.fleetVehicle,
        //         offId: '${ptr.relatedTaskId.toString()}-$codeLock',
        //         dispatchDt: DateTime.now(),
        //         odometerStart: data.odometerStart,
        //         projectTaskId: ptr.relatedTaskId,
        //         // tripOffId: data.tripOffId,
        //         dispatchFrom: data.dispatchFrom);
        //     await OfflineActionStorageService().saveOfflineAction(
        //       'timesheet.project.task',
        //       0,
        //       'create',
        //       jsonEncode(insertData),
        //     );
        //   }
        // }
        return ApiResponse(data: data, statusCode: 201, message: "Success");
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<dynamic>> insertPauseTask(
      Map<String, dynamic> data) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.post(
        Uri.parse(Constants.pauseContinue),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        final res = json.decode(response.body);
        return ApiResponse(
            data: res['result'],
            statusCode: response.statusCode,
            message: res['message']);
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

  Future<ApiResponse<dynamic>> insertTimesheetWorkshop(
      Map<String, dynamic> data) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.post(
        Uri.parse(Constants.timesheetWorkshop),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        final res = json.decode(response.body);
        return ApiResponse(
            data: res['result'],
            statusCode: response.statusCode,
            message: res['message']);
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

  Future<ApiResponse<String>> insertCallToCustomer(
      File? picture, Map<String, dynamic> data) async {
    try {
      final token = await _tokenManager.getValidToken();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Constants.callToCustomer),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields.addAll(
        data.map(
          (key, value) => MapEntry(
            key,
            value.toString(),
          ),
        ),
      );

      if (picture != null) {
        request.files.add(
          await http.MultipartFile.fromPath('picture', picture.path),
        );
      }
      var streamedResponse = await ioClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return ApiResponse(
          statusCode: response.statusCode,
          message: getResponseMessage(response),
        );
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
