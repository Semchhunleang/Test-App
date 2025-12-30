import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_achievement/monthly_line.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_supporting/monthly_plm_achievement/widget/detail_monthly_widget.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';

class DetailFormMonthly extends StatefulWidget {
  final String activity;
  final MonthlyLines? monthlyLines;
  const DetailFormMonthly(
      {super.key, required this.activity, this.monthlyLines});

  @override
  State<DetailFormMonthly> createState() => _DetailFormMonthlyState();
}

class _DetailFormMonthlyState extends State<DetailFormMonthly> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        title: widget.activity,
        body: Column(
          children: [
            Text(
              "Score : ${widget.monthlyLines!.score}",
              style: primary15Bold,
            ),
            const SizedBox(
              height: 15.0,
            ),
            Expanded(
              child: DetailMonthlyWidget(
                data: widget.monthlyLines!,
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
          ],
        ));
  }
}
