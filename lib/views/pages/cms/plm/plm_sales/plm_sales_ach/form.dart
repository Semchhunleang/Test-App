import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/plm/plm_sales/plm_sales.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_sales/plm_sales_ach/widget/build_table_daily_plm.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_sales/plm_sales_ach/widget/build_table_monthly_plm.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_sales/plm_sales_ach/widget/build_table_wekkly_plm.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_sales/plm_sales_ach/widget/item_plm_sales_widget.dart';

class PLMSalesFormInfoPage extends StatefulWidget {
  final PLMSales data;
  static const routeName = '/plm-sales-info';
  static const pageName = 'PLM Sales Achievement';
  const PLMSalesFormInfoPage({super.key, required this.data});

  @override
  State<PLMSalesFormInfoPage> createState() => _PLMSalesFormInfoPageState();
}

class _PLMSalesFormInfoPageState extends State<PLMSalesFormInfoPage> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 3,
      child: Scaffold(
          extendBodyBehindAppBar: false,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(200),
              child: SafeArea(
                  child: AppBar(
                      backgroundColor: transparent,
                      centerTitle: true,
                      title: Text(PLMSalesFormInfoPage.pageName,
                          style: appBarStyle),
                      bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(150),
                          child: Column(children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: mainPadding,
                                    vertical: mainPadding / 2),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // SALES INFO
                                      Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                            Text(
                                                widget.data.sales.name
                                                    .toUpperCase(),
                                                style: primary15Bold.copyWith(
                                                    color: blackColor,
                                                    fontSize: 18,
                                                    letterSpacing: 1.5)),
                                            Text(widget.data.sales.jobTitle,
                                                style: titleStyle13.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[700])),
                                            heith5Space,
                                            Text(
                                                "${widget.data.month} • ${widget.data.year}",
                                                style: titleStyle13.copyWith(
                                                    color: Colors.grey[500],
                                                    fontStyle:
                                                        FontStyle.italic))
                                          ])),

                                      // SCORE
                                      buildScorePLM(widget.data.score)
                                    ])),

                            // TABBAR
                            Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                    color: greyColor.withOpacity(0.2),
                                    borderRadius:
                                        BorderRadius.circular(mainRadius * 2)),
                                child: TabBar(
                                    tabs: [
                                      Tab(text: 'Daily'.toUpperCase()),
                                      Tab(text: 'Weekly'.toUpperCase()),
                                      Tab(text: 'Monthly'.toUpperCase())
                                    ],
                                    labelColor: whiteColor,
                                    unselectedLabelColor: greyColor,
                                    labelStyle: titleStyle13.copyWith(
                                        fontWeight: FontWeight.bold),
                                    unselectedLabelStyle: titleStyle11,
                                    indicator: BoxDecoration(
                                        // color: greenColor,
                                        gradient: LinearGradient(colors: [
                                          primaryColor.withOpacity(0.8),
                                          primaryColor.withOpacity(0.7),
                                          primaryColor.withOpacity(0.6)
                                        ]),
                                        borderRadius: BorderRadius.circular(
                                            mainRadius * 2)),
                                    indicatorPadding: const EdgeInsets.all(5),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    splashBorderRadius:
                                        BorderRadius.circular(mainRadius * 2),
                                    physics: kBounce))
                          ]))))),
          body: TabBarView(children: [
            buildTableDailyPLM(context, widget.data.daily),
            buildTableWeeklyPLM(context, widget.data.weekly),
            buildTableMonthlyPLM(context, widget.data.monthly),
          ])));
}
