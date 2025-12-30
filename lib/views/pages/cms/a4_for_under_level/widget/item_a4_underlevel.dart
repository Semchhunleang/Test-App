import 'package:flutter/material.dart';
import '../../../../../models/cms/a4/a4.dart';
import '../../../../../utils/theme.dart';
import '../../../../../utils/utlis.dart';
import '../../../../../widgets/button_custom.dart';

class ItemA4Underlevel extends StatelessWidget {
  final A4Data a4data;
  const ItemA4Underlevel({super.key, required this.a4data});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mainRadius / 2),),
        color: primaryColor.withOpacity(0.1),
        margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          left: mainPadding * 1.2,
                          top: mainPadding * 1.2,
                          bottom: mainPadding * 0.5),
                      child: Text("${a4data.name}", style: primary13Bold),),
                  Padding(
                      padding: EdgeInsets.only(left: mainPadding * 1.2),
                      child: Row(
                        children: [
                          Text(formatDDMMMMYYYY(a4data.startPeriod!),
                              style: titleStyle12),
                        ],
                      ),),
                  Padding(
                      padding: EdgeInsets.only(
                          left: mainPadding * 1.2, bottom: mainPadding * 1.2),
                      child: Row(
                        children: [
                          Text(formatDDMMMMYYYY(a4data.endPeriod!),
                              style: titleStyle12),
                        ],
                      ),),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: SizedBox(
                height: 28.0,
                child: StatusCustom(
                    textsize: 11,
                    text: stateTitleOvertime(a4data.state),
                    color: stateColor(a4data.state),),
              ),
            )
          ],
        ),);
  }
}
