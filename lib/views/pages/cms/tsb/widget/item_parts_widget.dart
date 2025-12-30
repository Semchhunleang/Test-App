import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/cms/tsb/tsb_line.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../../../utils/theme.dart';

class ItemPartsWidget extends StatelessWidget {
  final TsbLine tsbLine;
  const ItemPartsWidget({super.key, required this.tsbLine});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(mainRadius / 2),
      ),
      color: primaryColor.withOpacity(0.1),
      margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: mainPadding * 1.2,
                top: mainPadding * 1.2,
                bottom: mainPadding * 0.5),
            child: Text(
                tsbLine.typePart != null
                    ? capitalizeFirstLetter(tsbLine.typePart!)
                    : "",
                style: primary13Bold),
          ),
          Padding(
            padding: EdgeInsets.only(left: mainPadding * 1),
            child: Row(
              children: [
                Expanded(
                    child:
                        Text("${tsbLine.product!.name}", style: titleStyle12)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: mainPadding * 1.2, bottom: mainPadding * 1.2),
            child: Row(
              children: [Text("${tsbLine.qtyLine}", style: titleStyle12)],
            ),
          ),
        ],
      ),
    );
  }
}
