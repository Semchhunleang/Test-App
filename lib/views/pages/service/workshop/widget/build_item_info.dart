import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';

class BuildItemInfo extends StatefulWidget {
  const BuildItemInfo({
    super.key,
  });

  @override
  State<BuildItemInfo> createState() => _BuildItemInfoState();
}

class _BuildItemInfoState extends State<BuildItemInfo> {
  @override
  Widget build(BuildContext context) => Consumer<FieldServiceViewModel>(
        builder: (context, viewModel, _) => Expanded(
          flex: 3,
          child: ListView(
            physics: kBounce,
            children: [
              item(data: viewModel.selectedData!.name, isSingle: true),
              item(data: viewModel.selectedData!.jobOrderNo, isSingle: true),
              item(
                title: 'Status',
                data: ifNullModel(
                  viewModel.selectedData!.stage,
                  (p) => ifNullStr(p.name),
                ),
              ),
              item(
                title: 'Customer',
                data: ifNullModel(
                  viewModel.selectedData!.customer,
                  (p) => ifNullStr(p.name),
                ),
              ),
              if (viewModel.selectedData!.operatorName != null ||
                  viewModel.selectedData!.operatorPhone != null) ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      mainPadding, 0, mainPadding, mainPadding / 2.5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          "Operator",
                          style: titleStyle12.copyWith(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      widthSpace,
                      Expanded(
                        flex: 7,
                        child: call(
                            context,
                            viewModel.selectedData!.operatorName,
                            viewModel.selectedData!.operatorPhone
                            // ,
                            // granted,
                            // requestPermission(),
                            // changeGranted
                            ),
                      )
                    ],
                  ),
                ),
              ],
              item(
                title: 'Service Type',
                data: titleServiceType(viewModel.selectedData!.serviceType),
              ),
              item(
                title: 'Province',
                data: ifNullModel(
                  viewModel.selectedData!.state,
                  (p) => ifNullStr(p.name),
                ),
              ),
              item(
                title: 'City',
                data: ifNullModel(
                  viewModel.selectedData!.city,
                  (p) => ifNullStr(p.name),
                ),
              ),
              item(
                title: 'Machine S/N',
                data: ifNullModel(
                  viewModel.selectedData!.machineSerialNumber,
                  (p) => ifNullStr(p.name),
                ),
              ),
              item(
                title: 'Job Finish',
                data: formatReadableDT(
                    viewModel.selectedData!.jobFinishDatetime!),
              ),
              item(
                  title: 'Total Time',
                  data:
                      '${viewModel.selectedData!.repairTimeHour ?? 0} hr ${viewModel.selectedData!.repairTimeMinute ?? 0} min'),
              item(
                  title: 'Resolution Within Std Time',
                  data: viewModel.selectedData!.resoulutionWithinStdTimeBool ==
                          true
                      ? 'Yes'
                      : 'No'),
              item(
                  title: 'Standard Resolution Hour',
                  data:
                      "${viewModel.selectedData!.standardResolutionHour} hour"),
            ],
          ),
        ),
      );
}

Widget item({String title = '', required String? data, bool isSingle = false}) {
  return Padding(
    padding:
        EdgeInsets.fromLTRB(mainPadding, 0, mainPadding, mainPadding / 2.5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isSingle) ...[
          Expanded(
            flex: 4,
            child: Text(
              ifNullStr(data),
              textAlign: TextAlign.center,
              style: titleStyle13.copyWith(fontWeight: FontWeight.bold),
            ),
          )
        ] else ...[
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: titleStyle12.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          widthSpace,
          Expanded(
            flex: 7,
            child: Text(ifNullStr(data),
                style: titleStyle12,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          )
        ]
      ],
    ),
  );
}

Widget call(
  BuildContext context,
  String? operatorName,
  String? operatorPhone,
) {
  return GestureDetector(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.phone_rounded, color: primaryColor),
        width5Space,
        Text(
            operatorName != null
                ? ifNullStr(operatorName)
                : ifNullStr(operatorPhone),
            style: titleStyle12)
      ],
    ),
  );
}
