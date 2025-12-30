import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/service-project_task/call_to_customer/call_to_customer.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/views/pages/image/index.dart';
import 'package:umgkh_mobile/views/pages/service/field_service/widget/utils_widget.dart';

class ItemCallCustomerWidget extends StatelessWidget {
  final CallToCustomer data;
  const ItemCallCustomerWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mainRadius),
        ),
        color: primaryColor.withOpacity(0.1),
        margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
        child: Padding(
          padding: EdgeInsets.all(mainPadding * 1.2),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            item(
              context,
              title: 'Call Datetime',
              data: formatReadableDT(data.callDatetime!),
            ),
            item(context, title: 'Call Duration', data: '${data.callDuration}'),
            item(
              context,
              title: 'Status',
              data: capitalizeFirstLetter(data.status!),
            ),
            item(context, title: 'Notes', data: data.note),
            item(context, title: 'Sign', data: null, noSize: true, img: true)
          ]),
        ),
      );

  Widget item(BuildContext context,
          {required String title,
          required String? data,
          bool img = false,
          bool noSize = false}) =>
      Padding(
        padding: EdgeInsets.only(bottom: noSize ? 0 : mainPadding / 2.5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: titleStyle12.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 7,
            child: img
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: widgetImg((this.data.evidenceImage), onTap: () {
                      navPush(
                        context,
                        ViewFullImagePage(
                          image: Constants.fsPicture(this.data.evidenceImage),
                        ),
                      );
                    }),
                  )
                : Text(ifNullStr(data),
                    style: titleStyle12,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
          )
        ]),
      );
}
