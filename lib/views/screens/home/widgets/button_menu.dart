import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/base/custom_ui/menu_item.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/home_view_model.dart';
import 'package:umgkh_mobile/views/screens/attendance/index.dart';
import 'package:umgkh_mobile/views/screens/home/index.dart';
import 'package:umgkh_mobile/views/screens/setting/index.dart';

// ================================================= GRID ==============
class ItemGridMenu extends StatelessWidget {
  final MenuItem data;
  final Color? imgColor;
  const ItemGridMenu({Key? key, required this.data, this.imgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          // 1. Background color
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(mainRadius),
            ),
          ),

          // 2. Snow PNG overlay (behind InkWell)
          ClipRRect(
            borderRadius: BorderRadius.circular(mainRadius),
            child: Image.asset(
              'assets/images/snow-overlay-button.png',
              // fit: BoxFit.cover,
              fit: BoxFit.cover,
              // opacity:
              //     const AlwaysStoppedAnimation(0.7), // optional transparency
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // 3. InkWell with content
          Material(
            color: Colors.transparent, // important
            child: InkWell(
              onTap: () => onTapMenu(context, data.routeName),
              borderRadius: BorderRadius.circular(mainRadius),
              highlightColor: primaryColor.withOpacity(0.1),
              splashColor: primaryColor.withOpacity(0.1),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        getIconMenu(data.iconName),
                        color: imgColor,
                        height: MediaQuery.of(context).size.height / 14,
                      ),
                      Text(
                        data.label,
                        textAlign: TextAlign.center,
                        style: white12Bold,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  // Widget build(BuildContext context) => Material(
  //       color: primaryColor,
  //       borderRadius: BorderRadius.circular(mainRadius / 1),
  //       child: InkWell(
  //         onTap: () => onTapMenu(context, data.routeName),
  //         borderRadius: BorderRadius.circular(mainRadius / 1),
  //         highlightColor: primaryColor.withOpacity(0.1),
  //         splashColor: primaryColor.withOpacity(0.1),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Image.asset(getIconMenu(data.iconName),
  //                 color: imgColor,
  //                 height: MediaQuery.of(context).size.height / 15),
  //             Text(data.label, textAlign: TextAlign.center, style: white12Bold)
  //           ],
  //         ),
  //       ),
  //     );
}

// ================================================= LIST ==============
class ItemListMenu extends StatelessWidget {
  final MenuItem data;
  final bool isLastIndex;
  final Color? imgColor;

  const ItemListMenu({
    super.key,
    required this.data,
    required this.isLastIndex,
    this.imgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: mainRadius / 2),
      child: Column(
        children: [
          Stack(
            children: [
              /// ============================
              /// 1) Background color
              /// ============================
              Container(
                decoration: BoxDecoration(
                  // color: primaryColor,
                  borderRadius: BorderRadius.circular(mainRadius),
                ),
                height: 70, // <-- adjust based on your design
                // width: 50,
              ),

              /// ============================
              /// 2) Snow background image
              /// ============================
              ClipRRect(
                borderRadius: BorderRadius.circular(mainRadius),
                child: Image.asset(
                  'assets/images/snow-overlay-button.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 70, // same as container
                  // opacity: const AlwaysStoppedAnimation(0.5),
                  // imgColor: Colors.white.withOpacity(0.5)
                ),
              ),

              /// ============================
              /// 3) Foreground content (InkWell)
              /// ============================
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onTapMenu(context, data.routeName),
                  borderRadius: BorderRadius.circular(mainRadius),
                  highlightColor: whiteColor.withOpacity(0.1),
                  splashColor: whiteColor.withOpacity(0.1),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: mainPadding,
                      vertical: mainPadding / 2,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Material(
                            borderRadius:
                                BorderRadius.circular(mainRadius / 1.5),
                            color: primaryColor,
                            child: Padding(
                              padding: EdgeInsets.all(mainPadding / 4),
                              child: Image.asset(
                                getIconMenu(data.iconName),
                                color: imgColor,
                                height: MediaQuery.of(context).size.height / 20,
                              ),
                            ),
                          ),
                        ),
                        width10Space,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data.label,
                                  textAlign: TextAlign.start,
                                  style: primary12Bold),
                              Padding(
                                padding:
                                    EdgeInsets.only(right: mainPadding / 2),
                                child: Text(
                                  data.description,
                                  textAlign: TextAlign.start,
                                  style: primary12Bold.copyWith(
                                      fontSize: 9, color: Colors.blueGrey),
                                ),
                              )
                            ],
                          ),
                        ),
                        Center(
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: primaryColor.withOpacity(0.5),
                            size: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Divider
          if (!isLastIndex)
            Container(
              height: 0.5,
              margin: EdgeInsets.symmetric(horizontal: mainPadding * 1.5),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(mainRadius),
              ),
            )
        ],
      ),
    );
  }
}

void onTapMenu(BuildContext context, String route) {
  if (route == AttendanceScreen.routeName ||
      route == HomeScreen.routeName ||
      route == SettingsScreen.routeName) {
    Navigator.of(context).pushReplacementNamed(route);
  } else {
    Navigator.pushNamed(context, route);
  }
  FocusScope.of(context).requestFocus(
    FocusNode(),
  );
  Provider.of<HomeViewModel>(context, listen: false).onRemoveSearch();
}

String iconPath = "assets/icons/home";
String getIconMenu(String iconName) {
  switch (iconName) {
    case 'supporthub':
      return '$iconPath/supporthub.png';
    case 'attendance':
      return '$iconPath/attendance_icon.png';
    case 'hr':
      return '$iconPath/hr_icon.png';
    case 'announcement':
      return '$iconPath/announcement_icon.png';
    case 'cms':
      return '$iconPath/cms_icon.png';
    case 'crm':
      return '$iconPath/crm_icon.png';
    case 'catalog':
      return '$iconPath/catalog_icon.png';
    case 'am':
      return '$iconPath/am_icon.png';
    case 'service':
      return '$iconPath/service_icon.png';
    default:
      return '$iconPath/profile_icon.png'; // Default icon for unknown names
  }
}
