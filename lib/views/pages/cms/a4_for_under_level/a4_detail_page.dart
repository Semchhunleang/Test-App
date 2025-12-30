import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import '../../../../models/cms/a4/a4.dart';
import '../../../../utils/theme.dart';
import '../../../../utils/utlis.dart';
import '../../../../view_models/a4_under_level_view_model.dart';
import '../../hr/request_overtime/widget/widget_text_value.dart';
import 'widget/image_view_widget.dart';

class A4DetailPage extends StatefulWidget {
  final A4Data a4data;
  const A4DetailPage({super.key, required this.a4data});

  @override
  State<A4DetailPage> createState() => _A4DetailPageState();
}

class _A4DetailPageState extends State<A4DetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final a4UnderLevelViewModel =
          Provider.of<A4UnderLevelViewModel>(context, listen: false);
      await a4UnderLevelViewModel.fetchImageA4(
          widget.a4data.id, "before_improv");
      await a4UnderLevelViewModel.fetchImageA4(
          widget.a4data.id, "after_improv");
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "A4 Detail",
      body: Padding(
        padding: EdgeInsets.fromLTRB(mainPadding, 0, mainPadding, mainPadding),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            WidgetTextValue(
                title: 'Transaction No',
                value: '${widget.a4data.name}',
                fontWeight: FontWeight.bold,
                valueColor: primaryColor),
            heith10Space,
            WidgetTextValue(
              title: 'Start Period',
              value: formatDDMMMMYYYY(widget.a4data.startPeriod!),
            ),
            heith10Space,
            WidgetTextValue(
              title: 'End Period',
              value: formatDDMMMMYYYY(widget.a4data.endPeriod!),
            ),
            heith10Space,
            WidgetTextValue(
              title: 'State',
              value: stateTitleA4(widget.a4data.state),
              fontWeight: FontWeight.bold,
              valueColor: stateColor(widget.a4data.state),
            ),
            heith10Space,
            WidgetTextValue(
              title: 'Grade by superior',
              value: widget.a4data.gradeBySuperior?.toUpperCase(),
            ),
            heith10Space,
            WidgetTextValue(
              title: 'Grade by superior',
              value: widget.a4data.gradeByCb?.toUpperCase(),
            ),
            heithSpace,
            Divider(
              color: primaryColor.withOpacity(0.1),
            ),
            heith10Space,
            // Consumer<A4UnderLevelViewModel>(
            //     builder: (context, provider, child) {
            //   if (provider.isImageLoading) {
            //     return const Center(child: CircularProgressIndicator(),);
            //   }

            //   if (provider.beforeImage.isEmpty &&
            //       provider.afterImage.isEmpty) {
            //     // return const EmptyImage();
            //     return const WidgetNoImage();
            //   } else if (provider.isLoading) {
            //     return const Center(child: CircularProgressIndicator(),);
            //   } else {
            //     return
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Before Improvement', style: primary15Bold),
              ImageViewWidget(id: widget.a4data.id, field: 'before_improv'),
              heithSpace,
              Text('After Improvement', style: primary15Bold),
              ImageViewWidget(id: widget.a4data.id, field: 'after_improv')
            ])
            //   ;
            //   }
            // })
          ]),
        ),
      ),
    );
  }
}
