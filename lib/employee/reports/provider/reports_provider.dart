import 'package:flutter/material.dart';


class ReportsProvider extends ChangeNotifier{

  var todayDate = DateTime.now();
  late DateTime reportsFromDate,reportsToDate;
  String? fromTime,toTime;

  DateTime? pickedFrom,pickedTo;
  DateTime now = DateTime.now();
  // var pdf;

  Future<void> selectFromDate(BuildContext context) async {
    pickedFrom = await showDatePicker(
        context: context,
        initialDate: DateTime(todayDate.year, todayDate.month, 1),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (pickedFrom != null && pickedFrom != reportsFromDate) {
      reportsFromDate = pickedFrom!;
      notifyListeners();
    }
  }

  /*Future<void> selectToDate(BuildContext context) async {
    pickedTo = await showDatePicker(
      context: context,
      initialDate: DateTime(reportsFromDate.year, reportsFromDate.month + 1, 0),
      firstDate: DateTime(reportsFromDate.year, reportsFromDate.month + 1, 0),
      lastDate: DateTime(2101),
    );
    if (pickedTo != null && pickedTo != reportsToDate) {
      reportsToDate = pickedTo!;
      notifyListeners();
    }
  }*/
}