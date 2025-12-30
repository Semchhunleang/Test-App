import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/crm/city/city.dart';
import 'package:umgkh_mobile/models/crm/country_state/country_state.dart';
import 'package:umgkh_mobile/models/crm/customer/customer.dart';
import 'package:umgkh_mobile/models/e-catalog/product/product.dart';
import 'package:umgkh_mobile/models/service-project_task/call_to_customer/call_to_customer.dart';
import 'package:umgkh_mobile/models/service-project_task/job_analytic/job_analytic.dart';
import 'package:umgkh_mobile/models/service-project_task/job_assign_line/job_assign_line.dart';
import 'package:umgkh_mobile/models/service-project_task/job_finish/job_finish.dart';
import 'package:umgkh_mobile/models/service-project_task/overall_checking/overall_checking.dart';
import 'package:umgkh_mobile/models/service-project_task/product_category/product_category.dart';
import 'package:umgkh_mobile/models/service-project_task/service_report/service_report.dart';
import 'package:umgkh_mobile/models/service-project_task/stage/stage.dart';
import 'package:umgkh_mobile/models/service-project_task/stock_production_lot/stock_production_lot.dart';
import 'package:umgkh_mobile/models/service-project_task/timesheet_project_task/timesheet_project_task.dart';
import 'package:umgkh_mobile/models/service-project_task/workshop/timesheet_workshop.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class ProjectTask {
  final int id;
  final String? jobOrderNo;
  final String name;
  final Stage? stage;
  final DateTime? datetime;
  final String? jobOrderType;
  final DateTime? closeDateTime;
  final String? cause;
  final DateTime? jobFinishDatetime;
  final bool? isRedo;
  final String? serviceType;
  final User? assistant;
  final String? priorityTicket;
  final Customer? customer;
  final String? partnerPhone;
  final City? city;
  final CountryState? state;
  final String? operatorName;
  final String? operatorPhone;
  final StockProductionLot? machineSerialNumber;
  final String? smaStatus;
  final ProductCategory? machineCategory;
  final Product? product;
  final Product? component;
  final StockProductionLot? componentLot;
  final DateTime? deliveryDate;
  final bool? isBreakDown;
  final bool? isWarranty;
  final bool? ftf;
  final String? mttrStatus;
  final bool? resoulutionWithinStdTimeBool;
  final double? standardResolutionHour;
  final String? description;
  final DateTime? callTiming;
  final List<JobAssignLine>? jobAssignLines;
  final List<CallToCustomer>? callToCustomers;
  final List<TimesheetProjectTask>? timesheetProjectTasks;
  final List<TimesheetWorkshop>? timesheetWorkshop;
  final int? repairTimeHour;
  final int? repairTimeMinute;
  final String? actualResponseStatus;
  final List<OverallChecking>? overallCheckings;
  final List<ServiceReport>? serviceReports;
  final List<JobFinish>? jobFinishes;
  final List<JobAnalytic>? jobAnalytics;

  ProjectTask({
    required this.id,
    this.jobOrderNo,
    required this.name,
    this.stage,
    this.datetime,
    this.jobOrderType,
    this.closeDateTime,
    this.cause,
    this.jobFinishDatetime,
    this.isRedo,
    this.serviceType,
    this.assistant,
    this.priorityTicket,
    this.customer,
    this.partnerPhone,
    this.city,
    this.state,
    this.operatorName,
    this.operatorPhone,
    this.machineSerialNumber,
    this.smaStatus,
    this.machineCategory,
    this.product,
    this.component,
    this.componentLot,
    this.deliveryDate,
    this.isBreakDown,
    this.isWarranty,
    this.repairTimeHour,
    this.repairTimeMinute,
    this.actualResponseStatus,
    this.ftf,
    this.mttrStatus,
    this.resoulutionWithinStdTimeBool,
    this.standardResolutionHour,
    this.description,
    this.jobAssignLines,
    this.callToCustomers,
    this.timesheetProjectTasks,
    this.timesheetWorkshop,
    this.overallCheckings,
    this.serviceReports,
    this.jobFinishes,
    this.jobAnalytics,
    this.callTiming,
  });

  factory ProjectTask.fromJson(Map<String, dynamic> json) {
    Stage? stage = json['stage'] != null && json['stage']['id'] != null
        ? Stage.fromJson(json['stage'])
        : null;

    User? assistant =
        json['assistant'] != null ? User.fromJson(json['assistant']) : null;

    Customer? customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;

    // MachineApplication? application = json['application'] != null
    //     ? MachineApplication.fromJson(json['application'])
    //     : null;

    City? city = json['city'] != null ? City.fromJson(json['city']) : null;

    CountryState? state =
        json['state'] != null ? CountryState.fromJson(json['state']) : null;

    StockProductionLot? machineSerialNumber =
        json['machine_serial_number'] != null
            ? StockProductionLot.fromJson(json['machine_serial_number'])
            : null;

    ProductCategory? machineCategory = json['machine_category'] != null
        ? ProductCategory.fromJson(json['machine_category'])
        : null;

    Product? product =
        json['product'] != null ? Product.fromJson(json['product']) : null;

    Product? component =
        json['component'] != null ? Product.fromJson(json['component']) : null;

    StockProductionLot? componentLot = json['component_lot'] != null
        ? StockProductionLot.fromJson(json['component_lot'])
        : null;

    List<JobAssignLine>? jobAssignLines = json['job_assign_lines'] != null
        ? (json['job_assign_lines'] as List)
            .map(
              (i) => JobAssignLine.fromJson(
                Map<String, dynamic>.from(i),
              ),
            )
            .toList()
        : null;
    List<CallToCustomer>? callToCustomers = json['call_to_customer'] != null
        ? (json['call_to_customer'] as List)
            .map(
              (i) => CallToCustomer.fromJson(
                Map<String, dynamic>.from(i),
              ),
            )
            .toList()
        : null;

    List<TimesheetProjectTask>? timesheetProjectTasks =
        json['timesheet_project_tasks'] != null
            ? (json['timesheet_project_tasks'] as List)
                .map(
                  (i) => TimesheetProjectTask.fromJson(
                    Map<String, dynamic>.from(i),
                  ),
                )
                .toList()
            : null;

    List<TimesheetWorkshop>? timesheetWorkshop =
        json['timesheet_workshop'] != null
            ? (json['timesheet_workshop'] as List)
                .map(
                  (i) => TimesheetWorkshop.fromJson(
                    Map<String, dynamic>.from(i),
                  ),
                )
                .toList()
            : null;

    List<OverallChecking>? overallCheckings = json['overall_checkings'] != null
        ? (json['overall_checkings'] as List)
            .map(
              (i) => OverallChecking.fromJson(
                Map<String, dynamic>.from(i),
              ),
            )
            .toList()
        : null;

    List<ServiceReport>? serviceReports = json['service_reports'] != null
        ? (json['service_reports'] as List)
            .map(
              (i) => ServiceReport.fromJson(
                Map<String, dynamic>.from(i),
              ),
            )
            .toList()
        : null;

    List<JobFinish>? jobFinishes = json['job_finishes'] != null
        ? (json['job_finishes'] as List)
            .map(
              (i) => JobFinish.fromJson(
                Map<String, dynamic>.from(i),
              ),
            )
            .toList()
        : null;

    List<JobAnalytic>? jobAnalytics = json['job_analytics'] != null
        ? (json['job_analytics'] as List)
            .map(
              (i) => JobAnalytic.fromJson(
                Map<String, dynamic>.from(i),
              ),
            )
            .toList()
        : null;

    String? mttrStatus = '';
    if (json['close_datetime'] != null && json['call_timing'] != null) {
      if ((parseDateTime(json['close_datetime'])
              .difference(
                parseDateTime(json['call_timing']),
              )
              .inDays) <
          10) {
        mttrStatus = "ontime";
      } else {
        mttrStatus = "late";
      }
    } else {
      mttrStatus = "onprogress";
    }

    return ProjectTask(
      id: json['id'],
      jobOrderNo: json['job_order_no'],
      name: json['name'],
      stage: stage,
      datetime: parseDateTime(json['datetime']),
      jobOrderType: json['job_order_type'],
      closeDateTime: parseDateTime(json['close_datetime']),
      cause: json['cause'],
      jobFinishDatetime: parseDateTime(json['job_finish_datetime']),
      isRedo: json['is_redo'],
      serviceType: json['service_type'],
      assistant: assistant,
      priorityTicket: json['priority_ticket'],
      customer: customer,
      partnerPhone: json['partner_phone'],
      city: city,
      state: state,
      operatorName: json['operator_name'],
      operatorPhone: json['operator_phone'],
      machineSerialNumber: machineSerialNumber,
      smaStatus: json['sma_status'],
      machineCategory: machineCategory,
      product: product,
      component: component,
      componentLot: componentLot,
      deliveryDate: parseDateTime(json['delivery_date']),
      isBreakDown: json['is_break_down'],
      isWarranty: json['is_warranty'],
      repairTimeHour: json['repair_time_hour'],
      repairTimeMinute: json['repair_time_minute'],
      actualResponseStatus: json['actual_response_status'],
      ftf: json['ftf'],
      mttrStatus: mttrStatus,
      resoulutionWithinStdTimeBool: json['resolution_within_std_time_bool'],
      standardResolutionHour: json['standard_resolution_hour'] != null
          ? json['standard_resolution_hour'].toDouble()
          : 0.0,
      description: json['description'],
      jobAssignLines: jobAssignLines,
      callToCustomers: callToCustomers,
      timesheetProjectTasks: timesheetProjectTasks,
      timesheetWorkshop: timesheetWorkshop,
      overallCheckings: overallCheckings,
      serviceReports: serviceReports,
      jobFinishes: jobFinishes,
      jobAnalytics: jobAnalytics,
      callTiming: parseDateTime(json['call_timing']),
    );
  }
}
