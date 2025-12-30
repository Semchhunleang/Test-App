import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/view_models/take_leave_view_model.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class LeaveFilter extends StatefulWidget {
  const LeaveFilter({
    Key? key,
  }) : super(key: key);

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
    return Consumer<TakeLeaveViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                      child: SearchTextfield(
                          initialValue: viewModel.search,
                          onChanged: (String value) async {
                            await Provider.of<TakeLeaveViewModel>(context,
                                    listen: false)
                                .setSearch(value);
                          })
                      // TextFormField(
                      //     initialValue: viewModel.search,
                      //     decoration: InputDecoration(
                      //       contentPadding: const EdgeInsets.symmetric(
                      //           vertical: 0,
                      //           horizontal: 10), // Adjust padding
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(5),
                      //       ),
                      //       hintText: "What are you searching for?",
                      //       suffixIcon: IconButton(
                      //         onPressed: () {},
                      //         icon: const Icon(Icons.search),
                      //       ),
                      //     ),
                      //     style: const TextStyle(
                      //         fontSize: 14), // Smaller font size
                      //     onChanged: (String value) async {
                      //       await Provider.of<TakeLeaveViewModel>(context,
                      //               listen: false)
                      //           .setSearch(value);
                      //     },
                      //   ),
                      ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => _selectYear(context, viewModel),
                              child: Text(
                                '${viewModel.year}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () async {
                  //     await Provider.of<TakeLeaveViewModel>(context,
                  //             listen: false)
                  //         .changeIsFilter();
                  //   },
                  //   color: viewModel.isFilter
                  //       ? Colors.red
                  //       : theme().primaryColor,
                  //   icon: Icon(viewModel.isFilter
                  //       ? Icons.filter_alt_off_rounded
                  //       : Icons.filter_alt_rounded),
                  // ),
                ],
              ),
              // const LeaveSummary(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectYear(
      BuildContext context, TakeLeaveViewModel viewModel) async {
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
    //   await Provider.of<TakeLeaveViewModel>(context, listen: false).setYear(picked);
    // }
    if (picked != null && picked != viewModel.year) {
      await viewModel.setYear(picked); // No more BuildContext across async
    }
  }
}
