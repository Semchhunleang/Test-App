import 'package:flutter/foundation.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
// import 'package:umgkh_mobile/models/hr/survey/survey.dart';
import 'package:umgkh_mobile/models/hr/survey/survey_user_input.dart';
import 'package:umgkh_mobile/services/api/hr/survey/survey_service.dart';

class SurveyViewModel extends ChangeNotifier {
  List<SurveyUserInput> _surveys = [];
  List<SurveyUserInput> _filteredSurveyUserInputs = [];
  bool _isLoading = false;
  String _search = '';
  DateTime _endDate = DateTime.now();
  DateTime _startDate = DateTime(DateTime.now().year - 1, 12, 26);
  int _year = DateTime.now().year;
  double _totalSurveyUserInput = 0.0;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);

  List<SurveyUserInput> get surveys => _surveys;
  List<SurveyUserInput> get filteredSurveyUserInputs => _filteredSurveyUserInputs;
  bool get isLoading => _isLoading;
  String get search => _search;
  DateTime get endDate => _endDate;
  DateTime get startDate => _startDate;
  int get year => _year;
  double get totalSurveyUserInput => _totalSurveyUserInput;
  ApiResponse get apiResponse => _apiResponse;

  resetData() async{
    await setSearch('');
    if (DateTime.now().month == 12 && DateTime.now().day >= 26) {
      await setYear(DateTime.now().year + 1);
    } else {
      await setYear(DateTime.now().year);
    }
  }
  Future<void> setDate(DateTime date, bool isStart) async {
    notifyListeners();
    _year = year;
    _startDate = DateTime(_year - 1, 12, 26);
    _endDate = DateTime(_year, 12, 26);
    fetchSurveys();
    notifyListeners();
  }

  Future<void> setYear(int year) async {
    notifyListeners();
    _year = year;
    _startDate = DateTime(_year - 1, 12, 26);
    _endDate = DateTime(_year, 12, 26);
    fetchSurveys();
    notifyListeners();
  }

  Future<void> setSearch(String search) async {
    notifyListeners();
    _search = search;
    fetchSurveys();
    notifyListeners();
  }

  Future<void> fetchSurveys() async {
    _isLoading = true;
    // _surveySummaries = [];
    _totalSurveyUserInput = 0;
    notifyListeners();

    final response = await SurveyAPIService().fetchSurvey(startDate, endDate);
    _apiResponse = response;
    if (response.statusCode == 200 || response.statusCode == 201) {
      final surveys = response.data!;
      // _surveys = surveys.where((survey) {
      //   return survey.createDate.isAfter(_startDate) &&
      //       survey.createDate.isBefore(_endDate);
      // }).toList();
      _filteredSurveyUserInputs = surveys.where((survey) {
        return survey.survey.title
                .toLowerCase()
                .contains(_search.toLowerCase()) 
                || 
                survey.state
                .toLowerCase()
                .contains(_search.toLowerCase())
                // || survey.employeeName!
                // .toLowerCase()
                // .contains(_search.toLowerCase()
                // )
                ;
            //     &&
            // survey.createDate.isAfter(_startDate) &&
            // survey.createDate.isBefore(_endDate) ;
      }).toList();
    }else{
      _surveys = [];
      _filteredSurveyUserInputs = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}
