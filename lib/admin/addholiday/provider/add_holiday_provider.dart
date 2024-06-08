import 'package:flutter/material.dart';
class AddHolidayProvider extends ChangeNotifier{

  DateTime holidayDate = DateTime.now();
  DateTime? picked;
  Future<void> selectDate(BuildContext context) async {
    picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year, 12, 31));
    if (picked != null && picked != holidayDate) {
        holidayDate = picked!;
        notifyListeners();
    }
  }

  onWillPop(){
    picked = null;
  }

}