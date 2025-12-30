import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/views/pages/cms/a4_all_level/index.dart';
import 'package:umgkh_mobile/views/pages/cms/a4_for_under_level/index.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/index.dart';
import 'package:umgkh_mobile/views/pages/cms/tsb/index.dart';
import 'package:umgkh_mobile/views/pages/cms/visual_board/index.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/widget_button_action.dart';
import 'package:umgkh_mobile/widgets/widget_no_access.dart';
import '../../../view_models/access_levels_view_model.dart';

class CMSPage extends StatefulWidget {
  static const routeName = '/cms';
  static const pageName = 'CMS';
  const CMSPage({super.key});

  @override
  State<CMSPage> createState() => _CMSPageState();
}

class _CMSPageState extends State<CMSPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AccessLevelViewModel>(builder: (context, viewModel, _) {
      return CustomScaffold(
          title: CMSPage.pageName,
          body: viewModel.hasCMSAccess()
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: mainPadding),
                  child: Column(children: [
                    if (viewModel.accessLevel.isUnderLevel == 1) ...[
                      const WidgetButtonActionn(
                        name: 'A4',
                        page: A4ForUnderLevelPage(),
                        icon: Icons.transform_rounded,
                        // image: 'assets/icons/cms/a4_cms_icon.png'
                      )
                    ],
                    //for all access level
                    if (viewModel.accessLevel.a4 == 1) ...[
                      const WidgetButtonActionn(
                        name: 'A4',
                        page: A4AllLevelPage(),
                        icon: Icons.work_history_rounded,
                        // image: 'assets/icons/cms/a4_cms_icon.png'
                      )
                    ],
                    if (viewModel.accessLevel.tsb == 1) ...[
                      const WidgetButtonActionn(
                        name: 'TSB',
                        page: TSBPage(),
                        icon: Icons.construction_rounded,
                        // image: 'assets/icons/cms/a4_cms_icon.png'
                      )
                    ],

                    const WidgetButtonActionn(
                      name: PLMPage.pageName,
                      page: PLMPage(),
                      icon: Icons.stacked_bar_chart_outlined,
                    ),

                    const WidgetButtonActionn(
                      name: VisualBoardPage.pageName,
                      page: VisualBoardPage(),
                      icon: Icons.task_rounded,
                    ),
                  ]))
              : const WidgetNoAccess());
    });
  }

  // Widget item(
  //         {required String name,
  //         required Widget page,
  //         IconData? icon,
  //         String image = ''}) =>
  //     GestureDetector(
  //       onTap: () => navPush(context, page),
  //       child: Card(
  //         elevation: 0,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(mainRadius),
  //         ),
  //         color: primaryColor,
  //         margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
  //         child: Padding(
  //           padding: EdgeInsets.all(mainPadding * 1.2),
  //           child: Row(children: [
  //             icon != null
  //                 ? Icon(icon, color: whiteColor)
  //                 : Image.asset(image,
  //                     height: 24, width: 24, color: whiteColor),
  //             widthSpace,
  //             Text(name, style: white13Bold)
  //           ]),
  //         ),
  //       ),
  //     );
}
