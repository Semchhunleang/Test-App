import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/am/vehicle_check/vehicle_check.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/check_form_vehicle_check_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/vehicle_check_view_model.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import '../form_and_info.dart';

class ItemVehicleCheckWidget extends StatelessWidget {
  final VehicleCheck data;
  const ItemVehicleCheckWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Consumer3<VehicleCheckViewModel,
          CheckFormVehicleCheckViewModel, ProfileViewModel>(
      builder: (context, viewModel, checkFormView, profile, _) =>
          GestureDetector(
              onTap: () async {
                checkFormView.clearState();
                final result = await navPush(
                    context,
                    VehicleCheckFormInfoPage(
                      isForm: false,
                      data: data,
                    ),);
                if (result == true) {
                  viewModel.fetchAllVehicleCheck(profile);
                }
              },
              child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(mainRadius),),
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
                                    text:
                                        stateTitleA4(data.state).toUpperCase(),
                                    color: stateColor(data.state),),),
                            heith10Space,
                            item(
                                title: 'Vehicle',
                                data: data.fleetVehicle!.name!),
                            heith5Space,
                            item(
                                title: 'Check Type',
                                data: data.checkType != null
                                    ? capitalizeFirstLetter(data.checkType!)
                                    : "N / A"),
                            heith5Space,
                            item(
                                title: 'Department',
                                data: data.requestor!.department!.name),
                            heith5Space,
                            item(
                                title: 'Requestor', data: data.requestor!.name),
                            heith5Space,
                            item(title: 'Approver', data: data.approver!.name),
                            heith5Space,
                            item(
                                title: 'Checker',
                                data: data.checker != null
                                    ? data.checker!.name
                                    : "N / A"),
                            heith5Space,
                            if (data.checkType == "audit" ||
                                data.checkType == "check") ...[
                              item(
                                  title: 'Audit Date',
                                  data: data.auditDatetime != null
                                      ? formatReadableDT(data.auditDatetime!)
                                      : "N/A"),
                              heith5Space,
                              item(
                                  title: 'KM Current',
                                  data: "${data.kmCurrent}"),
                              heith5Space,
                            ],
                            if (data.checkType == "inout" ||
                                data.checkType == "borrow") ...[
                              item(
                                  title: 'KM Start',
                                  data: data.kmStart != null
                                      ? "${data.kmStart}"
                                      : "N / A"),
                              heith5Space,
                              item(
                                  title: 'KM End',
                                  data: data.kmEnd != null
                                      ? "${data.kmEnd}"
                                      : "N / A"),
                              heith5Space,
                              item(
                                  title: 'Planned Out',
                                  data: data.plannedDatetimeOut != null
                                      ? formatReadableDT(
                                          data.plannedDatetimeOut!)
                                      : "N/A"),
                              heith5Space,
                              if (data.actualDatetimeOut != null) ...[
                                item(
                                    title: 'Actual Out',
                                    data: data.actualDatetimeOut != null
                                        ? formatReadableDT(
                                            data.actualDatetimeOut!)
                                        : "N/A"),
                                heith5Space,
                              ],
                              item(
                                  title: 'Planned In',
                                  data: data.plannedDatetimeIn != null
                                      ? formatReadableDT(
                                          data.plannedDatetimeIn!)
                                      : "N/A"),
                              heith5Space,
                              if (data.actualDatetimeIn != null) ...[
                                item(
                                    title: 'Actual In',
                                    data: data.actualDatetimeIn != null
                                        ? formatReadableDT(
                                            data.actualDatetimeIn!)
                                        : "N/A"),
                                heith5Space,
                              ],
                            ],
                          ]),),),));

  Widget item({required String title, required String data}) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$title:', style: titleStyle12.copyWith(color: Colors.black54),),
        width5Space,
        Expanded(child: Text(data, style: titleStyle12),)
      ]);
}
