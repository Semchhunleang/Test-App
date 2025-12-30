import 'package:flutter/material.dart';

class GlobalProvider extends ChangeNotifier {
  int startingYear = 2022;
  List<int> years = [];
  // int? year = DateTime.now().year;
  List<DropdownMenuItem<int>>? ddmenu;

  GlobalProvider() {
    getYears();
  }

  getYears() async {
    DateTime currentDate = DateTime.now();
    int currentYear = currentDate.year;
    if (currentDate.month == 12 &&
        currentDate.day >= 26 &&
        currentDate.day <= 31) {
      currentYear += 1;
    }

    while (startingYear <= currentYear) {
      years.add(startingYear);
      startingYear += 1;
    }

    ddmenu = years.map<DropdownMenuItem<int>>((int value) {
      return DropdownMenuItem<int>(value: value, child: Text(value.toString(),),);
    }).toList();

    notifyListeners();
  }
}
