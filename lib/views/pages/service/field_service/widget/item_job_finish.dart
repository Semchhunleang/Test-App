import 'dart:io';

import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/service-project_task/job_finish/job_finish.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/views/pages/image/index.dart';
import 'package:umgkh_mobile/views/pages/service/field_service/widget/utils_widget.dart';

class ItemJobFinishWidget extends StatelessWidget {
  final JobFinish data;
  const ItemJobFinishWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(mainRadius),
      ),
      color: primaryColor.withOpacity(0.1),
      margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
      child: Padding(
        padding: EdgeInsets.all(mainPadding * 1.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item(
              context,
              title: 'Datetime Finish',
              data: formatReadableDT(data.finishDatetime!),
            ),
            item(context,
                title: 'Customer Satified', data: data.customerSatisfied),
            item(context,
                title: 'Customer Comment', data: data.customerComment),
            item(context,
                title: 'Servie Recommendation',
                data: data.serviceRecommendation),
            item(context, title: 'Customer Name', data: data.customerName),
            item(context, title: 'Phone', data: data.phone),
            if (data.sign != 0)
              item(context,
                  title: 'Sign',
                  data: null,
                  noSize: true,
                  img: true,
                  id: data.sign),
            if (data.signImage != null)
              item(context,
                  title: 'Sign',
                  data: null,
                  noSize: true,
                  img: false,
                  imgLocal: true,
                  id: data.sign,
                  fileData: data.signImage!),
            heithSpace,
            if (data.mechanicSign != 0)
              item(context,
                  title: 'Mechanic Sign',
                  data: null,
                  noSize: true,
                  img: true,
                  id: data.mechanicSign),
            if (data.signImageMechanic != null)
              item(context,
                  title: 'Mechanic Sign',
                  data: null,
                  noSize: true,
                  img: false,
                  imgLocal: true,
                  id: data.mechanicSign,
                  fileData: data.signImageMechanic!),
          ],
        ),
      ),
    );
  }

  Widget item(
    BuildContext context, {
    required String title,
    required String? data,
    bool img = false,
    bool imgLocal = false,
    bool noSize = false,
    int id = 0,
    File? fileData,
  }) =>
      Padding(
        padding: EdgeInsets.only(bottom: noSize ? 0 : mainPadding / 2.5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: titleStyle12.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                child: img
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: widgetImg(id, onTap: () {
                          navPush(
                            context,
                            ViewFullImagePage(
                              image: Constants.fsPicture(id),
                            ),
                          );
                        }),
                      )
                    : imgLocal && fileData != null
                        ? FutureBuilder<bool>(
                            future: fileData.exists(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data == true) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: widgetImgLocal(fileData, onTap: () {}),
                                );
                              } else if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data == false) {
                                return const Text(
                                  'Image file not found',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                );
                              } else {
                                return const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                );
                              }
                            },
                          )
                        : Text(
                            ifNullStr(data),
                            style: titleStyle12,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ))
          ],
        ),
      );
}
