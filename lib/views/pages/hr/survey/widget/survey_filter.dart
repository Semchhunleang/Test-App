import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/view_models/survey_view_model.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class SurveyFilter extends StatefulWidget {
  const SurveyFilter({
    Key? key,
  }) : super(key: key);

  @override
  State<SurveyFilter> createState() => _SurveyFilterState();
}

class _SurveyFilterState extends State<SurveyFilter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SurveyViewModel>(
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
                            await Provider.of<SurveyViewModel>(context,
                                    listen: false)
                                .setSearch(value);
                          })
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
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectYear(
      BuildContext context, SurveyViewModel viewModel) async {
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

    if (picked != null && picked != viewModel.year) {
      await viewModel.setYear(picked); 
    }
  }
}
