class Constants {
  static const String ip = 'http://96.x.xx.xxx:7200';
  static const String baseUrl = 'http://96.x.xx.xxx:7200/api';
  // Auth
  static const String loginUrl = '$baseUrl/users/login';
  static const String refreshTokenUrl = '$baseUrl/token/refresh-token';
  static const String updatePasswordUrl = '$baseUrl/users/update-password';

  // Utils
  static const String carouselUrl = '$baseUrl/util/carousel';
  static const String profilepictureUrl = '$baseUrl/util/profile-picture';
  static String fsPicture(int attId) =>
      '$baseUrl/util/field-service-picture/$attId';
  static String smallPaperpicture(int spId, int attId) =>
      '$baseUrl/util/small-paper-picture/$spId/$attId';
  static String attachmentById(int id) =>
      '$baseUrl/util/ir-attachment-by-id/$id';
  static String attachmentFileById(int id) =>
      '$baseUrl/util/ir-attachment-file-by-id/$id';
  static String privacyPolicy =
      "https://umg-cambodia.com/news/privacy-policy-for-nenam-mobile-app";

  // User
  static const String getUserByToken = '$baseUrl/users';
  static const String registerFace = '$baseUrl/users/face-update';
  // Attendance
  static const String getAttendanceByToken = '$baseUrl/attendance/user';
  static const String checkIn = '$baseUrl/attendance/check-in';
  static const String checkOutMorning = '$baseUrl/attendance/check-out-morning';
  static const String checkInAfternoon =
      '$baseUrl/attendance/check-in-afternoon';
  static const String checkOut = '$baseUrl/attendance/check-out';
  // Firabese Token
  static const String insertFCMToken = '$baseUrl/firebase-token';
  // leave
  static const String getLeaveByToken = '$baseUrl/leave';
  static const String getLeaveByTokenDH = '$baseUrl/leave/dh';
  static const String getLeaveByDept = '$baseUrl/leave/by-dept';
  static const String insertLeave = '$baseUrl/leave';
  static const String updateLeaveState = '$baseUrl/leave/update-status';

  // leave Type
  static const String getLeaveTypeByTokenAndCondition = '$baseUrl/leave-type';
  // public holiday
  static const String getPublicHoliday = '$baseUrl/leave/public-holiday';

  // Request Overtime
  static String getRequestOvertime(int year) =>
      '$baseUrl/request-overtime/$year';
  static const submitRequestOvertime = '$baseUrl/request-overtime';
  static const submitMultiRequestOvertime = '$baseUrl/request-overtime/multi';
  // emp Overtime
  static const String getEmpoyeeOt = '$baseUrl/employee-overtime';
  static const String submitEmployeeOvertime =
      '$baseUrl/employee-overtime/multi';
  static const String attendanceByEmp =
      '$baseUrl/attendance/employee-and-overtime-date';
  //Approve Request OT
  static String getApproveRequestOT(int year) =>
      '$baseUrl/approve-request-overtime/$year';
  static const submitApprovalRequestOvertime =
      '$baseUrl/approve-request-overtime';
  static const batchApprovalRequestOvertime =
      '$baseUrl/approve-request-overtime/batch-ot';
  // Check is DH
  static const String getAccessLevel = '$baseUrl/access-levels';
  //Approve Employee OT
  static String getApproveEmployeeOT(int year) =>
      '$baseUrl/approve-employee-overtime/$year';
  static String getApproveEmployeeOvertimeHR(int year) =>
      '$baseUrl/approve-employee-overtime/hr/$year';
  static const submitApprovalEmployeeOvertime =
      '$baseUrl/approve-employee-overtime';
  static const String getAnnouncement = '$baseUrl/announcement';

  //A4 under level
  static const String createA4UnderLevel = '$baseUrl/a4-under-level';
  static const String getA4Data = '$baseUrl/a4-under-level';
  static String getImageA4(int transactionId, String resField) =>
      '$baseUrl/util/a4-image/$transactionId/$resField';

  //CRM Lead
  static const String getCountry = '$baseUrl/base/country';
  static const String getCountryState = '$baseUrl/base/state';
  static const String getSaleTeam = '$baseUrl/crm/sale-team';
  static const String getCustomer = '$baseUrl/crm/customer';
  static const String createLead = '$baseUrl/crm/create-lead';
  static const String updateLead = '$baseUrl/crm/update-lead';
  static const String convertToOpportunity =
      '$baseUrl/crm/convert-to-opportunity';
  static const String getLeadByServiceType = '$baseUrl/crm/lead';
  static const String getActivity = '$baseUrl/crm/activity';
  static const String getSchedule = '$baseUrl/crm/schedule';
  static const String getActivityType = '$baseUrl/crm/activity-type';
  static const String createActivity = '$baseUrl/crm-activity';
  static const String createSchedule = '$baseUrl/crm-activity/schedule';
  static const String getStages = '$baseUrl/base/stage';
  static const String leadActivityPicture =
      '$baseUrl/util/lead-activity-picture';
  static String leadActivityPictureSeto(String leadId, String attId) =>
      '$baseUrl/util/lead-activity-picture/$leadId/$attId';
  static const String scheduleByUser = '$baseUrl/crm/schedule-by-user';
  static const String activityByUser = '$baseUrl/crm/activity-by-user';

  //CRM Opportunities
  static String getOpportunity(String serviceType) =>
      '$baseUrl/crm/opportunity/$serviceType';
  static const String createOpportunity = '$baseUrl/crm/create-opportunity';
  static const String updateOpportunity = '$baseUrl/crm/update-opportunity';

  //CMS
  static const String getIsoOjective1 = '$baseUrl/base/iso-ojective1';
  static const String getIsoOjective2 = '$baseUrl/base/iso-ojective2';
  static const String getSheetProblem = '$baseUrl/base/sheet-problem';
  static const String getImprovScope = '$baseUrl/base/improv-scope';
  static const String updateStateA4 = '$baseUrl/cms/state';
  static const String insertA4 = '$baseUrl/cms/a4';
  static String getDocumentNumber(String type) =>
      '$baseUrl/base/document-number/$type';
  static const String getProductBrand = '$baseUrl/base/product-brand';
  static const String getTsbProductCateg = '$baseUrl/base/tsb-product-categ';
  static const String getEngineModel = '$baseUrl/base/engine-model';
  static const String getComponentGroup = '$baseUrl/base/component-group';
  static const String getProductModel = '$baseUrl/base/product-model';
  static const String getStockProductionLot =
      '$baseUrl/base/stock-production-lot';
  static const String getTypePart = '$baseUrl/base/type-part';
  static const String getProduct = '$baseUrl/base/product';
  //TSB
  static const String getTSB = '$baseUrl/cms/tsb';
  static String getImageTsb(int transactionId, String resField) =>
      '$baseUrl/util/tsb-image/$transactionId/$resField';
  static const String updateStateTsb = '$baseUrl/cms/tsb/state';
  static const String insertTSB = '$baseUrl/cms/tsb';
  static String getTsbLine(int id) => '$baseUrl/cms/tsb-line/$id';
  static const String insertTSBLine = '$baseUrl/cms/tsb-line';
  // e-catalog
  static const String getWebsiteCategory = '$baseUrl/website-category';
  static String getProductByCategory(int id) => '$baseUrl/product/category/$id';
  static String getPDF(int id, String routeName) =>
      '$baseUrl/util/$routeName/$id';
  static String getProductPicture(int id) =>
      '$baseUrl/util/product-picture/$id';
  static String getWebCatPicture(int id) => '$baseUrl/util/webc-picture/$id';
  // for multi image detail e-catalog
  static String getimagesPicture(int proId) => '$baseUrl/product/images/$proId';
  static String getPictureProduct(int imageId) =>
      '$baseUrl/util/product-image/$imageId';

  //AM
  static const String allSmallPaper = '$baseUrl/am/all-small-paper';
  static const String smallPaperByUser = '$baseUrl/am/small-paper-by-user';
  static const String smallPaperById = '$baseUrl/am/small-paper-by-id';
  static const String createSmallPaper = '$baseUrl/am/create-small-paper';
  static const String updateSmallPaper = '$baseUrl/am/update-small-paper';
  // static const String smallPaperpicture = '$baseUrl/util/small-paper-picture';
  static const String updateDoneSmallPaper =
      '$baseUrl/am/update-done-small-paper';
  static const String getAllVehicleCheck = '$baseUrl/am/all-vehicle-check';
  static String getVehicleCheckById(int id) =>
      '$baseUrl/am/vehicle-check-by-id/$id';
  static const String getAllEmployee = '$baseUrl/am/selection-employee';
  static const String getFleetVehicle = '$baseUrl/am/selection-fleet-vehicle';
  static const String createVehicleCheck = '$baseUrl/am/create-vehicle-check';
  static const String updateVehicleCheck = '$baseUrl/am/update-vehicle-check';
  static String updateRowsById(int id) => '$baseUrl/am/update-rows/$id';
  static String updateRowInoutById(int id) =>
      '$baseUrl/am/update-rows-inout/$id';
  static String scheduleTruckDriver = '$baseUrl/schedule-truck-driver';

  // field-service
  static const String fs = 'field-service';
  static const String getFieldService = '$baseUrl/$fs';
  static const String updateJobAssignState = '$baseUrl/$fs/job-assign-state';
  static const String createOverallChecking = '$baseUrl/$fs/overall-checking';
  static const String createServiceReport = '$baseUrl/$fs/service-report';
  static const String createJobFinish = '$baseUrl/$fs/job-finish';
  static const String createJobAnalytic = '$baseUrl/$fs/job-analytic';
  static String getFieldServiceLite = '$baseUrl/field-service/lite-v2';
  static const String createTrip = '$baseUrl/$fs/trip';
  static const String createTimesheet = '$baseUrl/$fs/timesheet';
  static const String pauseContinue = '$baseUrl/$fs/pause-continue';
  static const String stageFieldService = '$baseUrl/$fs/stage-field-service';
  static const String timesheetWorkshop = '$baseUrl/$fs/timesheet-workshop';
  static const String callToCustomer = '$baseUrl/$fs/call-to-customer';

  // base
  static const String getServicesStage = '$baseUrl/base/services-stage';
  static const String getSystemComponent = '$baseUrl/base/system-component';
  static const String getFSPhenomenon = '$baseUrl/base/fs-phenomenon';
  static const String getFSAction = '$baseUrl/base/fs-action';
  static const String getJALStatus = '$baseUrl/base/job-assign-line-status';
  static const String getCustomerSatisfied = '$baseUrl/base/customer-satisfied';
  static const String getServiceJobPoint = '$baseUrl/base/service-job-point';
  static const String getJobAssignLineStatus =
      '$baseUrl/base/job-assign-line-status';
  static const String getUMGSocialMedia = '$baseUrl/base/umg-social-media';
  static const String getDepartment = '$baseUrl/base/department';
  static const String getNenamVersion = '$baseUrl/base/nenam-version';
  static const String getNenamStoreLink = '$baseUrl/base/nenam-store-link';
  static const String getDispatchFrom = '$baseUrl/base/dispatch-from';
  static const String getArriveAt = '$baseUrl/base/arrive-at';
  static const String getScheduleTruckDriverState =
      '$baseUrl/base/schedule-truck-driver-state';
  static const String getScheduleTruckDriverTag =
      '$baseUrl/base/schedule-truck-driver-tag';

  // supporthub
  static const String getSupoortHubState = '$baseUrl/base/supporthub-state';
  static const String getSupoortHubICTPriority =
      '$baseUrl/base/supporthub-ict-priority';
  static const String getSupoortHubICTRequestCategory =
      '$baseUrl/base/supporthub-ict-request-category';
  static const String getSupoortHubICTDevice =
      '$baseUrl/base/supporthub-ict-device';
  static const String getSupportHubContactType =
      '$baseUrl/base/supporthub-contact-type';
  static const String getSupoortHubMarketingProductType =
      '$baseUrl/base/supporthub-marketing-product-type';

  // offline-sync
  static const String offlineSync = 'offline-sync';
  static const String offlineSyncJobAssignLine =
      '$baseUrl/$offlineSync/update-status-job-assign-line';
  static const String offlineSyncInsertTimesheet =
      '$baseUrl/$offlineSync/insert-timesheet';
  static const String offlineSyncInsertTripAndRel =
      '$baseUrl/$offlineSync/insert-trip-and-rel';
  static const String offlineSyncUpdateTrip =
      '$baseUrl/$offlineSync/update-trip';
  static const String offlineSyncUpdateTimesheet =
      '$baseUrl/$offlineSync/update-timesheet';
  static const String offlineSyncInsertOverallChecking =
      '$baseUrl/$offlineSync/insert-overall-checking';
  static const String offlineSyncServiceReportChecking =
      '$baseUrl/$offlineSync/insert-service-report';
  static const String offlineSyncJobFinish =
      '$baseUrl/$offlineSync/insert-job-finish';

  // supporthub-ticket
  static const String st = '$baseUrl/supporthub-ticket';
  static const String getRequestContact = '$st/request-contact';
  static const String createRequestContact = '$st/create-request-contact';
  static const String updateRequestContact = '$st/update-request-contact';
  static const String deleteSTI = '$st/delete-supporthub-ticket-image';
  static const String checkOutsideWorkingHour = '$st/outside-working-hour';
  static const String getAllRequestTicketErp =
      '$st/all-request-contact-product/';
  // ict
  static const String createRequestICTTicket = '$st/create-request-ict-ticket';
  static const String updateRequestICTTicket = '$st/update-request-ict-ticket';
  static const String getICTTicketByRequestor =
      '$st/get-ict-ticket-by-requestor';
  //Marketing
  static const String getMarketingTicketByRequestor =
      '$st/get-marketing-ticket-by-requestor';
  static const String createRequestMarketingTicket =
      '$st/create-request-marketing-ticket';
  static const String updateRequestMarketingTicket =
      '$st/update-request-marketing-ticket';

  // notifications
  static const String notif = '$baseUrl/firebase-message';
  static const String notifList = notif;
  static const String updateNotifIsRead = '$notif/is-read';
  static const String updateNotifIsReadAll = '$notif/is-read-all';
  static const String updateNotifArchiveById = '$notif/archive-by-id';
  static const String updateNotifArchiveAll = '$notif/archive-all';

  // log note
  static const String logNote = '$baseUrl/log-note';
  static const String createLogNoteByModel = '$logNote/create-by-model';
  static const String getLogNoteByModel = '$logNote/get-by-model';

  // ir attachment
  static const String ia = '$baseUrl/ir-attachment';
  static const String deleteAttachment = '$ia/delete-by-id';

  // PLM
  static const String plm = '$baseUrl/plm';
  static const String getPLMSalesAchievement = '$plm/plm-sales-achievement';
  static const String getMonthlyDeptPLMSalse =
      '$plm/monthly-department-plm-sales-achievement';
  // PLM Supporting
  static const String plmSupporting = '$baseUrl/plm-supporting';
  static const String getMonthlyPLMTargetSupporting =
      '$plmSupporting/monthly-plm-employee-target';
  static const String getMonthlyPLMAchievementSupporting =
      '$plmSupporting/monthly-plm-employee-achievement';
  static const String updateDailyPLMEmployee =
      '$plmSupporting/update-monthly-plm-employee-achievement-daily';
  static const String updateWeeklyPLMEmployee =
      '$plmSupporting/update-monthly-plm-employee-achievement-weekly';
  static const String updateMonthlyPLMEmployee =
      '$plmSupporting/update-monthly-plm-employee-achievement-monthly';

  // Visual Board
  static const String vb = '$baseUrl/visual-board';
  static const String getVisualBoardByDept = '$vb/visual-board-by-department';
  static const String getVisualBoardStage = '$vb/visual-board-stage';
  static const String updateSequenceVB = '$vb/update-sequence';

  // Survey
  static const String survey = '$baseUrl/survey';
}
