import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/launch_utils.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/map_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/views/pages/profile/widgets/profile_picture.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile-page';
  static const pageName = 'Profile';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).fetchUserData();
      Provider.of<ProfileViewModel>(context, listen: false).getProfilePicture();
      Provider.of<AttendanceAreaViewModel>(context, listen: false).setPoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: ProfilePage.pageName,
      body: Consumer2<ProfileViewModel, AttendanceAreaViewModel>(
        builder: (context, viewModel, areaVM, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.user.id == 0) {
            return const Center(child: Text('No data available'));
          } else {
            return ListView(
              physics: kBounce,
              padding: EdgeInsets.only(bottom: mainPadding),
              children: [
                Center(
                  child: Card(
                    elevation: 0,
                    color: Colors.blueGrey.withOpacity(0.1),
                    margin: EdgeInsets.symmetric(horizontal: mainPadding),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(mainRadius)),
                    child: Padding(
                      padding: EdgeInsets.all(mainPadding),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        // image
                        ProfilePicture(
                            profilePicture: viewModel.profilePicture),
                        heith10Space,
                        Text(viewModel.user.name,
                            textAlign: TextAlign.center,
                            style: primary15Bold.copyWith(fontSize: 20)),
                        Text(viewModel.user.username,
                            textAlign: TextAlign.center,
                            style:
                                titleStyle15.copyWith(color: Colors.blueGrey)),
                        heith5Space,
                        Text(viewModel.user.jobTitle,
                            textAlign: TextAlign.center,
                            style:
                                titleStyle15.copyWith(color: Colors.blueGrey)),
                        heithSpace,
                        Divider(thickness: 0.2, color: primaryColor),
                        heith10Space,
                        // info
                        buildInfoRow(Icons.contact_phone_rounded, 'Work Phone',
                            viewModel.user.workPhone ?? '-'),
                        buildInfoRow(Icons.phone_android_rounded,
                            'Mobile Phone', viewModel.user.mobilePhone ?? '-'),
                        buildInfoRow(
                            Icons.business_rounded,
                            'Department',
                            viewModel.user.department != null
                                ? viewModel.user.department!.name
                                : ''),
                        buildInfoRow(
                          Icons.location_on_rounded,
                          'Work Location',
                          viewModel.user.workLocation != null
                              ? viewModel.user.workLocation!.name
                              : '',
                          onTap: () {
                            double lat = areaVM.getPolygonCentroid().latitude;
                            double lng = areaVM.getPolygonCentroid().longitude;
                            openGoogleMap(lat, lng);
                          },
                        ),
                        buildInfoRow(
                            Icons.person_pin_rounded,
                            'Manager',
                            viewModel.user.manager != null
                                ? viewModel.user.manager!.name
                                : ''),
                        buildInfoRow(Icons.email_rounded, 'Email',
                            viewModel.user.workEmail ?? ''),
                        buildInfoRow(Icons.military_tech, 'Rank',
                            "${viewModel.user.rank!}${viewModel.user.subRank!.toUpperCase()}",
                            showLine: false),
                      ]),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

Widget buildInfoRow(IconData icon, String label, String value,
    {bool showLine = true, Function()? onTap}) {
  return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      onTap: onTap,
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(label, style: titleStyle13),
                const SizedBox(height: 4),
                Text(value,
                    style: titleStyle12.copyWith(color: Colors.blueGrey),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis)
              ]))
        ]),
        if (showLine)
          Padding(
              padding:
                  EdgeInsets.only(top: 4, bottom: 3, left: mainPadding * 2.4),
              child: Divider(color: Colors.blueGrey.shade100, thickness: 0.5))
      ]));
}



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:umgkh_mobile/view_models/profile_view_model.dart';
// import 'package:umgkh_mobile/views/pages/profile/widgets/profile_picture.dart';

// class ProfilePage extends StatefulWidget {
//   static const routeName = '/profile-page';
//   static const pageName = 'Profile';

//   const ProfilePage({Key? key}) : super(key: key);

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ProfileViewModel>(context, listen: false).fetchUserData();
//       Provider.of<ProfileViewModel>(context, listen: false).getProfilePicture();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(ProfilePage.pageName,
//             style: Theme.of(context).textTheme.titleLarge),
//       ),
//       body: Consumer<ProfileViewModel>(
//         builder: (context, viewModel, child) {
//           if (viewModel.isLoading) {
//             return const Center(child: CircularProgressIndicator(),);
//           } else if (viewModel.user.id == 0) {
//             return const Center(child: Text('No data available'),);
//           } else {
//             return ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
//                       margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//                       height: MediaQuery.of(context).size.height / 4.5,
//                       width: MediaQuery.of(context).size.width / 3,
//                       child: ProfilePicture(
//                         profilePicture: viewModel.profilePicture,
//                       ),
//                     ),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             viewModel.user.name,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           const Divider(height: 10),
//                           const Text("Employee Number: ",
//                               style: TextStyle(fontWeight: FontWeight.bold),),
//                           Text(viewModel.user.username),
//                           const Divider(height: 5),
//                           const Text("Work Phone: ",
//                               style: TextStyle(fontWeight: FontWeight.bold),),
//                           Text(viewModel.user.workPhone ?? '-'),
//                           const Divider(height: 5),
//                           const Text("Mobile Phone: ",
//                               style: TextStyle(fontWeight: FontWeight.bold),),
//                           Text(viewModel.user.mobilePhone ?? '-'),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Divider(),
//                 ListTile(
//                   title: const Text('Job Title'),
//                   subtitle: Text(viewModel.user.jobTitle),
//                 ),
//                 ListTile(
//                   title: const Text('Department'),
//                   subtitle: Text(viewModel.user.department != null
//                       ? viewModel.user.department!.name
//                       : ''),
//                 ),
//                 ListTile(
//                   title: const Text('Work Location'),
//                   subtitle: Text(viewModel.user.workLocation != null
//                       ? viewModel.user.workLocation!.name
//                       : ''),
//                 ),
//                 ListTile(
//                   title: const Text('Manager'),
//                   subtitle: Text(viewModel.user.manager != null
//                       ? viewModel.user.manager!.name
//                       : ''),
//                 ),
//                 ListTile(
//                   title: const Text('Email'),
//                   subtitle: Text(viewModel.user.workEmail ?? ''),
//                 ),
//                 ListTile(
//                   title: const Text('Rank'),
//                   subtitle: Text(
//                       "${viewModel.user.rank!}${viewModel.user.subRank!.toUpperCase()}"),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }
