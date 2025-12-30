// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/am/schedule_truck_driver/schedule_truck_driver.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/schedule_truck_driver_view_model.dart';
import 'package:umgkh_mobile/views/pages/am/schedule_truck_driver/form_and_info.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';

class ItemScheduleTruckDriverWidget extends StatelessWidget {
  final ScheduleTruckDriver data;
  const ItemScheduleTruckDriverWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Consumer2<ScheduleTruckDriverViewModel,
          ProfileViewModel>(
      builder: (context, listVM, userVM, _) => GestureDetector(
          onTap: () async {
            await navPush(context,
                ScheduleTruckDriverFormAndInfoPage(isForm: false, data: data));
            await listVM.fetchData();
          },
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(mainRadius)),
              color: primaryColor.withOpacity(0.1),
              margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
              child: Padding(
                  padding: EdgeInsets.all(mainPadding * 1.2),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: double.infinity,
                            height: 25,
                            child: StatusCustom(
                                textsize: 11,
                                text: data.state.toUpperCase(),
                                color: scheduleTruckStateColor(data.state))),
                        heith10Space,
                        Text(data.name.toUpperCase(), style: primary15Bold),
                        heith5Space,
                        item(
                            title: 'Requestor',
                            data: data.requestor.name.toUpperCase()),
                        heith5Space,
                        if (userVM.user.id != data.requestor.id) ...[
                          item(
                              title: 'Department',
                              data: data.requestor.department!.name),
                          heith5Space
                        ],
                        item(
                            title: 'Request DT',
                            data: formatReadableDT(data.requestDatetime)),
                        heith5Space,
                        if (data.approveDatetime != null) ...[
                          item(
                              title: 'Approve DT',
                              data: formatReadableDT(data.approveDatetime!)),
                          heith5Space
                        ],
                        if (data.driver != null) ...[
                          item(title: 'Driver', data: data.driver!.name),
                          heith5Space
                        ],
                        if (data.vehicle != null) ...[
                          item(title: 'Vehicle', data: data.vehicle!.name!),
                          heith5Space
                        ],
                        item(
                            title: 'Tag',
                            data: toTitleCase(data.tag.toString()),
                            style: titleStyle12.copyWith(
                                color: getStateColor(data.tag.toString()),
                                fontWeight: FontWeight.bold))
                      ])))));

  Widget item(
          {required String title, required String data, TextStyle? style}) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$title:', style: titleStyle12.copyWith(color: Colors.black54)),
        width5Space,
        Expanded(child: Text(data, style: style ?? titleStyle12))
      ]);
}
