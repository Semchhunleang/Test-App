import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/cms/tsb/tsb.dart';
import '../../../../../utils/theme.dart';
import '../../../../../utils/utlis.dart';
import '../../../../../widgets/button_custom.dart';

class ItemTsbWidget extends StatelessWidget {
  final TSBData tsbdata;
  const ItemTsbWidget({super.key, required this.tsbdata});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(mainRadius / 2),
      ),
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
                  child: Text("${tsbdata.transactionNo}", style: primary13Bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: mainPadding * 1.2),
                  child: Row(
                    children: [
                      Text("${tsbdata.manufacturer!.name}",
                          style: titleStyle12),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: mainPadding * 1.2, bottom: mainPadding * 1.2),
                  child: Row(
                    children: [
                      Text(formatDDMMMMYYYY(tsbdata.date!),
                          style: titleStyle12),
                    ],
                  ),
                ),
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
                text: stateTitleTsb(tsbdata.state),
                color: stateColor(tsbdata.state),
              ),
            ),
          )
        ],
      ),
    );
  }
}
