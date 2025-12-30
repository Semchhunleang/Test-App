import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_supporting/monthly_plm_achievement/widget/detail_table_widget.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';

class DetailForm extends StatefulWidget {
  final String activity;
  final List<dynamic> data;
  final double score;
  final bool isWeekly;
  const DetailForm(
      {super.key,
      required this.activity,
      required this.data,
      this.score = 0.0,
      this.isWeekly = false});

  @override
  State<DetailForm> createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        title: widget.activity,
        body: Column(
          children: [
            Text(
              "Score : ${widget.score}",
              style: primary15Bold,
            ),
            const SizedBox(
              height: 15.0,
            ),
            Expanded(
              child: DetailTableWidget(
                data: widget.data,
                isWeekly: widget.isWeekly,
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
          ],
        ));
  }
}
