import 'package:flutter/material.dart';

class LeaveProvider extends ChangeNotifier{

  DateTime leaveFromDate = DateTime.now();
  DateTime leaveToDate = DateTime.now();
  //TimeOfDay selectedTime = TimeOfDay(hour: 9, minute: 0);
  int countLeave = 0;
  int countHour = 0;
  String? fromTime,toTime;
 // String selectLeaveType = "";
  String? selectLeaveType;
  List<String> selectLeaveTypeItem = [
    'LWP',
    'Flexi Leave',
    'Leave',
  ];
  get getLeaveType {
    notifyListeners();
    return selectLeaveTypeItem;
  }
  get getFromTime {
    notifyListeners();
    return fromTime;
  }
  get getToTime {
    notifyListeners();
    return toTime;
  }
  get getHour {
    notifyListeners();
    return countHour;
  }
  getFromLeave() {
    notifyListeners();
    return leaveFromDate;
  }
  countValueGet(){
    countLeave = leaveToDate.difference(leaveFromDate).inDays;
    // print(selectedTime.hour);
    print("CountLeave_Day $countLeave");
    notifyListeners();
  }
  onWillPop(context){
    selectLeaveType = null;
    countLeave = 0;
    countHour=0;
  }
}