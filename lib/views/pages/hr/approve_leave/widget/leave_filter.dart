import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/approve_leave_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_leave/widget/utils_widget.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class LeaveFilter extends StatefulWidget {
  const LeaveFilter({Key? key}) : super(key: key);

  @override
  State<LeaveFilter> createState() => _LeaveFilterState();
}

class _LeaveFilterState extends State<LeaveFilter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApproveLeaveViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Column(
            children: [
              Column(
                children: [
                  // seto code
                  // SearchTextfield(
                  //     initialValue: viewModel.search,
                  //     onChanged: (String value) async {
                  //       await Provider.of<ApproveLeaveViewModel>(context,
                  //               listen: false)
                  //           .setSearch(value);
                  //     }),
                  // puthea changed
                  Row(children: [
                    Expanded(
                      child:
                          SearchTextfield(onChanged: viewModel.onSearchChanged),
                    ),
                    width5Space,
                    InkWell(
                      onTap: viewModel.onShowFilter,
                      borderRadius: BorderRadius.circular(mainRadius * 2),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Icon(
                            size: 24,
                            color: viewModel.isShowFilter
                                ? primaryColor
                                : Colors.red,
                            viewModel.isShowFilter
                                ? Icons.filter_alt_rounded
                                : Icons.filter_alt_off_rounded),
                      ),
                    )
                  ]),

                  if (viewModel.isShowFilter) ...[
                    heith10Space,
                    Row(children: [
                      filterSelectStatus(
                          selected: viewModel.selectedState,
                          onValue: viewModel.onStateChanged),
                      width10Space,
                      filterYearLeaveApproval(
                          onTap: () => _selectYear(context, viewModel),
                          year: viewModel.year)
                    ])
                  ]
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectYear(
      BuildContext context, ApproveLeaveViewModel viewModel) async {
    final int? picked = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int selectedYear = viewModel.year;

        return AlertDialog(
          title: const Text('Select Year'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(2000),
              lastDate: DateTime(DateTime.now().year + 1, 12, 26),
              // initialDate: DateTime(selectedYear),
              selectedDate: DateTime(selectedYear),
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime.year);
              },
              currentDate: DateTime(selectedYear),
            ),
          ),
        );
      },
    );

    // if (picked != null) {
    //   await Provider.of<ApproveLeaveViewModel>(context, listen: false)
    //       .setYear(picked);
    // }

    if (picked != null && picked != viewModel.year) {
      await viewModel.setYear(picked); // No more BuildContext across async
    }
  }
}
