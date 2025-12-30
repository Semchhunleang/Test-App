// ignore_for_file: unused_catch_stack

import 'package:sqflite/sqflite.dart';
// import 'package:umgkh_mobile/models/am/vehicle_check/brand.dart';
import 'package:umgkh_mobile/models/am/vehicle_check/fleet_vehicle.dart';
import 'package:umgkh_mobile/models/am/vehicle_check/fleet_vehicle_brand.dart';
import 'package:umgkh_mobile/models/am/vehicle_check/fleet_vehicle_model.dart';
import 'package:umgkh_mobile/models/base/data/static_selection.dart';
// import 'package:umgkh_mobile/models/am/vehicle_check/model.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/crm/city/city.dart';
import 'package:umgkh_mobile/models/crm/country/country.dart';
import 'package:umgkh_mobile/models/crm/country_state/country_state.dart';
import 'package:umgkh_mobile/models/crm/customer/customer.dart';
import 'package:umgkh_mobile/models/e-catalog/product/product.dart';
import 'package:umgkh_mobile/models/e-catalog/website_category/website_category.dart';
import 'package:umgkh_mobile/models/service-project_task/fs_action/fs_action.dart';
import 'package:umgkh_mobile/models/service-project_task/function_group/function_group.dart';
import 'package:umgkh_mobile/models/service-project_task/helpdesk_ticket_type/helpdesk_ticket_type.dart';
import 'package:umgkh_mobile/models/service-project_task/job_analytic/job_analytic.dart';
import 'package:umgkh_mobile/models/service-project_task/job_assign_line/job_assign_line.dart';
import 'package:umgkh_mobile/models/service-project_task/job_classification/job_classification.dart';
import 'package:umgkh_mobile/models/service-project_task/job_finish/job_finish.dart';
import 'package:umgkh_mobile/models/service-project_task/job_group/job_group.dart';
import 'package:umgkh_mobile/models/service-project_task/machine_application/machine_application.dart';
import 'package:umgkh_mobile/models/service-project_task/overall_checking/overall_checking.dart';
import 'package:umgkh_mobile/models/service-project_task/pause_continue/pause_continue.dart';
import 'package:umgkh_mobile/models/service-project_task/phenomenon/phenomenon.dart';
import 'package:umgkh_mobile/models/service-project_task/product_category/product_category.dart';
import 'package:umgkh_mobile/models/service-project_task/project_task/project_task.dart';
import 'package:umgkh_mobile/models/service-project_task/project_task_rel/project_task_rel.dart';
import 'package:umgkh_mobile/models/service-project_task/service_report/service_report.dart';
import 'package:umgkh_mobile/models/service-project_task/stage/stage.dart';
import 'package:umgkh_mobile/models/service-project_task/stock_production_lot/stock_production_lot.dart';
import 'package:umgkh_mobile/models/service-project_task/system_component/system_component.dart';
import 'package:umgkh_mobile/models/service-project_task/timesheet_project_task/timesheet_project_task.dart';
import 'package:umgkh_mobile/models/service-project_task/trip_project_task/trip_project_task.dart';
import 'package:umgkh_mobile/models/service-project_task/trip_project_task_rel/trip_project_task_rel.dart';
import 'package:umgkh_mobile/services/local_storage/local_storage_service.dart';
import 'package:umgkh_mobile/services/local_storage/models/user_local_storage_service.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class ProjectTaskLocalStorageService {
  final Database _db;
  final UserLocalStorageService _userLocalStorageService =
      UserLocalStorageService();

  ProjectTaskLocalStorageService() : _db = LocalStorageService().db;

  Future<int> saveProjectTask(ProjectTask task) async {
    await deleteProjectTask(task.id);

    List<Map<String, dynamic>> result = await _db.query('project_tasks',
        where: 'id = ?', whereArgs: [task.id], limit: 1);
    if (task.stage != null) {
      await saveStage(task.stage!);
    }
    if (task.assistant != null) {
      await _userLocalStorageService.saveUser(task.assistant!);
    }
    if (task.customer != null && task.customer!.id != null) {
      if (task.customer!.country != null &&
          task.customer!.country!.id != null) {
        await saveCountry(task.customer!.country!);
      }
      if (task.customer!.countryState != null &&
          task.customer!.countryState!.id != null) {
        await saveCountryState(task.customer!.countryState!);
      }
      if (task.customer!.city != null && task.customer!.city!.id != null) {
        await saveCity(task.customer!.city!);
      }
      await saveCustomer(task.customer!);
    }
    // if (task.application != null) {
    //   await saveApplication(task.application!);
    // }
    if (task.city != null && task.city!.id != null) {
      await saveCity(task.city!);
    }
    if (task.state != null && task.state!.id != null) {
      await saveCountryState(task.state!);
    }
    if (task.machineSerialNumber != null) {
      await saveStockProductionLot(task.machineSerialNumber!);
    }
    if (task.machineCategory != null) {
      await saveProductCategory(task.machineCategory!);
    }
    if (task.product != null) {
      if (task.product!.category != null) {
        await saveWebsiteCategory(task.product!.category!);
      }
      if (task.product!.productCategory != null) {
        await saveProductCategory(task.product!.productCategory!);
      }
      await saveProduct(task.product!);
    }
    if (task.component != null) {
      if (task.component!.category != null) {
        await saveWebsiteCategory(task.component!.category!);
      }
      if (task.component!.productCategory != null) {
        await saveProductCategory(task.component!.productCategory!);
      }
      await saveProduct(task.component!);
    }
    if (task.componentLot != null) {
      await saveStockProductionLot(task.componentLot!);
    }

    // await deleteJobAssignLineAll();
    if (task.jobAssignLines != null && task.jobAssignLines!.isNotEmpty) {
      for (var i = 0; i < task.jobAssignLines!.length; i++) {
        await _userLocalStorageService
            .saveUser(task.jobAssignLines![i].mechanic);
        await saveJobAssignLine(task.jobAssignLines![i], task.id);
      }
    }

    // await deleteTimesheetProjectTaskAll();
    if (task.timesheetProjectTasks != null &&
        task.timesheetProjectTasks!.isNotEmpty) {
      for (var i = 0; i < task.timesheetProjectTasks!.length; i++) {
        if (task.timesheetProjectTasks![i].pauseContinue != null &&
            task.timesheetProjectTasks![i].pauseContinue!.isNotEmpty) {
          for (var j = 0;
              j < task.timesheetProjectTasks![i].pauseContinue!.length;
              j++) {
            if (task.timesheetProjectTasks![i].pauseContinue![j].userPause !=
                null) {
              await _userLocalStorageService.saveUser(
                  task.timesheetProjectTasks![i].pauseContinue![j].userPause!);
            }
            if (task.timesheetProjectTasks![i].pauseContinue![j].userContinue !=
                null) {
              await _userLocalStorageService.saveUser(task
                  .timesheetProjectTasks![i].pauseContinue![j].userContinue!);
            }
            await savePauseContinue(
                task.timesheetProjectTasks![i].pauseContinue![j]);
          }
        }
        if (task.timesheetProjectTasks![i].fleetVehicle != null &&
            task.timesheetProjectTasks![i].fleetVehicle!.id != null) {
          if (task.timesheetProjectTasks![i].fleetVehicle!.model != null &&
              task.timesheetProjectTasks![i].fleetVehicle!.model!.id != null) {
            if (task.timesheetProjectTasks![i].fleetVehicle!.model!.brand !=
                    null &&
                task.timesheetProjectTasks![i].fleetVehicle!.model!.brand!.id !=
                    null) {
              await saveBrand(
                  task.timesheetProjectTasks![i].fleetVehicle!.model!.brand!);
            }
            await saveModel(
                task.timesheetProjectTasks![i].fleetVehicle!.model!);
          }
          await saveFleetVehicle(task.timesheetProjectTasks![i].fleetVehicle!);
        }
        await saveTimesheetProjectTask(task.timesheetProjectTasks![i]);
      }
    }
    // await deleteOverallCheckingAll();
    if (task.overallCheckings != null && task.overallCheckings!.isNotEmpty) {
      for (var i = 0; i < task.overallCheckings!.length; i++) {
        await saveOverallChecking(task.overallCheckings![i], task.id);
      }
    }

    // await deleteServiceReportAll();
    if (task.serviceReports != null && task.serviceReports!.isNotEmpty) {
      for (var i = 0; i < task.serviceReports!.length; i++) {
        await saveServiceReport(task.serviceReports![i], task.id);
      }
    }

    // await deleteJobFinishAll();
    if (task.jobFinishes != null && task.jobFinishes!.isNotEmpty) {
      for (var i = 0; i < task.jobFinishes!.length; i++) {
        await saveJobFinish(task.jobFinishes![i], task.id);
      }
    }

    // await deleteJobAnalyticAll();
    if (task.jobAnalytics != null && task.jobAnalytics!.isNotEmpty) {
      for (var i = 0; i < task.jobAnalytics!.length; i++) {
        if (task.jobAnalytics![i].system != null) {
          await saveSystemComponent(task.jobAnalytics![i].system!);
        }
        if (task.jobAnalytics![i].phenomenon != null) {
          await savePhenomenon(task.jobAnalytics![i].phenomenon!);
        }
        if (task.jobAnalytics![i].action != null) {
          await saveFsAction(task.jobAnalytics![i].action!);
        }
        await saveJobAnalytic(task.jobAnalytics![i], task.id);
      }
    }

    if (result.isEmpty) {
      return await _db.insert(
          'project_tasks',
          {
            'id': task.id,
            'job_order_no': task.jobOrderNo,
            'name': task.name,
            'stage_id': task.stage!.id,
            'datetime': task.datetime != null
                ? rollbackParseDateTimeNoUtc(task.datetime!)
                : null,
            // 'job_classification_id': task.jobClassification?.id,
            // 'job_group_id': task.jobClassification?.id,
            // 'function_group_id': task.functionGroup?.id,
            'job_order_type': task.jobOrderType,
            'close_datetime': task.closeDateTime != null
                ? rollbackParseDateTimeNoUtc(task.closeDateTime!)
                : null,
            'cause': task.cause,
            'job_finish_datetime': task.jobFinishDatetime != null
                ? rollbackParseDateTimeNoUtc(task.closeDateTime!)
                : null,
            'is_redo': task.isRedo == true ? 1 : 0,
            // 'type_in_ticket_id': task.typeInTicket?.id,
            'service_type': task.serviceType,
            'assistant_id': task.assistant?.id,
            'customer_id': task.customer?.id,
            'partner_phone': task.partnerPhone,
            // 'application_id': task.application?.id,
            'city_id': task.city?.id,
            'state_id': task.state?.id,
            'operator_name': task.operatorName,
            'operator_phone': task.operatorPhone,
            'machine_serial_number_id': task.machineSerialNumber?.id,
            'sma_status': task.smaStatus,
            'machine_category_id': task.machineCategory?.id,
            'product_id': task.product?.id,
            'component_id': task.component?.id,
            'component_lot_id': task.componentLot?.id,
            'delivery_date': task.deliveryDate != null
                ? rollbackParseDateTimeNoUtc(task.deliveryDate)
                : null,
            'is_break_down': task.isBreakDown == true ? 1 : 0,
            'is_warranty': task.isWarranty == true ? 1 : 0,
            'repair_time_hour': task.repairTimeHour,
            'repair_time_minute': task.repairTimeMinute,
            'actual_response_status': task.actualResponseStatus,
            'ftf': task.ftf == true ? 1 : 0,
            'resolution_within_std_time_bool':
                task.resoulutionWithinStdTimeBool == true ? 1 : 0,
            'standard_resolution_hour': task.standardResolutionHour,
            'description': task.description,
            'call_timing': task.callTiming != null
                ? rollbackParseDateTimeNoUtc(task.callTiming)
                : null,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return task.id;
    }
  }

  Future<List<TripProjectTaskRel>?> getTripProjectTaskRelAll() async {
    List<Map<String, dynamic>> result =
        await _db.query('trip_project_task_rel');
    List<Map<String, dynamic>> mutableResult = result
        .map(
          (map) => Map<String, dynamic>.from(map),
        )
        .toList();
    if (mutableResult.isNotEmpty) {
      return mutableResult
          .map(
            (taskMap) => TripProjectTaskRel.fromJson(taskMap),
          )
          .toList();
    } else {
      return null;
    }
  }

  Future<List<ProjectTaskRel>?> getProjectTaskRelAll() async {
    List<Map<String, dynamic>> result = await _db.query('project_task_rel');
    List<Map<String, dynamic>> mutableResult = result
        .map(
          (map) => Map<String, dynamic>.from(map),
        )
        .toList();
    if (mutableResult.isNotEmpty) {
      return mutableResult
          .map(
            (taskMap) => ProjectTaskRel.fromJson(taskMap),
          )
          .toList();
    } else {
      return null;
    }
  }

  Future<List<ProjectTaskRel>?> getProjectTaskRelByTaskId(int taskId) async {
    List<Map<String, dynamic>> result = await _db
        .query('project_task_rel', where: 'task_id = ?', whereArgs: [taskId]);
    List<Map<String, dynamic>> mutableResult = result
        .map(
          (map) => Map<String, dynamic>.from(map),
        )
        .toList();
    if (mutableResult.isNotEmpty) {
      return mutableResult
          .map(
            (taskMap) => ProjectTaskRel.fromJson(taskMap),
          )
          .toList();
    } else {
      return null;
    }
  }

  Future<List<TripProjectTaskRel>?> getTripProjectTaskRelByTaskId(
      int taskId) async {
    // Get the result from the database
    List<Map<String, dynamic>> result = await _db.query('trip_project_task_rel',
        where: 'task_id = ?', whereArgs: [taskId]);
    // Convert the result into a mutable list with mutable maps
    List<Map<String, dynamic>> mutableResult = result
        .map(
          (map) => Map<String, dynamic>.from(map),
        )
        .toList();
    if (mutableResult.isNotEmpty) {
      // Return the list of ProjectTask after processing the stages
      return mutableResult
          .map(
            (taskMap) => TripProjectTaskRel.fromJson(taskMap),
          )
          .toList();
    } else {
      return null;
    }
  }

  Future<List<TripProjectTask>?> getTripProjectTaskAll() async {
    // Get the result from the database
    List<Map<String, dynamic>> result =
        await _db.query('trip_project_tasks', orderBy: 'id DESC');
    // Convert the result into a mutable list with mutable maps
    List<Map<String, dynamic>> mutableResult = result
        .map(
          (map) => Map<String, dynamic>.from(map),
        )
        .toList();
    if (mutableResult.isNotEmpty) {
      // Use a standard for loop to handle async/await correctly
      for (var e in mutableResult) {
        e['timesheet_project_tasks'] = null;
        var timesheetProjectTasks =
            await getTimesheetProjectTaskByTaskId(e['id']);
        if (timesheetProjectTasks != null) {
          var arrayTpt = [];

          // Using a for-in loop with await
          for (var element in timesheetProjectTasks) {
            // ignore: prefer_interpolation_to_compose_strings
            arrayTpt.add(
              element.toJson(),
            );
          }

          // Setting the jsonEncoded array only once after processing
          e['timesheet_project_tasks'] = arrayTpt;
        }
      }

      // Return the list of ProjectTask after processing the stages
      return mutableResult
          .map(
            (taskMap) => TripProjectTask.fromJson(taskMap),
          )
          .toList();
    }

    return null;
  }

  Future<TripProjectTask?> getTripProjectTaskById(
      int? id, String? offId) async {
    String? whereClause;
    List<dynamic> whereArgs = [];
    if (id != null && offId != null) {
      whereClause = 'id = ? OR off_id = ?';
      whereArgs = [id, offId];
    } else if (id != null) {
      whereClause = 'id = ?';
      whereArgs = [id];
    } else if (offId != null) {
      whereClause = 'off_id = ?';
      whereArgs = [offId];
    } else {
      return null;
    }

    List<Map<String, dynamic>> result = await _db.query(
      'trip_project_tasks',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'id DESC',
    );

    // List<Map<String, dynamic>> result = await _db.query('trip_project_tasks',
    //     where: 'id = ? OR off_id = ?',
    //     whereArgs: [id, offId],
    //     orderBy: 'id DESC');
    // Convert the result into a mutable list with mutable maps
    List<Map<String, dynamic>> mutableResult = result
        .map(
          (map) => Map<String, dynamic>.from(map),
        )
        .toList();
    if (mutableResult.isNotEmpty) {
      for (var e in mutableResult) {
        e['timesheet_project_tasks'] = null;
        var timesheetProjectTasks =
            await getTimesheetProjectTaskByTaskId(e['id']);
        if (timesheetProjectTasks != null) {
          var arrayTpt = [];

          for (var element in timesheetProjectTasks) {
            arrayTpt.add(
              element.toJson(),
            );
          }
          e['timesheet_project_tasks'] = arrayTpt;
        }
      }

      // Return the list of ProjectTask after processing the stages
      return TripProjectTask.fromJson(mutableResult.first);
    }

    return null;
  }

  Future<List<ProjectTask>?> getProjectTaskAll() async {
    // Get the result from the database
    List<Map<String, dynamic>> result =
        await _db.query('project_tasks', orderBy: 'id DESC');
    // Convert the result into a mutable list with mutable maps
    List<Map<String, dynamic>> mutableResult = result
        .map(
          (map) => Map<String, dynamic>.from(map),
        )
        .toList();
    if (mutableResult.isNotEmpty) {
      // Use a standard for loop to handle async/await correctly
      for (var e in mutableResult) {
        e['stage'] = null;
        if (e['stage_id'] != null) {
          var stage = await getStageById(e['stage_id']);
          if (stage != null) {
            e['stage'] = stage.toJson(); // Modify the mutable map
          }
        }

        e['job_classification'] = null;
        if (e['job_classification_id'] != null) {
          var jobClassification =
              await getJobClassificationById(e['job_classification_id']);
          if (jobClassification != null) {
            e['job_classification'] =
                jobClassification.toJson(); // Modify the mutable map
          }
        }

        e['job_group'] = null;
        if (e['job_group_id'] != null) {
          var jobGroup = await getJobGroupById(e['job_group_id']);
          if (jobGroup != null) {
            e['job_group'] = jobGroup.toJson(); // Modify the mutable map
          }
        }

        e['function_group'] = null;
        if (e['function_group_id'] != null) {
          var jobGroup = await getFunctionGroupById(e['function_group_id']);
          if (jobGroup != null) {
            e['function_group'] = jobGroup.toJson(); // Modify the mutable map
          }
        }

        if (e['is_redo'] == 1) {
          e['is_redo'] = true;
        } else {
          e['is_redo'] = false;
        }

        e['type_in_ticket'] = null;
        if (e['type_in_ticket_id'] != null) {
          var typeInTicket =
              await getHelpdeskTicketTypeById(e['type_in_ticket_id']);
          if (typeInTicket != null) {
            e['type_in_ticket'] =
                typeInTicket.toJson(); // Modify the mutable map
          }
        }
        e['assistant'] = null;
        if (e['assistant_id'] != null) {
          var assistant =
              await _userLocalStorageService.getUserById(e['assistant_id']);
          if (assistant != null) {
            e['assistant'] = assistant.toJson(); // Modify the mutable map
          }
        }

        e['customer'] = null;
        if (e['customer_id'] != null) {
          var customer = await getCustomerById(e['customer_id']);
          if (customer != null) {
            e['customer'] = customer.toJson(); // Modify the mutable map
          }
        }

        e['application'] = null;
        if (e['application_id'] != null) {
          var application = await getApplicationById(e['application_id']);
          if (application != null) {
            e['application'] = application.toJson(); // Modify the mutable map
          }
        }

        e['city'] = null;
        if (e['city_id'] != null) {
          var city = await getCityById(e['city_id']);
          if (city != null) {
            e['city'] = city.toJson(); // Modify the mutable map
          }
        }

        e['state'] = null;
        if (e['state_id'] != null) {
          var state = await getCountryStateById(e['state_id']);
          if (state != null) {
            e['state'] = state.toJson(); // Modify the mutable map
          }
        }

        e['machine_serial_number'] = null;
        if (e['machine_serial_number_id'] != null) {
          var machineSerialNumber =
              await getStockProductionLotById(e['machine_serial_number_id']);
          if (machineSerialNumber != null) {
            e['machine_serial_number'] =
                machineSerialNumber.toJson(); // Modify the mutable map
          }
        }

        e['machine_category'] = null;
        if (e['machine_category_id'] != null) {
          var machineSerialNumber =
              await getProductCategoryById(e['machine_category_id']);
          if (machineSerialNumber != null) {
            e['machine_category'] =
                machineSerialNumber.toJson(); // Modify the mutable map
          }
        }

        e['component'] = null;
        if (e['component_id'] != null) {
          var component = await getProductById(e['component_id']);
          if (component != null) {
            e['component'] = component.toJson(); // Modify the mutable map
          }
        }

        e['component_lot'] = null;
        if (e['component_lot_id'] != null) {
          var machineSerialNumber =
              await getStockProductionLotById(e['component_lot_id']);
          if (machineSerialNumber != null) {
            e['component_lot'] =
                machineSerialNumber.toJson(); // Modify the mutable map
          }
        }

        if (e['is_break_down'] == 1) {
          e['is_break_down'] = true;
        } else {
          e['is_break_down'] = false;
        }

        if (e['is_warranty'] == 1) {
          e['is_warranty'] = true;
        } else {
          e['is_warranty'] = false;
        }

        if (e['ftf'] == 1) {
          e['ftf'] = true;
        } else {
          e['ftf'] = false;
        }

        if (e['resolution_within_std_time_bool'] == 1) {
          e['resolution_within_std_time_bool'] = true;
        } else {
          e['resolution_within_std_time_bool'] = false;
        }

        e['job_assign_lines'] = null;
        var jobAssignLines = await getJobAssignLineByTaskId(e['id']);
        if (jobAssignLines != null) {
          var array = [];

          // Using a for-in loop with await
          for (var element in jobAssignLines) {
            array.add(
              element.toJson(),
            );
          }

          // Setting the jsonEncoded array only once after processing
          e['job_assign_lines'] = array;
        }

        e['timesheet_project_tasks'] = null;
        var timesheetProjectTasks =
            await getTimesheetProjectTaskByTaskId(e['id']);
        if (timesheetProjectTasks != null) {
          var arrayTpt = [];

          // Using a for-in loop with await
          for (var element in timesheetProjectTasks) {
            // ignore: prefer_interpolation_to_compose_strings
            arrayTpt.add(
              element.toJson(),
            );
          }

          // Setting the jsonEncoded array only once after processing
          e['timesheet_project_tasks'] = arrayTpt;
        }

        e['overall_checkings'] = null;
        var overallCheckings = await getOverallCheckingByTaskId(e['id']);
        if (overallCheckings != null) {
          var arrayOC = [];

          // Using a for-in loop with await
          for (var element in overallCheckings) {
            arrayOC.add(
              element.toJson(),
            );
          }

          // Setting the jsonEncoded array only once after processing
          e['overall_checkings'] = arrayOC;
        }

        e['service_reports'] = null;
        var serviceReports = await getServiceReportByTaskId(e['id']);
        if (serviceReports != null) {
          var arraySR = [];

          // Using a for-in loop with await
          for (var element in serviceReports) {
            arraySR.add(
              element.toJson(),
            );
          }

          // Setting the jsonEncoded array only once after processing
          e['service_reports'] = arraySR;
        }

        e['job_finishes'] = null;
        var jobFinishes = await getJobFinishByTaskId(e['id']);
        if (jobFinishes != null) {
          var arraySR = [];

          // Using a for-in loop with await
          for (var element in jobFinishes) {
            arraySR.add(
              element.toJson(),
            );
          }

          // Setting the jsonEncoded array only once after processing
          e['job_finishes'] = arraySR;
        }

        e['product'] = null;
        if (e['product_id'] != null) {
          var product = await getProductById(e['product_id']);
          if (product != null) {
            e['product'] = product.toJson(); // Modify the mutable map
          }
        }

        e['job_analytics'] = null;
        var jobAnalytics = await getJobAnalyticByTaskId(e['id']);
        if (jobAnalytics != null) {
          var arrayJA = [];

          // Using a for-in loop with await
          for (var element in jobAnalytics) {
            arrayJA.add(
              element.toJson(),
            );
          }

          // Setting the jsonEncoded array only once after processing
          e['job_analytics'] = arrayJA;
        }

        // e['trip_project_task'] = null;
        // var tripProjectTas = await getTripProjectTaskId(e['id']);
        // if (tripProjectTas != null) {
        //   var arrayOC = [];

        //   // Using a for-in loop with await
        //   for (var element in tripProjectTas) {
        //     arrayOC.add(
        //       element.toJson(),
        //     );
        //   }

        //   // Setting the jsonEncoded array only once after processing
        //   e['trip_project_task'] = arrayOC;
        // }
      }

      // Return the list of ProjectTask after processing the stages
      return mutableResult
          .map(
            (taskMap) => ProjectTask.fromJson(taskMap),
          )
          .toList();
    }

    return null;
  }

  Future<ProjectTask?> getProjectTaskById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('project_tasks',
        where: 'id = ?', whereArgs: [id], limit: 1);

    List<Map<String, dynamic>> mutableResult = result
        .map(
          (map) => Map<String, dynamic>.from(map),
        )
        .toList();
    if (mutableResult.isNotEmpty) {
      // Use a standard for loop to handle async/await correctly
      for (var e in mutableResult) {
        e['stage'] = null;
        if (e['stage_id'] != null) {
          var stage = await getStageById(e['stage_id']);
          if (stage != null) {
            e['stage'] = stage.toJson(); // Modify the mutable map
          }
        }

        e['job_classification'] = null;
        if (e['job_classification_id'] != null) {
          var jobClassification =
              await getJobClassificationById(e['job_classification_id']);
          if (jobClassification != null) {
            e['job_classification'] =
                jobClassification.toJson(); // Modify the mutable map
          }
        }

        e['job_group'] = null;
        if (e['job_group_id'] != null) {
          var jobGroup = await getJobGroupById(e['job_group_id']);
          if (jobGroup != null) {
            e['job_group'] = jobGroup.toJson(); // Modify the mutable map
          }
        }

        e['function_group'] = null;
        if (e['function_group_id'] != null) {
          var jobGroup = await getFunctionGroupById(e['function_group_id']);
          if (jobGroup != null) {
            e['function_group'] = jobGroup.toJson(); // Modify the mutable map
          }
        }

        if (e['is_redo'] == 1) {
          e['is_redo'] = true;
        } else {
          e['is_redo'] = false;
        }

        e['type_in_ticket'] = null;
        if (e['type_in_ticket_id'] != null) {
          var typeInTicket =
              await getHelpdeskTicketTypeById(e['type_in_ticket_id']);
          if (typeInTicket != null) {
            e['type_in_ticket'] =
                typeInTicket.toJson(); // Modify the mutable map
          }
        }
        e['assistant'] = null;
        if (e['assistant_id'] != null) {
          var assistant =
              await _userLocalStorageService.getUserById(e['assistant_id']);
          if (assistant != null) {
            e['assistant'] = assistant.toJson(); // Modify the mutable map
          }
        }

        e['customer'] = null;
        if (e['customer_id'] != null) {
          var customer = await getCustomerById(e['customer_id']);
          if (customer != null) {
            e['customer'] = customer.toJson(); // Modify the mutable map
          }
        }

        e['application'] = null;
        if (e['application_id'] != null) {
          var application = await getApplicationById(e['application_id']);
          if (application != null) {
            e['application'] = application.toJson(); // Modify the mutable map
          }
        }

        e['city'] = null;
        if (e['city_id'] != null) {
          var city = await getCityById(e['city_id']);
          if (city != null) {
            e['city'] = city.toJson(); // Modify the mutable map
          }
        }

        e['state'] = null;
        if (e['state_id'] != null) {
          var state = await getCountryStateById(e['state_id']);
          if (state != null) {
            e['state'] = state.toJson(); // Modify the mutable map
          }
        }

        e['machine_serial_number'] = null;
        if (e['machine_serial_number_id'] != null) {
          var machineSerialNumber =
              await getStockProductionLotById(e['machine_serial_number_id']);
          if (machineSerialNumber != null) {
            e['machine_serial_number'] =
                machineSerialNumber.toJson(); // Modify the mutable map
          }
        }

        e['machine_category'] = null;
        if (e['machine_category_id'] != null) {
          var machineSerialNumber =
              await getProductCategoryById(e['machine_category_id']);
          if (machineSerialNumber != null) {
            e['machine_category'] =
                machineSerialNumber.toJson(); // Modify the mutable map
          }
        }

        e['component'] = null;
        if (e['component_id'] != null) {
          var component = await getProductById(e['component_id']);
          if (component != null) {
            e['component'] = component.toJson(); // Modify the mutable map
          }
        }

        e['component_lot'] = null;
        if (e['component_lot_id'] != null) {
          var machineSerialNumber =
              await getStockProductionLotById(e['component_lot_id']);
          if (machineSerialNumber != null) {
            e['component_lot'] =
                machineSerialNumber.toJson(); // Modify the mutable map
          }
        }

        if (e['is_break_down'] == 1) {
          e['is_break_down'] = true;
        } else {
          e['is_break_down'] = false;
        }

        if (e['is_warranty'] == 1) {
          e['is_warranty'] = true;
        } else {
          e['is_warranty'] = false;
        }

        if (e['ftf'] == 1) {
          e['ftf'] = true;
        } else {
          e['ftf'] = false;
        }

        if (e['resolution_within_std_time_bool'] == 1) {
          e['resolution_within_std_time_bool'] = true;
        } else {
          e['resolution_within_std_time_bool'] = false;
        }

        e['job_assign_lines'] = null;
        var jobAssignLines = await getJobAssignLineByTaskId(e['id']);
        if (jobAssignLines != null) {
          var array = [];

          // Using a for-in loop with await
          for (var element in jobAssignLines) {
            array.add(
              element.toJson(),
            );
          }

          // Setting the jsonEncoded array only once after processing
          e['job_assign_lines'] = array;
        }

        e['timesheet_project_tasks'] = null;
        var timesheetProjectTasks =
            await getTimesheetProjectTaskByTaskId(e['id']);
        if (timesheetProjectTasks != null) {
          var arrayTpt = [];

          // Using a for-in loop with await
          for (var element in timesheetProjectTasks) {
            // ignore: prefer_interpolation_to_compose_strings
            arrayTpt.add(
              element.toJson(),
            );
          }

          // Setting the jsonEncoded array only once after processing
          e['timesheet_project_tasks'] = arrayTpt;
        }

        e['overall_checkings'] = null;
        var overallCheckings = await getOverallCheckingByTaskId(e['id']);

        if (overallCheckings != null) {
          var arrayOC = [];

          // Using a for-in loop with await
          for (var element in overallCheckings) {
            arrayOC.add(
              element.toJson(),
            );
          }

          // Setting the jsonEncoded array only once after processing
          e['overall_checkings'] = arrayOC;
        }

        e['service_reports'] = null;
        var serviceReports = await getServiceReportByTaskId(e['id']);
        if (serviceReports != null) {
          var arraySR = [];

          // Using a for-in loop with await
          for (var element in serviceReports) {
            arraySR.add(
              element.toJson(),
            );
          }

          // Setting the jsonEncoded array only once after processing
          e['service_reports'] = arraySR;
        }

        e['job_finishes'] = null;
        var jobFinishes = await getJobFinishByTaskId(e['id']);
        if (jobFinishes != null) {
          var arraySR = [];

          // Using a for-in loop with await
          for (var element in jobFinishes) {
            arraySR.add(
              element.toJson(),
            );
          }

          // Setting the jsonEncoded array only once after processing
          e['job_finishes'] = arraySR;
        }

        e['product'] = null;
        if (e['product_id'] != null) {
          var product = await getProductById(e['product_id']);
          if (product != null) {
            e['product'] = product.toJson();
          }
        }

        e['job_analytics'] = null;
        var jobAnalytics = await getJobAnalyticByTaskId(e['id']);
        if (jobAnalytics != null) {
          var arrayJA = [];

          for (var element in jobAnalytics) {
            arrayJA.add(
              element.toJson(),
            );
          }

          e['job_analytics'] = arrayJA;
        }

        e['trip_ids'] = null;
        var tripProjectTask = await getTripProjectTaskId(e['id']);
        if (tripProjectTask != null) {
          var arraySR = [];

          for (var element in tripProjectTask) {
            arraySR.add(
              element.toJson(),
            );
          }

          e['service_reports'] = arraySR;
        }
      }
      return ProjectTask.fromJson(mutableResult.first);
    }
    return null;
  }

  Future<void> deleteProjectTask(int id) async {
    await LocalStorageService().init(); // Ensure database is initialized
    await _db.delete('project_tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteProjectTaskAll() async {
    await LocalStorageService().init(); // Ensure database is initialized
    await _db.delete('project_tasks');
  }

  Future<void> deleteTripProjectTaskAll() async {
    await LocalStorageService().init();
    await _db.delete('trip_project_tasks');
  }

  Future<void> deleteTripProjectTaskRelAll() async {
    await LocalStorageService().init();
    await _db.delete('trip_project_task_rel');
  }

  //Stage
  Future<int> saveStage(Stage stage) async {
    List<Map<String, dynamic>> result = await _db.query('stages',
        where: 'id = ?', whereArgs: [stage.id], limit: 1);

    if (result.isEmpty) {
      return await _db.insert(
          'stages',
          {
            'id': stage.id,
            'sequence': stage.sequence,
            'name': stage.name,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return stage.id;
    }
  }

  Future<void> deleteProjectTaskRelAll() async {
    await LocalStorageService().init();
    await _db.delete('project_task_rel');
  }

  Future<Stage?> getStageById(int id) async {
    List<Map<String, dynamic>> result =
        await _db.query('stages', where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return Stage.fromJson(result.first);
    }
    return null;
  }

  Future<List<Stage>?> getStages() async {
    List<Map<String, dynamic>> result =
        await _db.query('stages', orderBy: 'sequence');

    if (result.isNotEmpty) {
      List<Stage>? datas;
      datas = (result)
          .map(
            (i) => Stage.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();
      return datas;
    }
    return null;
  }

  // Job Classifications
  Future<int> saveJobClassification(JobClassification jc) async {
    List<Map<String, dynamic>> result = await _db.query('job_classifications',
        where: 'id = ?', whereArgs: [jc.id], limit: 1);

    if (result.isEmpty) {
      return await _db.insert(
          'job_classifications',
          {
            'id': jc.id,
            'name': jc.name,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return jc.id;
    }
  }

  Future<JobClassification?> getJobClassificationById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('job_classifications',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return JobClassification.fromJson(result.first);
    }
    return null;
  }

  // Job Group
  Future<int> saveJobGroup(JobGroup jc) async {
    List<Map<String, dynamic>> result = await _db.query('job_groups',
        where: 'id = ?', whereArgs: [jc.id], limit: 1);

    if (result.isEmpty) {
      return await _db.insert(
          'job_groups',
          {
            'id': jc.id,
            'name': jc.name,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return jc.id;
    }
  }

  Future<JobGroup?> getJobGroupById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('job_groups',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return JobGroup.fromJson(result.first);
    }
    return null;
  }

  // Fucntion Group
  Future<int> saveFunctionGroup(FunctionGroup jc) async {
    List<Map<String, dynamic>> result = await _db.query('function_groups',
        where: 'id = ?', whereArgs: [jc.id], limit: 1);

    if (result.isEmpty) {
      return await _db.insert(
          'function_groups',
          {
            'id': jc.id,
            'name': jc.name,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return jc.id;
    }
  }

  Future<FunctionGroup?> getFunctionGroupById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('function_groups',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return FunctionGroup.fromJson(result.first);
    }
    return null;
  }

  // Helpdesk Ticket Type
  Future<int> saveHelpdeskTicketType(HelpdeskTicketType jc) async {
    List<Map<String, dynamic>> result = await _db.query('helpdesk_ticket_types',
        where: 'id = ?', whereArgs: [jc.id], limit: 1, orderBy: 'sequence');

    if (result.isEmpty) {
      return await _db.insert(
          'helpdesk_ticket_types',
          {
            'id': jc.id,
            'sequence': jc.sequence,
            'name': jc.name,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return jc.id;
    }
  }

  Future<HelpdeskTicketType?> getHelpdeskTicketTypeById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('helpdesk_ticket_types',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return HelpdeskTicketType.fromJson(result.first);
    }
    return null;
  }

  // Custtomer
  Future<int> saveCustomer(Customer customer) async {
    List<Map<String, dynamic>> result = await _db.query('customers',
        where: 'id = ?', whereArgs: [customer.id], limit: 1, orderBy: 'name');

    if (result.isEmpty) {
      return await _db.insert(
          'customers',
          {
            'id': customer.id,
            'name': customer.name,
            'street': customer.street,
            'street2': customer.street2,
            'zip': customer.zip,
            'website': customer.website,
            'job_position': customer.jobPosition,
            'phone': customer.phone,
            'mobile': customer.mobile,
            'email': customer.email,
            'city_id': customer.city?.id,
            'state_id': customer.countryState?.id,
            'country_id': customer.country?.id,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return customer.id!;
    }
  }

  Future<Customer?> getCustomerById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('customers',
        where: 'id = ?', whereArgs: [id], limit: 1);
    List<Map<String, dynamic>> mutableResult = result
        .map(
          (map) => Map<String, dynamic>.from(map),
        )
        .toList();
    if (mutableResult.isNotEmpty) {
      mutableResult.first['city'] = null;
      if (mutableResult.first['city_id'] != null) {
        City? city = await getCityById(mutableResult.first['city_id']);
        mutableResult.first['city'] = city!.toJson();
      }
      mutableResult.first['state'] = null;
      if (mutableResult.first['state_id'] != null) {
        CountryState? countryState =
            await getCountryStateById(mutableResult.first['state_id']);
        mutableResult.first['state'] = countryState!.toJson();
      }
      mutableResult.first['country'] = null;
      if (mutableResult.first['country_id'] != null) {
        Country? country =
            await getCountryById(mutableResult.first['country_id']);
        mutableResult.first['country'] = country!.toJson();
      }
      Customer cust = Customer.fromJson(mutableResult.first);

      return cust;
    }
    return null;
  }

  // Country
  Future<int> saveCountry(Country country) async {
    List<Map<String, dynamic>> result = await _db.query('countries',
        where: 'id = ?', whereArgs: [country.id], limit: 1, orderBy: 'code');

    if (result.isEmpty) {
      return await _db.insert('countries', {
        'id': country.id,
        'name': country.name,
        'code': country.code,
      });
    } else {
      return country.id!;
    }
  }

  Future<Country?> getCountryById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('countries',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return Country.fromJson(result.first);
    }
    return null;
  }

  // CountryState
  Future<int> saveCountryState(CountryState country) async {
    List<Map<String, dynamic>> result = await _db.query('country_states',
        where: 'id = ?', whereArgs: [country.id], limit: 1, orderBy: 'code');

    if (result.isEmpty) {
      return await _db.insert(
          'country_states',
          {
            'id': country.id,
            'name': country.name,
            'code': country.code,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return country.id!;
    }
  }

  Future<CountryState?> getCountryStateById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('country_states',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return CountryState.fromJson(result.first);
    }
    return null;
  }

  // City
  Future<int> saveCity(City country) async {
    List<Map<String, dynamic>> result = await _db.query('cities',
        where: 'id = ?', whereArgs: [country.id], limit: 1, orderBy: 'name');
    if (result.isEmpty) {
      return await _db.insert(
          'cities',
          {
            'id': country.id,
            'name': country.name,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return country.id!;
    }
  }

  Future<City?> getCityById(int id) async {
    List<Map<String, dynamic>> result =
        await _db.query('cities', where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return City.fromJson(result.first);
    }
    return null;
  }

  // Machine Application
  Future<int> saveApplication(MachineApplication application) async {
    List<Map<String, dynamic>> result = await _db.query('machine_applications',
        where: 'id = ?',
        whereArgs: [application.id],
        limit: 1,
        orderBy: 'name');

    if (result.isEmpty) {
      return await _db.insert(
          'machine_applications',
          {
            'id': application.id,
            'name': application.name,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return application.id;
    }
  }

  Future<MachineApplication?> getApplicationById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('machine_applications',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return MachineApplication.fromJson(result.first);
    }
    return null;
  }

  // Stock Production Lot
  Future<int> saveStockProductionLot(
      StockProductionLot machineSerialNumber) async {
    List<Map<String, dynamic>> result = await _db.query('stock_production_lots',
        where: 'id = ?',
        whereArgs: [machineSerialNumber.id],
        limit: 1,
        orderBy: 'name');

    if (result.isEmpty) {
      return await _db.insert(
          'stock_production_lots',
          {
            'id': machineSerialNumber.id,
            'name': machineSerialNumber.name,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return machineSerialNumber.id;
    }
  }

  Future<StockProductionLot?> getStockProductionLotById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('stock_production_lots',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return StockProductionLot.fromJson(result.first);
    }
    return null;
  }

  // Product Category
  Future<int> saveProductCategory(ProductCategory machineSerialNumber) async {
    List<Map<String, dynamic>> result = await _db.query('product_categories',
        where: 'id = ?',
        whereArgs: [machineSerialNumber.id],
        limit: 1,
        orderBy: 'id');

    if (result.isEmpty) {
      return await _db.insert(
          'product_categories',
          {
            'id': machineSerialNumber.id,
            'complete_name': machineSerialNumber.completeName,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return machineSerialNumber.id;
    }
  }

  Future<ProductCategory?> getProductCategoryById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('product_categories',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return ProductCategory.fromJson(result.first);
    }
    return null;
  }

  // Website Category
  Future<int> saveWebsiteCategory(WebsiteCategory category) async {
    List<Map<String, dynamic>> result = await _db.query('website_categories',
        where: 'id = ?',
        whereArgs: [category.id],
        limit: 1,
        orderBy: 'sequence');

    if (result.isEmpty) {
      return await _db.insert('website_categories', {
        'id': category.id,
        'name': category.name,
        'complete_name': category.completeName,
        'parent_id': category.parentId,
        'parent_path': category.parentPath,
        'sequence': category.sequence,
        'count_product': category.countProduct,
        'total_count_product': category.totalCountProduct,
      });
    } else {
      return category.id;
    }
  }

  Future<WebsiteCategory?> getWebsiteCategoryById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('website_categories',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return WebsiteCategory.fromJson(result.first);
    }
    return null;
  }

  // Product
  Future<int> saveProduct(Product product) async {
    await deleteProduct(product.id);
    List<Map<String, dynamic>> result = await _db.query('products',
        where: 'id = ?', whereArgs: [product.id], limit: 1, orderBy: 'name');

    if (result.isEmpty) {
      return await _db.insert(
        'products',
        {
          'id': product.id,
          'name': product.name,
          'default_code': product.defaultCode,
          'text_desc': product.textDesc,
          'parameter': product.parameter,
          'features': product.features,
          'have_catalog': product.haveCatalog,
          'category_id': product.category?.id,
          'product_category_id': product.productCategory?.id,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      return product.id;
    }
  }

  Future<Product?> getProductById(int id) async {
    List<Map<String, dynamic>> result =
        await _db.query('products', where: 'id = ?', whereArgs: [id], limit: 1);
    List<Map<String, dynamic>> mutableResult = result
        .map(
          (map) => Map<String, dynamic>.from(map),
        )
        .toList();
    if (mutableResult.isNotEmpty) {
      mutableResult.first['category'] = null;
      if (mutableResult.first['category_id'] != null) {
        WebsiteCategory? category =
            await getWebsiteCategoryById(mutableResult.first['category_id']);
        mutableResult.first['category'] = category!.toJson();
      }
      mutableResult.first['product_category'] = null;
      if (mutableResult.first['product_category_id'] != null) {
        ProductCategory? countryState = await getProductCategoryById(
            mutableResult.first['product_category_id']);
        mutableResult.first['product_category'] = countryState!.toJson();
      }
      Product product = Product.fromJson(mutableResult.first);

      return product;
    }
    return null;
  }

  Future<void> deleteProduct(int id) async {
    await _db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // JobAssignLine
  Future<int> saveJobAssignLine(JobAssignLine line, int taskId) async {
    await deleteJobAssignLine(line.id!);
    List<Map<String, dynamic>> result = await _db.query('job_assign_lines',
        where: 'id = ?', whereArgs: [line.id], limit: 1, orderBy: 'id');

    if (result.isEmpty) {
      return await _db.insert('job_assign_lines', {
        'id': line.id,
        'mechanic_id': line.mechanic.id,
        'assigned_dt': line.assignedDt != null
            ? rollbackParseDateTimeNoUtc(line.assignedDt)
            : null,
        'accepted_dt': line.acceptedDt != null
            ? rollbackParseDateTimeNoUtc(line.acceptedDt)
            : null,
        'rejected_dt': line.rejectedDt != null
            ? rollbackParseDateTimeNoUtc(line.rejectedDt)
            : null,
        'reason': line.reason,
        'state': line.state,
        'project_task_id': taskId
      });
    } else {
      return line.id ?? 0;
    }
  }

  Future<List<JobAssignLine>?> getJobAssignLineByTaskId(int id) async {
    List<Map<String, dynamic>> result = await _db.query('job_assign_lines',
        where: 'project_task_id = ?', whereArgs: [id]);
    List<Map<String, dynamic>> mutableResult = result
        .map(
          (map) => Map<String, dynamic>.from(map),
        )
        .toList();
    if (mutableResult.isNotEmpty) {
      for (var i = 0; i < mutableResult.length; i++) {
        mutableResult[i]['mechanic'] = null;

        if (mutableResult[i]['mechanic_id'] != null) {
          User? mechanic = await _userLocalStorageService
              .getUserById(mutableResult[i]['mechanic_id']);
          if (mechanic != null) {
            mutableResult[i]['mechanic'] = mechanic.toJson();
          }
        }
      }
      List<JobAssignLine>? jobAssignLines;
      jobAssignLines = (mutableResult)
          .map(
            (i) => JobAssignLine.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();

      return jobAssignLines;
    }
    return null;
  }

  Future<void> deleteJobAssignLine(int id) async {
    await _db.delete('job_assign_lines', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteJobAssignLineAll() async {
    await _db.delete('job_assign_lines');
  }

  Future<int> updateJobAssignLine(int jobAssignId, String state, String reason,
      JobAssignLine jobAssignLine, String dtAction) async {
    return await _db.update(
      'job_assign_lines',
      {
        // 'mechanic_id': line.mechanic.id,
        // 'assigned_dt': line.assignedDt != null
        //     ? rollbackParseDateTimeNoUtc(line.assignedDt)
        //     : null,
        'accepted_dt': state == 'accept' ? dtAction : null,
        'rejected_dt': state == 'reject' ? dtAction : null,
        'reason': reason,
        'state': state,
        // 'project_task_id': taskId
      },
      where: 'id = ?',
      whereArgs: [jobAssignLine.id],
    );
  }

  // TimesheetProjectTask
  Future<int> saveTimesheetProjectTask(TimesheetProjectTask line) async {
    await deleteTimesheetProjectTask(line.id!);
    List<Map<String, dynamic>> result = await _db.query(
        'timesheet_project_tasks',
        where: 'id = ?',
        whereArgs: [line.id],
        limit: 1,
        orderBy: 'id');

    if (result.isEmpty) {
      return await _db.insert(
          'timesheet_project_tasks',
          {
            'id': line.id,
            'trip': line.trip,
            // 'trip_id': line.tripId,
            // 'trip_off_id': line.tripOffId,
            'total_mileage': line.totalMileage,
            'odometer_start': line.odometerStart,
            'odometer_end': line.odometerEnd,
            'dispatch_dt': line.dispatchDt != null
                ? rollbackParseDateTimeNoUtc(line.dispatchDt)
                : null,
            'arrival_at_site_dt': line.arrivalAtSiteDt != null
                ? rollbackParseDateTimeNoUtc(line.arrivalAtSiteDt)
                : null,
            'job_start_dt': line.jobStartDt != null
                ? rollbackParseDateTimeNoUtc(line.jobStartDt)
                : null,
            'job_complete_dt': line.jobCompleteDt != null
                ? rollbackParseDateTimeNoUtc(line.jobCompleteDt)
                : null,
            'leave_from_site_dt': line.leaveFromSiteDt != null
                ? rollbackParseDateTimeNoUtc(line.leaveFromSiteDt)
                : null,
            'arrive_at_office_dt': line.arriveAtOfficeDt != null
                ? rollbackParseDateTimeNoUtc(line.arriveAtOfficeDt)
                : null,
            'total_time_store': line.totalTimeStore,
            'off_id': line.offId,
            'project_task_id': line.projectTaskId,
            'fleet_id':
                line.fleetVehicle != null && line.fleetVehicle!.id != null
                    ? line.fleetVehicle!.id
                    : null,
            'dispatch_from': line.dispatchFrom,
            'arrive_at': line.arriveAt
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return line.id ?? 0;
    }
  }

  Future<int> saveTimesheetProjectTaskLite(
      TimesheetProjectTask data, int taskId, String codeLock) async {
    List<ProjectTaskRel>? dataLocalPTR =
        await getProjectTaskRelByTaskId(taskId);
    // await _db.insert('trip_project_tasks', {
    //   'id': dataTrip.id,
    //   'name': dataTrip.name,
    //   'dispatch_dt': dataTrip.dispatchDt != null
    //       ? rollbackParseDateTimeNoUtc(dataTrip.dispatchDt)
    //       : null,
    //   // 'arrival_at_site_dt': dataTrip.arrivalAtSiteDt != null
    //   //     ? rollbackParseDateTimeNoUtc(dataTrip.arrivalAtSiteDt)
    //   //     : null,
    //   // 'leave_from_site_dt': dataTrip.leaveFromSiteDt != null
    //   //     ? rollbackParseDateTimeNoUtc(dataTrip.leaveFromSiteDt)
    //   //     : null,
    //   'arrive_at_office_dt': dataTrip.arriveAtOfficeDt != null
    //       ? rollbackParseDateTimeNoUtc(dataTrip.arriveAtOfficeDt)
    //       : null,
    //   'total_mileage': dataTrip.totalMileage,
    //   'odometer_start': dataTrip.odometerStart,
    //   'odometer_end': dataTrip.odometerEnd,
    //   'fleet_id': dataTrip.fleetVehicle?.id,
    //   'small_paper_id': dataTrip.smallPaperId,
    //   'off_id': dataTrip.offId
    // });
    // await _db.insert('trip_project_task_rel', {
    //   'task_id': dataTripPTRel.taskId,
    //   'trip_id': dataTripPTRel.tripId,
    //   'trip_off_id': dataTripPTRel.tripOffId
    // });

    await _db.insert(
        'timesheet_project_tasks',
        {
          'trip': data.trip,
          // 'trip_id': data.tripId,
          'total_mileage': 0,
          'odometer_start': data.odometerStart,
          'odometer_end': 0,
          'dispatch_dt': data.dispatchDt != null
              ? rollbackParseDateTimeNoUtc(data.dispatchDt)
              : null,
          'total_time_store': 0,
          'off_id': data.offId,
          'project_task_id': taskId,
          'fleet_id': data.fleetVehicle?.id,
          // 'trip_off_id': dataTrip.offId,
          'dispatch_from': data.dispatchFrom
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
    var timesheetInserted = 1;
    if (dataLocalPTR != null) {
      for (var ptr in dataLocalPTR) {
        var trip = 1;
        var offId = '${ptr.relatedTaskId.toString()}-$codeLock';
        var timesheets =
            await getTimesheetProjectTaskByTaskId(ptr.relatedTaskId!);
        if (timesheets != null) {
          for (var timesheet in timesheets) {
            // if (timesheet.offId != null) {
            //   offId = timesheet.offId!;
            // }
            if (timesheet.trip != null) {
              if (trip <= timesheet.trip!) {
                trip = timesheet.trip! + 1;
              }
            }
          }
        }
        try {
          // await _db.insert('trip_project_task_rel', {
          //   'task_id': dataTripPTRel.taskId,
          //   'trip_id': ptr.relatedTaskId,
          //   'trip_off_id': dataTripPTRel.tripOffId
          // });
          await _db.insert(
              'timesheet_project_tasks',
              {
                'trip': trip,
                // 'trip_id': data.tripId,
                'total_mileage': 0,
                'odometer_start': data.odometerStart,
                'odometer_end': 0,
                'dispatch_dt': data.dispatchDt != null
                    ? rollbackParseDateTimeNoUtc(data.dispatchDt)
                    : null,
                'total_time_store': 0,
                'off_id': offId,
                'project_task_id': ptr.relatedTaskId,
                'fleet_id': data.fleetVehicle?.id,
                // 'trip_off_id': dataTrip.offId,
                'dispatch_from': data.dispatchFrom
              },
              conflictAlgorithm: ConflictAlgorithm.replace);
        } catch (e) {
          timesheetInserted = 0;
        }
      }
    }

    return timesheetInserted;
  }

  Future<List<TimesheetProjectTask>?> getTimesheetProjectTaskByTaskId(
      int id) async {
    List<Map<String, dynamic>> result = await _db.query(
        'timesheet_project_tasks',
        where: 'project_task_id = ?',
        whereArgs: [id],
        orderBy: 'trip DESC');
    List<Map<String, dynamic>> mutableResult = result
        .map(
          (map) => Map<String, dynamic>.from(map),
        )
        .toList();

    if (mutableResult.isNotEmpty) {
      for (var i = 0; i < mutableResult.length; i++) {
        mutableResult[i]['fleet'] = null;
        if (mutableResult[i]['fleet_id'] != null) {
          FleetVehicle? fleet =
              await getFleetVehicleById(mutableResult[i]['fleet_id']);
          mutableResult[i]['fleet'] = fleet!.toJson();
          mutableResult[i]['pause_continue'] = null;
          List<PauseContinue>? pauseContinue =
              await getPauseContinueByTaskId(mutableResult[i]['id']);
          if (pauseContinue != null) {
            var array = [];

            // Using a for-in loop with await
            for (var element in pauseContinue) {
              array.add(
                element.toJson(),
              );
            }

            // Setting the jsonEncoded array only once after processing
            mutableResult[i]['pause_continue'] = array;
          }
        }
      }
      List<TimesheetProjectTask>? tpts;
      tpts = (mutableResult)
          .map(
            (i) => TimesheetProjectTask.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();
      return tpts;
    }
    return null;
  }

  Future<void> deleteTimesheetProjectTask(int id) async {
    await _db
        .delete('timesheet_project_tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteTimesheetProjectTaskAll() async {
    await _db.delete('timesheet_project_tasks');
  }

  Future<int> updateTimesheetProjectTask(
      TimesheetProjectTask line, int taskId) async {
    return await _db.update(
      'timesheet_project_tasks',
      {
        'trip': line.trip,
        'total_mileage': line.totalMileage,
        'odometer_start': line.odometerStart,
        'odometer_end': line.odometerEnd,
        'dispatch_dt': line.dispatchDt != null
            ? rollbackParseDateTimeNoUtc(line.dispatchDt)
            : null,
        'arrival_at_site_dt': line.arrivalAtSiteDt != null
            ? rollbackParseDateTimeNoUtc(line.arrivalAtSiteDt)
            : null,
        'job_start_dt': line.jobStartDt != null
            ? rollbackParseDateTimeNoUtc(line.jobStartDt)
            : null,
        'job_complete_dt': line.jobCompleteDt != null
            ? rollbackParseDateTimeNoUtc(line.jobCompleteDt)
            : null,
        'leave_from_site_dt': line.leaveFromSiteDt != null
            ? rollbackParseDateTimeNoUtc(line.leaveFromSiteDt)
            : null,
        'arrive_at_office_dt': line.arriveAtOfficeDt != null
            ? rollbackParseDateTimeNoUtc(line.arriveAtOfficeDt)
            : null,
        'total_time_store': line.totalTimeStore,
        'off_id': line.offId,
        'project_task_id': taskId,
        'fleet_id': line.fleetVehicle != null && line.fleetVehicle!.id != null
            ? line.fleetVehicle!.id
            : null,
        'dispatch_from': line.dispatchFrom,
        'arrive_at': line.arriveAt
      },
      where: '(off_id = ? AND off_id != null) OR id = ?',
      whereArgs: [line.offId, line.id],
    );
  }

  Future<int> updateTripProjectTask(TripProjectTask line) async {
    return await _db.update(
      'trip_project_tasks',
      {
        'total_mileage': line.totalMileage,
        'odometer_start': line.odometerStart,
        'odometer_end': line.odometerEnd,
        'dispatch_dt': line.dispatchDt != null
            ? rollbackParseDateTimeNoUtc(line.dispatchDt)
            : null,
        // 'arrival_at_site_dt': line.arrivalAtSiteDt != null
        //     ? rollbackParseDateTimeNoUtc(line.arrivalAtSiteDt)
        //     : null,
        // 'leave_from_site_dt': line.leaveFromSiteDt != null
        //     ? rollbackParseDateTimeNoUtc(line.leaveFromSiteDt)
        //     : null,
        'arrive_at_office_dt': line.arriveAtOfficeDt != null
            ? rollbackParseDateTimeNoUtc(line.arriveAtOfficeDt)
            : null,
      },
      where: '(off_id = ? AND off_id != null) OR id = ?',
      whereArgs: [line.offId, line.id],
    );
  }

  // OverallChecking
  Future<int> saveOverallChecking(OverallChecking line, int taskId) async {
    await deleteOverallChecking(line.id);
    List<Map<String, dynamic>> result = await _db.query('overall_checkings',
        where: 'id = ?', whereArgs: [line.id], limit: 1, orderBy: 'id');

    if (result.isEmpty) {
      return await _db.insert('overall_checkings', {
        'id': line.id,
        'tab_overall_checking_id': line.tabOverallCheckingId,
        'check_datetime': line.checkDatetime != null
            ? rollbackParseDateTimeNoUtc(line.checkDatetime)
            : null,
        'current_machine_hour': line.currentMachineHour,
        'current_machine_km': line.currentMachineKm,
        'note': line.note,
        'off_id': line.offId,
        'project_task_id': taskId
      });
    } else {
      return line.id;
    }
  }

  Future<int> saveOverallCheckingLite(
      Map<String, dynamic> line, int taskId, String imagePaths) async {
    return await _db.insert('overall_checkings', {
      'tab_overall_checking_id': taskId,
      'check_datetime': rollbackParseDateTimeNoUtc(
        DateTime.now(),
      ),
      'current_machine_hour': line['current_machine_hour'] ?? 0,
      'current_machine_km': line['current_machine_km'] ?? 0,
      'note': line['note'],
      'off_id': '$taskId-oc-${DateTime.now().toIso8601String()}',
      'project_task_id': taskId,
      'image_paths': imagePaths
    });
  }

  Future<List<OverallChecking>?> getOverallCheckingByTaskId(int id) async {
    List<Map<String, dynamic>> result = await _db.query('overall_checkings',
        where: 'project_task_id = ?', whereArgs: [id], orderBy: 'id');
    if (result.isNotEmpty) {
      List<OverallChecking>? overallCheckings;
      overallCheckings = (result)
          .map(
            (i) => OverallChecking.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();
      return overallCheckings;
    }
    return null;
  }

  Future<void> deleteOverallChecking(int id) async {
    await _db.delete('overall_checkings', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteOverallCheckingAll() async {
    await _db.delete('overall_checkings');
  }

  // ServiceReport
  Future<int> saveServiceReport(ServiceReport line, int taskId) async {
    await deleteServiceReport(line.id);
    List<Map<String, dynamic>> result = await _db.query('service_reports',
        where: 'id = ?', whereArgs: [line.id], limit: 1, orderBy: 'id');

    if (result.isEmpty) {
      return await _db.insert('service_reports', {
        'id': line.id,
        'service_report_project_id': line.serviceReportProjectId,
        'date':
            line.date != null ? rollbackParseDateTimeNoUtc(line.date) : null,
        'service_report': line.serviceReport,
        'problem': line.problem,
        'root_cause': line.rootCause,
        'action': line.action,
        'off_id': line.offId,
        'project_task_id': taskId
      });
    } else {
      return line.id;
    }
  }

  Future<int> saveServiceReportLite(
      Map<String, dynamic> line, int taskId, String imagePaths) async {
    return await _db.insert('service_reports', {
      'service_report_project_id': taskId,
      'date': rollbackParseDateTimeNoUtc(
        DateTime.now(),
      ),
      'service_report': line['service_report'],
      'problem': line['problem'],
      'root_cause': line['root_cause'],
      'action': line['action'],
      'off_id': '$taskId-oc-${DateTime.now().toIso8601String()}',
      'project_task_id': taskId,
      'image_paths': imagePaths
    });
  }

  Future<List<ServiceReport>?> getServiceReportByTaskId(int id) async {
    List<Map<String, dynamic>> result = await _db.query('service_reports',
        where: 'project_task_id = ?', whereArgs: [id], orderBy: 'id');
    if (result.isNotEmpty) {
      List<ServiceReport>? overallCheckings;
      overallCheckings = (result)
          .map(
            (i) => ServiceReport.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();
      return overallCheckings;
    }
    return null;
  }

  //Trip project task
  Future<List<TripProjectTask>?> getTripProjectTaskId(int id) async {
    List<Map<String, dynamic>> result = await _db.query('trip_project_tasks',
        where: 'id = ?', whereArgs: [id], orderBy: 'id');
    if (result.isNotEmpty) {
      List<TripProjectTask>? tripProjectTasks;
      tripProjectTasks = (result)
          .map(
            (i) => TripProjectTask.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();
      return tripProjectTasks;
    }
    return null;
  }

  Future<void> deleteServiceReport(int id) async {
    await _db.delete('service_reports', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteServiceReportAll() async {
    await _db.delete('service_reports');
  }

  // JobFinish
  Future<int> saveJobFinish(JobFinish line, int taskId) async {
    await deleteJobFinish(line.id);
    List<Map<String, dynamic>> result = await _db.query('job_finishes',
        where: 'id = ?', whereArgs: [line.id], limit: 1, orderBy: 'id');

    if (result.isEmpty) {
      return await _db.insert('job_finishes', {
        'id': line.id,
        'finish_datetime': line.finishDatetime != null
            ? rollbackParseDateTimeNoUtc(line.finishDatetime)
            : null,
        'customer_satisfied': line.customerSatisfied,
        'customer_comment': line.customerComment,
        'service_recommendation': line.serviceRecommendation,
        'customer_name': line.customerName,
        'phone': line.phone,
        'off_id': line.offId,
        'project_task_id': taskId
      });
    } else {
      return line.id;
    }
  }

  //Trip Project Task
  Future<int> saveTripProjectTask(TripProjectTask line) async {
    await deleteTripProjectTask(line.id!);
    if (line.timesheetProjectTasks != null &&
        line.timesheetProjectTasks!.isNotEmpty) {
      for (var i = 0; i < line.timesheetProjectTasks!.length; i++) {
        if (line.timesheetProjectTasks![i].pauseContinue != null &&
            line.timesheetProjectTasks![i].pauseContinue!.isNotEmpty) {
          for (var j = 0;
              j < line.timesheetProjectTasks![i].pauseContinue!.length;
              j++) {
            if (line.timesheetProjectTasks![i].pauseContinue![j].userPause !=
                null) {
              await _userLocalStorageService.saveUser(
                  line.timesheetProjectTasks![i].pauseContinue![j].userPause!);
            }
            if (line.timesheetProjectTasks![i].pauseContinue![j].userContinue !=
                null) {
              await _userLocalStorageService.saveUser(line
                  .timesheetProjectTasks![i].pauseContinue![j].userContinue!);
            }
            await savePauseContinue(
                line.timesheetProjectTasks![i].pauseContinue![j]);
          }
        }
        if (line.timesheetProjectTasks![i].fleetVehicle != null &&
            line.timesheetProjectTasks![i].fleetVehicle!.id != null) {
          if (line.timesheetProjectTasks![i].fleetVehicle!.model != null &&
              line.timesheetProjectTasks![i].fleetVehicle!.model!.id != null) {
            if (line.timesheetProjectTasks![i].fleetVehicle!.model!.brand !=
                    null &&
                line.timesheetProjectTasks![i].fleetVehicle!.model!.brand!.id !=
                    null) {
              await saveBrand(
                  line.timesheetProjectTasks![i].fleetVehicle!.model!.brand!);
            }
            await saveModel(
                line.timesheetProjectTasks![i].fleetVehicle!.model!);
          }
          await saveFleetVehicle(line.timesheetProjectTasks![i].fleetVehicle!);
        }
        await saveTimesheetProjectTask(line.timesheetProjectTasks![i]);
      }
    }
    List<Map<String, dynamic>> result = await _db.query('trip_project_tasks',
        where: 'id = ?', whereArgs: [line.id], limit: 1, orderBy: 'id');
    if (result.isEmpty) {
      try {
        var insert = await _db.insert('trip_project_tasks', {
          'id': line.id,
          'name': line.name,
          'dispatch_dt': line.dispatchDt != null
              ? rollbackParseDateTimeNoUtc(line.dispatchDt)
              : null,
          // 'arrival_at_site_dt': line.arrivalAtSiteDt != null
          //     ? rollbackParseDateTimeNoUtc(line.arrivalAtSiteDt)
          //     : null,
          // 'leave_from_site_dt': line.leaveFromSiteDt != null
          //     ? rollbackParseDateTimeNoUtc(line.leaveFromSiteDt)
          //     : null,
          'arrive_at_office_dt': line.arriveAtOfficeDt != null
              ? rollbackParseDateTimeNoUtc(line.arriveAtOfficeDt)
              : null,
          'total_mileage': line.totalMileage,
          'odometer_start': line.odometerStart,
          'odometer_end': line.odometerEnd,
          'fleet_id': line.fleetVehicle,
          'small_paper_id': line.smallPaperId,
          'off_id': line.offId,
        });
        return insert;
      } catch (e, stackTrace) {
        return 0;
      }
    } else {
      return line.id!;
    }
  }

  Future<int> saveTripProjectTaskRel(TripProjectTaskRel rel) async {
    await deleteTripProjectTaskRel(rel.taskId!, rel.tripId!);
    List<Map<String, dynamic>> result = await _db.query('trip_project_task_rel',
        where: 'task_id = ? AND trip_id = ?',
        whereArgs: [rel.taskId!, rel.tripId!],
        limit: 1,
        orderBy: 'task_id');
    if (result.isEmpty) {
      return await _db.insert('trip_project_task_rel',
          {'task_id': rel.taskId, 'trip_id': rel.tripId});
    } else {
      return 0;
    }
  }

  Future<int> saveProjectTaskRel(ProjectTaskRel rel) async {
    await deleteProjectTaskRel(rel.taskId!, rel.relatedTaskId!);
    List<Map<String, dynamic>> result = await _db.query('project_task_rel',
        where: 'task_id = ? AND related_task_id = ?',
        whereArgs: [rel.taskId!, rel.relatedTaskId!],
        limit: 1,
        orderBy: 'task_id');

    if (result.isEmpty) {
      return await _db.insert('project_task_rel',
          {'task_id': rel.taskId, 'related_task_id': rel.relatedTaskId});
    } else {
      return 0;
    }
  }

  Future<int> saveJobFinishLite(Map<String, dynamic> line, int taskId,
      Map<String, String> imagePaths) async {
    return await _db.insert('job_finishes', {
      'finish_datetime': rollbackParseDateTimeNoUtc(
        DateTime.now(),
      ),
      'customer_satisfied': line['customer_satisfied'],
      'customer_comment': line['customer_comment'],
      'service_recommendation': line['service_recommendation'],
      'customer_name': line['customer_name'],
      'phone': line['phone'],
      'off_id': line['off_id'],
      'project_task_id': taskId,
      'image_path': imagePaths['sign'],
      'mechanic_signature_path': imagePaths['mechanic_sign']
    });
  }

  Future<List<JobFinish>?> getJobFinishByTaskId(int id) async {
    List<Map<String, dynamic>> result = await _db.query('job_finishes',
        where: 'project_task_id = ?', whereArgs: [id], orderBy: 'id');
    if (result.isNotEmpty) {
      List<JobFinish>? overallCheckings;
      overallCheckings = (result)
          .map(
            (i) => JobFinish.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();
      return overallCheckings;
    }
    return null;
  }

  Future<void> deleteJobFinish(int id) async {
    await _db.delete('job_finishes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteJobFinishAll() async {
    await _db.delete('job_finishes');
  }

  // JobAnalytic
  Future<int> saveJobAnalytic(JobAnalytic line, int taskId) async {
    await deleteJobAnalytic(line.id);
    List<Map<String, dynamic>> result = await _db.query(
      'job_analytics',
      where: 'id = ?',
      whereArgs: [line.id],
      limit: 1,
      orderBy: 'id',
    );

    if (result.isEmpty) {
      await _db.insert('job_analytics', {
        'id': line.id,
        'service_job_point': line.serviceJobPoint,
        'action_date': line.actionDate != null
            ? rollbackParseDateTimeNoUtc(line.actionDate)
            : null,
        'note': line.note,
        'system_id': line.system?.id,
        'phenomenon_id': line.phenomenon?.id,
        'action_id': line.action?.id,
        'project_task_id': taskId,
      });
    }

    if (line.actionsBy != null && line.actionsBy!.isNotEmpty) {
      for (final user in line.actionsBy!) {
        await _db.insert('job_analytics_actions_by', {
          'job_analytic_id': line.id,
          'user_id': user.id,
        });
      }
    }

    return line.id;
  }

  Future<List<JobAnalytic>?> getJobAnalyticByTaskId(int id) async {
    List<Map<String, dynamic>> result = await _db
        .query('job_analytics', where: 'project_task_id = ?', whereArgs: [id]);
    List<Map<String, dynamic>> mutableResult = result
        .map(
          (map) => Map<String, dynamic>.from(map),
        )
        .toList();
    if (mutableResult.isNotEmpty) {
      for (var i = 0; i < mutableResult.length; i++) {
        mutableResult[i]['system'] = null;
        if (mutableResult[i]['system_id'] != null) {
          SystemComponent? system =
              await getSystemComponentById(mutableResult[i]['system_id']);
          mutableResult[i]['system'] = system!.toJson();
        }
        mutableResult[i]['phenomenon'] = null;
        if (mutableResult[i]['phenomenon_id'] != null) {
          Phenomenon? phenomenon =
              await getPhenomenonById(mutableResult[i]['phenomenon_id']);
          mutableResult[i]['phenomenon'] = phenomenon!.toJson();
        }
        mutableResult[i]['action'] = null;
        if (mutableResult[i]['action_id'] != null) {
          FsAction? action =
              await getFsActionById(mutableResult[i]['action_id']);
          mutableResult[i]['action'] = action!.toJson();
        }

        int jobAnalyticId = mutableResult[i]['id'];
        // Add related users
        List<Map<String, dynamic>> userMaps = await _db.query(
          'job_analytics_actions_by',
          where: 'job_analytic_id = ?',
          whereArgs: [jobAnalyticId],
        );

        List<User> users = [];
        for (var userMap in userMaps) {
          User? user =
              await _userLocalStorageService.getUserById(userMap['user_id']);
          if (user != null) {
            users.add(user);
          }
        }

        mutableResult[i]['actions_by'] = users.map((e) => e.toJson()).toList();

        // mutableResult[i]['action_id'] = null;
        // if (mutableResult[i]['action_id_id'] != null) {
        //   User? actionId = await _userLocalStorageService
        //       .getUserById(mutableResult[i]['action_id_id']);
        //   mutableResult[i]['action_id'] = actionId!.toJson();
        // }
      }
      List<JobAnalytic>? jobAnalytics;
      jobAnalytics = (mutableResult)
          .map(
            (i) => JobAnalytic.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();

      return jobAnalytics;
    }
    return null;
  }

  Future<void> deleteJobAnalytic(int id) async {
    await _db.delete('job_analytics_actions_by',
        where: 'job_analytic_id = ?', whereArgs: [id]);

    await _db.delete('job_analytics', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteJobAnalyticAll() async {
    await _db.delete('job_analytics');
  }

  Future<void> deleteTripProjectTask(int id) async {
    await _db.delete('trip_project_tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteTripProjectTaskRel(int ptId, int tripId) async {
    await _db.delete('trip_project_task_rel',
        where: 'task_id = ? AND trip_id = ?', whereArgs: [ptId, tripId]);
  }

  Future<void> deleteProjectTaskRel(int taskId, int relatedTaskId) async {
    await _db.delete('project_task_rel',
        where: 'task_id = ? AND related_task_id = ?',
        whereArgs: [taskId, relatedTaskId]);
  }

  // SystemComponent
  Future<int> saveSystemComponent(SystemComponent line) async {
    List<Map<String, dynamic>> result = await _db.query('system_components',
        where: 'id = ?', whereArgs: [line.id], limit: 1, orderBy: 'name');

    if (result.isEmpty) {
      return await _db.insert(
          'system_components',
          {
            'id': line.id,
            'name': line.name,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return line.id;
    }
  }

  Future<SystemComponent?> getSystemComponentById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('system_components',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return SystemComponent.fromJson(result.first);
    }
    return null;
  }

  Future<List<SystemComponent>?> getSystemComponents() async {
    List<Map<String, dynamic>> result =
        await _db.query('system_components', orderBy: 'name');

    if (result.isNotEmpty) {
      List<SystemComponent>? datas;
      datas = (result)
          .map(
            (i) => SystemComponent.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();
      return datas;
    }
    return null;
  }

  // Phenomenon
  Future<int> savePhenomenon(Phenomenon line) async {
    List<Map<String, dynamic>> result = await _db.query('phenomenons',
        where: 'id = ?', whereArgs: [line.id], limit: 1, orderBy: 'name');

    if (result.isEmpty) {
      return await _db.insert('phenomenons', {
        'id': line.id,
        'name': line.name,
      });
    } else {
      return line.id;
    }
  }

  Future<Phenomenon?> getPhenomenonById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('phenomenons',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return Phenomenon.fromJson(result.first);
    }
    return null;
  }

  Future<List<Phenomenon>?> getPhenomenons() async {
    List<Map<String, dynamic>> result =
        await _db.query('phenomenons', orderBy: 'name');

    if (result.isNotEmpty) {
      List<Phenomenon>? datas;
      datas = (result)
          .map(
            (i) => Phenomenon.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();
      return datas;
    }
    return null;
  }

  // FsAction
  Future<int> saveFsAction(FsAction line) async {
    List<Map<String, dynamic>> result = await _db.query('fs_actions',
        where: 'id = ?', whereArgs: [line.id], limit: 1, orderBy: 'name');

    if (result.isEmpty) {
      return await _db.insert(
          'fs_actions',
          {
            'id': line.id,
            'name': line.name,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return line.id;
    }
  }

  Future<FsAction?> getFsActionById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('fs_actions',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return FsAction.fromJson(result.first);
    }
    return null;
  }

  Future<List<FsAction>?> getFsActions() async {
    List<Map<String, dynamic>> result =
        await _db.query('fs_actions', orderBy: 'name');

    if (result.isNotEmpty) {
      List<FsAction>? datas;
      datas = (result)
          .map(
            (i) => FsAction.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();
      return datas;
    }
    return null;
  }

  // Brand
  Future<int> saveBrand(FleetVehicleBrand line) async {
    List<Map<String, dynamic>> result = await _db.query(
        'fleet_vehicle_model_brands',
        where: 'id = ?',
        whereArgs: [line.id],
        limit: 1,
        orderBy: 'name');

    if (result.isEmpty) {
      return await _db.insert(
          'fleet_vehicle_model_brands',
          {
            'id': line.id,
            'name': line.name,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return line.id!;
    }
  }

  Future<FleetVehicleBrand?> getBrandById(int id) async {
    List<Map<String, dynamic>> result = await _db.query(
        'fleet_vehicle_model_brands',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1);

    if (result.isNotEmpty) {
      return FleetVehicleBrand.fromJson(result.first);
    }
    return null;
  }

  // Model
  Future<int> saveModel(FleetVehicleModel line) async {
    List<Map<String, dynamic>> result = await _db.query('fleet_vehicle_models',
        where: 'id = ?', whereArgs: [line.id], limit: 1, orderBy: 'name');

    if (result.isEmpty) {
      return await _db.insert(
          'fleet_vehicle_models',
          {
            'id': line.id,
            'name': line.name,
            'brand_id': line.brand != null && line.brand!.id != null
                ? line.brand!.id
                : null
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return line.id != null ? line.id! : 0;
    }
  }

  Future<FleetVehicleModel?> getModelById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('fleet_vehicle_models',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return FleetVehicleModel.fromJson(result.first);
    }
    return null;
  }

  // FleetVehicle
  Future<int> saveFleetVehicle(FleetVehicle line) async {
    List<Map<String, dynamic>> result = await _db.query('fleet_vehicles',
        where: 'id = ?', whereArgs: [line.id], limit: 1, orderBy: 'name');

    if (result.isEmpty) {
      return await _db.insert(
          'fleet_vehicles',
          {
            'id': line.id,
            'name': line.name,
            'license_plate': line.licensePlate,
            'odometer': line.odometer,
            'model_id': line.model != null && line.model!.id != null
                ? line.model!.id
                : null
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return line.id != null ? line.id! : 0;
    }
  }

  Future<FleetVehicle?> getFleetVehicleById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('fleet_vehicles',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      return FleetVehicle.fromJson(result.first);
    }
    return null;
  }

  Future<List<FleetVehicle>?> getFleetVehicles() async {
    List<Map<String, dynamic>> result =
        await _db.query('fleet_vehicles', orderBy: 'name');

    if (result.isNotEmpty) {
      List<FleetVehicle>? datas;
      datas = (result)
          .map(
            (i) => FleetVehicle.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();
      return datas;
    }
    return null;
  }

  // PauseContinue
  Future<int> savePauseContinue(PauseContinue line) async {
    List<Map<String, dynamic>> result = await _db.query('pause_continues',
        where: 'id = ?', whereArgs: [line.id], limit: 1, orderBy: 'id');

    if (result.isEmpty) {
      return await _db.insert('pause_continues', {
        'id': line.id,
        'timesheet_task_project_id': line.timesheetId,
        'pause_dt': line.pauseDt != null
            ? rollbackParseDateTimeNoUtc(line.pauseDt)
            : null,
        'continue_dt': line.continueDt != null
            ? rollbackParseDateTimeNoUtc(line.continueDt)
            : null,
        'off_id': line.offId
      });
    } else {
      return line.id ?? 0;
    }
  }

  Future<List<PauseContinue>?> getPauseContinueByTaskId(int id) async {
    List<Map<String, dynamic>> result = await _db.query('pause_continues',
        where: 'timesheet_task_project_id = ?', whereArgs: [id]);
    List<Map<String, dynamic>> mutableResult = result
        .map(
          (map) => Map<String, dynamic>.from(map),
        )
        .toList();
    if (mutableResult.isNotEmpty) {
      for (var i = 0; i < mutableResult.length; i++) {
        mutableResult[i]['user_pause'] = null;
        if (mutableResult[i]['user_pause_id'] != null) {
          User? userPause = await _userLocalStorageService
              .getUserById(mutableResult[i]['user_pause_id']);
          mutableResult[i]['user_pause'] = userPause!.toJson();
        }
        mutableResult[i]['user_continue'] = null;
        if (mutableResult[i]['user_continue_id'] != null) {
          User? userContinue = await _userLocalStorageService
              .getUserById(mutableResult[i]['user_continue_id']);
          mutableResult[i]['user_continue'] = userContinue!.toJson();
        }
      }
      List<PauseContinue>? pauseContinue;
      pauseContinue = (mutableResult)
          .map(
            (i) => PauseContinue.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();

      return pauseContinue;
    }
    return null;
  }

  // StaticSelection SJP
  Future<int> saveStaticSelectionSJP(StaticSelection line) async {
    List<Map<String, dynamic>> result = await _db.query(
        'selection_service_job_points',
        where: 'id = ?',
        whereArgs: [line.id],
        limit: 1,
        orderBy: 'name');

    if (result.isEmpty) {
      return await _db.insert(
          'selection_service_job_points',
          {
            'id': line.id,
            'name': line.name,
            'value': line.value,
            'sequence': line.sequence
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return line.id;
    }
  }

  Future<List<StaticSelection>?> getStaticSelectionSJP() async {
    List<Map<String, dynamic>> result =
        await _db.query('selection_service_job_points', orderBy: 'sequence');

    if (result.isNotEmpty) {
      List<StaticSelection>? datas;
      datas = (result)
          .map(
            (i) => StaticSelection.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();
      return datas;
    }
    return null;
  }

  // StaticSelection CS
  Future<int> saveStaticSelectionCS(StaticSelection line) async {
    List<Map<String, dynamic>> result = await _db.query(
        'selection_customer_satisfieds',
        where: 'id = ?',
        whereArgs: [line.id],
        limit: 1,
        orderBy: 'name');

    if (result.isEmpty) {
      return await _db.insert(
          'selection_customer_satisfieds',
          {
            'id': line.id,
            'name': line.name,
            'value': line.value,
            'sequence': line.sequence
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return line.id;
    }
  }

  Future<List<StaticSelection>?> getStaticSelectionCS() async {
    List<Map<String, dynamic>> result =
        await _db.query('selection_customer_satisfieds', orderBy: 'sequence');

    if (result.isNotEmpty) {
      List<StaticSelection>? datas;
      datas = (result)
          .map(
            (i) => StaticSelection.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();
      return datas;
    }
    return null;
  }

  // StaticSelection JAL S
  Future<int> saveStaticSelectionJALStatus(StaticSelection line) async {
    List<Map<String, dynamic>> result = await _db.query(
        'selection_job_assign_line_status',
        where: 'id = ?',
        whereArgs: [line.id],
        limit: 1,
        orderBy: 'name');

    if (result.isEmpty) {
      return await _db.insert(
          'selection_job_assign_line_status',
          {
            'id': line.id,
            'name': line.name,
            'value': line.value,
            'sequence': line.sequence
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return line.id;
    }
  }

  Future<List<StaticSelection>?> getStaticSelectionJALStatus() async {
    List<Map<String, dynamic>> result = await _db
        .query('selection_job_assign_line_status', orderBy: 'sequence');

    if (result.isNotEmpty) {
      List<StaticSelection>? datas;
      datas = (result)
          .map(
            (i) => StaticSelection.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();
      return datas;
    }
    return null;
  }
}
