import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umgkh_mobile/utils/launch_utils.dart';
import 'package:umgkh_mobile/view_models/app_info_view_model.dart';
import 'package:umgkh_mobile/view_models/nenam_version_view_model.dart';
import 'package:umgkh_mobile/view_models/plm/plm_sales/plm_sales_monthly_dept_view_model.dart';
import 'package:umgkh_mobile/view_models/plm/plm_sales/plm_sales_view_model.dart';
import 'package:umgkh_mobile/view_models/plm/plm_supporting/monthly_plm_achievement_form_view_model.dart';
import 'package:umgkh_mobile/view_models/plm/plm_supporting/monthly_plm_achievement_view_model.dart';
import 'package:umgkh_mobile/view_models/plm/plm_supporting/monthly_plm_target_form_view_model.dart';
import 'package:umgkh_mobile/view_models/plm/plm_supporting/monthly_plm_target_view_model.dart';
import 'package:umgkh_mobile/view_models/schedule_truck_driver_form_view_model.dart';
import 'package:umgkh_mobile/view_models/schedule_truck_driver_view_model.dart';
import 'package:umgkh_mobile/view_models/share_widget_view_model.dart';
import 'package:umgkh_mobile/view_models/supporthub/ict_team/ict_ticket_form_view_model.dart';
import 'package:umgkh_mobile/view_models/supporthub/ict_team/ict_ticket_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_form_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_view_model.dart';
import 'package:umgkh_mobile/view_models/a4_all_level_form_view_model.dart';
import 'package:umgkh_mobile/view_models/notification_view_model.dart';
import 'package:umgkh_mobile/view_models/supporthub/erp_team/request_contact_product_form_view_model.dart';
import 'package:umgkh_mobile/view_models/supporthub/erp_team/request_contact_product_view_model.dart';
import 'package:umgkh_mobile/view_models/supporthub/marketing_team/marketing_ticket_form_view_model.dart';
import 'package:umgkh_mobile/view_models/supporthub/marketing_team/marketing_ticket_view_model.dart';
import 'package:umgkh_mobile/view_models/visual_board/visual_board_form_view_model.dart';
import 'package:umgkh_mobile/view_models/visual_board/visual_board_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/survey/index.dart';
import 'package:umgkh_mobile/views/pages/supporthub/erp_team/request/contact/form.dart';
import 'package:umgkh_mobile/views/pages/supporthub/ict_team/index.dart';
import 'package:umgkh_mobile/view_models/tsb_form_view_model.dart';
import 'package:umgkh_mobile/view_models/tsb_view_model.dart';
import 'package:umgkh_mobile/view_models/survey_view_model.dart';
import 'package:umgkh_mobile/widgets/show_notification_page.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/services/api/other/util_service.dart';
import 'package:umgkh_mobile/services/local_storage/local_storage_service.dart';
import 'package:umgkh_mobile/services/local_storage/models/menu_item_local_storage_service.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/activity_form_view_model.dart';
import 'package:umgkh_mobile/view_models/activity_view_model.dart';
import 'package:umgkh_mobile/view_models/announcement_view_model.dart';
import 'package:umgkh_mobile/view_models/approve_employee_overtime_form_view_model.dart';
import 'package:umgkh_mobile/view_models/approve_employee_overtime_hr_view_model.dart';
import 'package:umgkh_mobile/view_models/approve_employee_overtime_dh_view_model.dart';
import 'package:umgkh_mobile/view_models/approve_leave_view_model.dart';
import 'package:umgkh_mobile/view_models/approve_request_overtime_form_view_model.dart';
import 'package:umgkh_mobile/view_models/approve_request_overtime_view_model.dart';
import 'package:umgkh_mobile/view_models/attendance_view_model.dart';
import 'package:umgkh_mobile/view_models/call_cus_form_view_model.dart';
import 'package:umgkh_mobile/view_models/change_password_view_model.dart';
import 'package:umgkh_mobile/view_models/e_catalog_view_model.dart';
import 'package:umgkh_mobile/view_models/field_service_form_view_model.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';
import 'package:umgkh_mobile/view_models/job_analytic_form_view_model.dart';
import 'package:umgkh_mobile/view_models/job_finish_form_view_model.dart';
import 'package:umgkh_mobile/view_models/lead_form_view_model.dart';
import 'package:umgkh_mobile/view_models/lead_view_model.dart';
import 'package:umgkh_mobile/view_models/overall_checking_form_view_model.dart';
import 'package:umgkh_mobile/view_models/overtime_form_view_model.dart';
import 'package:umgkh_mobile/view_models/overtime_view_model.dart';
import 'package:umgkh_mobile/view_models/global_provider.dart';
import 'package:umgkh_mobile/view_models/home_view_model.dart';
import 'package:umgkh_mobile/view_models/product_images_view_model.dart';
import 'package:umgkh_mobile/view_models/product_view_model.dart';
import 'package:umgkh_mobile/view_models/register_face_view_model.dart';
import 'package:umgkh_mobile/view_models/supporthub/erp_team/request_contact_form_view_model.dart';
import 'package:umgkh_mobile/view_models/supporthub/erp_team/request_contact_view_model.dart';
import 'package:umgkh_mobile/view_models/request_overtime_form_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/view_models/setting_view_model.dart';
import 'package:umgkh_mobile/view_models/service_report_form_view_model.dart';
import 'package:umgkh_mobile/view_models/small_paper_form_view_model.dart';
import 'package:umgkh_mobile/view_models/small_paper_view_model.dart';
import 'package:umgkh_mobile/view_models/take_leave_form_view_model.dart';
import 'package:umgkh_mobile/view_models/take_leave_view_model.dart';
import 'package:umgkh_mobile/view_models/login_view_model.dart';
import 'package:umgkh_mobile/view_models/map_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/request_overtime_view_model.dart';
import 'package:umgkh_mobile/view_models/timesheet_form_view_model.dart';
import 'package:umgkh_mobile/view_models/vehicle_check_form_view_model.dart';
import 'package:umgkh_mobile/view_models/vehicle_check_view_model.dart';
import 'package:umgkh_mobile/views/pages/am/index.dart';
import 'package:umgkh_mobile/views/pages/announcement/index.dart';
import 'package:umgkh_mobile/views/pages/change_password/index.dart';
import 'package:umgkh_mobile/views/pages/cms/index.dart';
import 'package:umgkh_mobile/views/pages/crm/index.dart';
import 'package:umgkh_mobile/views/pages/crm/lead/index.dart';
import 'package:umgkh_mobile/views/pages/e-catalog/index.dart';
import 'package:umgkh_mobile/views/pages/e-catalog/product/index.dart';
import 'package:umgkh_mobile/views/pages/supporthub/index.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_employee_overtime_dh/index.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_employee_overtime_hr/index.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_leave/index.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_request_overtime/index.dart';
import 'package:umgkh_mobile/views/pages/hr/overtime/index.dart';
import 'package:umgkh_mobile/views/pages/hr/index.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/form.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/index.dart';
import 'package:umgkh_mobile/views/pages/hr/request_overtime/index.dart';
import 'package:umgkh_mobile/views/pages/maps/index.dart';
import 'package:umgkh_mobile/views/pages/onboarding/login/index.dart';
import 'package:umgkh_mobile/views/pages/onboarding/splash/index.dart';
import 'package:umgkh_mobile/views/pages/profile/index.dart';
import 'package:umgkh_mobile/views/pages/service/index.dart';
import 'package:umgkh_mobile/views/screens/attendance/index.dart';
import 'package:umgkh_mobile/views/screens/home/index.dart';
import 'package:umgkh_mobile/views/screens/setting/index.dart';
import 'package:umgkh_mobile/widgets/screen_container.dart';
import 'view_models/a4_under_level_form_view_model.dart';
import 'view_models/a4_under_level_view_model.dart';
import 'view_models/access_levels_view_model.dart';
import 'view_models/check_form_vehicle_check_view_model.dart';
import 'view_models/opportunity_form_view_model.dart';
import 'view_models/opportunity_view_model.dart';
import 'views/pages/cms/a4_for_under_level/index.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalStorageService().init();
  await MenuItemLocalStorageService().initializeDefaultMenuItems();
  await MenuItemLocalStorageService().initializeDefaultMenuType();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UtilAPIService _utilAPIService = UtilAPIService();
  @override
  void initState() {
    super.initState();
    getFCMToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      insertFCMToken(fcmToken);
    }).onError((err) {
      debugPrint("Error getting token");
    });

    // Handle notification messages when the app is in the background or terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle background/terminated messages here
      if (message.notification != null) {
        navigateToPage(message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        _showNotificationPage(
          title: message.notification!.title ?? "No Title",
          body: message.notification!.body ?? "No Body",
        );
        // navigateToPage(message);
      }
      // else if (message.data['url'] != null) {
      //   launchUniversalLink(message.data['url']);
      // }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        navigateToPage(message);
      }
    });
  }

  void _showNotificationPage({required String title, required String body}) {
    MyApp.navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ShowNotificationPage(title: title, body: body);
        },
      ),
    );
  }

  void navigateToPage(RemoteMessage message) {
    if (message.data['page'] != "") {
      String routeName = message.data['page'];
      if (routeName == AttendanceScreen.routeName ||
          routeName == HomeScreen.routeName ||
          routeName == SettingsScreen.routeName) {
        MyApp.navigatorKey.currentState!.pushReplacementNamed(routeName);
      } else {
        MyApp.navigatorKey.currentState!.pushNamed(routeName);
      }
    } else if (message.data['url'] != "") {
      launchUniversalLink(message.data['url']);
    }
  }

  getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: false,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) insertFCMToken(fcmToken);
  }

  insertFCMToken(String fcmToken) async {
    await _utilAPIService.insertFCMToken(fcmToken);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalProvider()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => AttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => AttendanceAreaViewModel()),
        ChangeNotifierProvider(create: (_) => TakeLeaveViewModel()),
        ChangeNotifierProvider(create: (_) => TakeLeaveFormViewModel()),
        ChangeNotifierProvider(create: (_) => RequestOvertimeViewModel()),
        ChangeNotifierProvider(create: (_) => RequestOvertimeFormViewModel()),
        ChangeNotifierProvider(create: (_) => OvertimeViewModel()),
        ChangeNotifierProvider(create: (_) => OvertimeFormViewModel()),
        ChangeNotifierProvider(
            create: (_) => ApproveRequestOvertimeViewModel()),
        ChangeNotifierProvider(
            create: (context) => ApproveRequestOvertimeFormViewModel()),
        ChangeNotifierProvider(create: (_) => AccessLevelViewModel()),
        ChangeNotifierProvider(
            create: (_) => ApproveEmployeeOvertimeDHViewModel()),
        ChangeNotifierProvider(
            create: (_) => ApproveEmployeeOvertimeHRViewModel()),
        ChangeNotifierProvider(
            create: (context) => ApproveEmployeeOvertimeFormViewModel()),
        ChangeNotifierProvider(create: (context) => AnnouncementViewModel()),
        ChangeNotifierProvider(
            create: (context) => A4UnderLevelFormViewModel()),
        ChangeNotifierProvider(create: (context) => A4UnderLevelViewModel()),
        ChangeNotifierProvider(create: (context) => SelectionsViewModel()),
        ChangeNotifierProvider(create: (context) => LeadViewModel()),
        ChangeNotifierProvider(create: (context) => LeadFormViewModel()),
        ChangeNotifierProvider(create: (context) => ActivityViewModel()),
        ChangeNotifierProvider(create: (context) => ActivityFormViewModel()),
        ChangeNotifierProvider(create: (context) => ApproveLeaveViewModel()),
        ChangeNotifierProvider(create: (context) => OpportunityViewModel()),
        ChangeNotifierProvider(create: (context) => OpportunityFormViewModel()),
        ChangeNotifierProvider(create: (context) => ECatalogViewModel()),
        ChangeNotifierProvider(create: (context) => ProductPageViewModel()),
        ChangeNotifierProvider(create: (context) => SmallPaperFormViewModel()),
        ChangeNotifierProvider(create: (context) => SmallPaperViewModel()),
        ChangeNotifierProvider(create: (context) => VehicleCheckViewModel()),
        ChangeNotifierProvider(create: (context) => ProductImagesViewModel()),
        ChangeNotifierProvider(
            create: (context) => VehicleCheckFormViewModel()),
        ChangeNotifierProvider(
            create: (context) => CheckFormVehicleCheckViewModel()),
        ChangeNotifierProvider(create: (context) => SettingViewModel()),
        ChangeNotifierProvider(create: (context) => RegisterFaceViewModel()),
        ChangeNotifierProvider(create: (context) => FieldServiceViewModel()),
        ChangeNotifierProvider(
            create: (context) => CallCustomerFormViewModel()),
        ChangeNotifierProvider(
            create: (context) => FieldServiceFormViewModel()),
        ChangeNotifierProvider(
            create: (context) => OverallCheckingFormViewModel()),
        ChangeNotifierProvider(
            create: (context) => ServiceReportFormViewModel()),
        ChangeNotifierProvider(create: (context) => JobFinishFormViewModel()),
        ChangeNotifierProvider(create: (context) => JobAnalytisFormViewModel()),
        ChangeNotifierProvider(create: (context) => TimesheetFormViewModel()),
        ChangeNotifierProvider(create: (context) => ChangePasswordViewModel()),
        ChangeNotifierProvider(create: (context) => RequestContactViewModel()),
        ChangeNotifierProvider(
            create: (context) => RequestContactFormViewModel()),
        ChangeNotifierProvider(
            create: (context) => RequestContactProductViewModel()),
        ChangeNotifierProvider(
            create: (context) => RequestContactProductFormViewModel()),
        ChangeNotifierProvider(create: (context) => NotificationViewModel()),
        ChangeNotifierProvider(create: (context) => LogNoteViewModel()),
        ChangeNotifierProvider(create: (context) => LogNoteFormViewModel()),
        ChangeNotifierProvider(create: (context) => A4AllLevelFormViewModel()),
        ChangeNotifierProvider(create: (context) => ICTTicketViewModel()),
        ChangeNotifierProvider(create: (context) => ICTTicketFormViewModel()),
        ChangeNotifierProvider(create: (context) => TsbViewModel()),
        ChangeNotifierProvider(create: (context) => TsbFormViewModel()),
        ChangeNotifierProvider(create: (context) => ShareWidgetViewModel()),
        ChangeNotifierProvider(create: (context) => NenamVersionViewModel()),
        ChangeNotifierProvider(create: (context) => AppInfoiewModel()),
        ChangeNotifierProvider(create: (context) => PLMSalesViewModel()),
        ChangeNotifierProvider(
            create: (context) => ScheduleTruckDriverViewModel()),
        ChangeNotifierProvider(
            create: (context) => ScheduleTruckDriverFormViewModel()),
        ChangeNotifierProvider(
            create: (context) => MonthlyPlmTargetViewModel()),
        ChangeNotifierProvider(
            create: (context) => MonthlyPlmTargetFormViewModel()),
        ChangeNotifierProvider(
            create: (context) => MonthlyPlmAchievementViewModel()),
        ChangeNotifierProvider(
            create: (context) => MonthlyPlmAchievementFormViewModel()),
        ChangeNotifierProvider(create: (context) => VisualBoardViewModel()),
        ChangeNotifierProvider(create: (context) => VisualBoardFormViewModel()),
        ChangeNotifierProvider(create: (context) => MarketingTicketViewModel()),
        ChangeNotifierProvider(
            create: (context) => MarketingTicketFormViewModel()),
        ChangeNotifierProvider(
            create: (context) => PLMSalesMonthlyDeptViewModel()),
        ChangeNotifierProvider(
            create: (context) => SurveyViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: MyApp.navigatorKey,
        title: 'Nenam',
        theme: theme(),
        home: const SplashPage(),
        routes: {
          LoginPage.routeName: (context) => LoginPage(),
          HomeScreen.routeName: (context) =>
              const ScreenContainer(pageIndex: 0),
          AttendanceScreen.routeName: (context) =>
              const ScreenContainer(pageIndex: 1),
          SettingsScreen.routeName: (context) =>
              const ScreenContainer(pageIndex: 2),
          ChangePasswordPage.routeName: (context) => const ChangePasswordPage(),
          ProfilePage.routeName: (context) => const ProfilePage(),
          AttendanceAreaPage.routeName: (context) => const AttendanceAreaPage(),
          HRPage.routeName: (context) => const HRPage(),
          TakeLeavePage.routeName: (context) => const TakeLeavePage(),
          SurveyPage.routeName: (context) => const SurveyPage(),
          TakeLeaveFormPage.routeName: (context) => const TakeLeaveFormPage(),
          RequestOvertimePage.routeName: (context) =>
              const RequestOvertimePage(),
          EmployeeOvertimePage.routeName: (context) =>
              const EmployeeOvertimePage(),
          ApproveRequestOvertimePage.routeName: (context) =>
              const ApproveRequestOvertimePage(),
          ApproveEmployeeOvertimeDhPage.routeName: (context) =>
              const ApproveEmployeeOvertimeDhPage(),
          ApproveEmployeeOvertimeHrPage.routeName: (context) =>
              const ApproveEmployeeOvertimeHrPage(),
          AnnouncementPage.routeName: (context) => const AnnouncementPage(),
          CMSPage.routeName: (context) => const CMSPage(),
          A4ForUnderLevelPage.routeName: (context) =>
              const A4ForUnderLevelPage(),
          CRMPage.routeName: (context) => const CRMPage(),
          LeadPage.routeName: (context) => const LeadPage(),
          ApproveLeavePage.routeName: (context) => const ApproveLeavePage(),
          ECatalogPage.routeName: (context) => const ECatalogPage(),
          ProductPage.routeName: (context) => const ProductPage(),
          AMPage.routeName: (context) => const AMPage(),
          ServicePage.routeName: (context) => const ServicePage(),
          SupportHubPage.routeName: (context) => const SupportHubPage(),
          ERPRequestContactFormAndInfoPage.routeName: (context) =>
              const ERPRequestContactFormAndInfoPage(),
          ICTTeamPage.routeName: (context) => const ICTTeamPage(),
        },
      ),
    );
  }
}
