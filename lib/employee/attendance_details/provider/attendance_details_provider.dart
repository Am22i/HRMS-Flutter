import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class AttendanceDetailsProvider extends ChangeNotifier{

  String? selectMonth=DateFormat.MMMM().format(DateTime.now());
  // String? selectMonth=DateTime.now().toString().substring(5,7);
  String? selectYear = DateTime.now().year.toString();

  get getYear {
    notifyListeners();
    return selectYear;
  }

  get getMonth {
    notifyListeners();
    return selectMonth;
  }

   onWillPop(){
    selectMonth=DateFormat.MMMM().format(DateTime.now());
    selectYear = DateTime.now().year.toString();
  }

  // List<String> yearItem = [
  //   '3000', '2029', '2028', '2027', '2026',
  //   '2025', '2024', '2023', '2022', '2021',
  //   '2020', '2019', '2018', '2017', '2016',
  //   '2015', '2014', '2013', '2012', '2011',
  //   '2010', '2009', '2008', '2007', '2006',
  //   '2005', '2004', '2003', '2002', '2001',
  //   '2000',
  // ];
  List<String> years = [];
  generateYearList() {
    int currentYear = DateTime.now().year;
    years = List.generate(currentYear - 2000 + 1, (index) => (index + 2000).toString()).reversed.toList();
  }


  /*List<String> monthItem = [
    DateTime.december.toString(), DateTime.november.toString(), DateTime.october.toString(),
    '0${DateTime.september.toString()}', '0${DateTime.august.toString()}', '0${DateTime.july.toString()}',
    '0${DateTime.june.toString()}', '0${DateTime.may.toString()}', '0${DateTime.april.toString()}',
    '0${DateTime.march.toString()}', '0${DateTime.february.toString()}', '0${DateTime.january.toString()}',
  ];*/

  List<String> monthItem = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

}