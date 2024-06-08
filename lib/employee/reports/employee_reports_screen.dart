import 'package:employee_attendance_app/employee/reports/attendancereports/employee_inout_present.dart';
import 'package:employee_attendance_app/employee/reports/attendancereports/in_out_summary.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_fonts.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  bool visibleAttendanceReports = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text('Reports',style: TextStyle(fontFamily: AppFonts.bold),),
      ),
      body: Column(
        children: [
          GestureDetector(
              onTap: (){
                setState((){
                  if(visibleAttendanceReports == false){
                    visibleAttendanceReports = true;
                  }
                  else if(visibleAttendanceReports == true){
                    visibleAttendanceReports = false;
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.only(top:30,left: 20,right: 20,bottom: 20),
                child: Row(
                  children:  [
                    const Expanded(flex:1,child: Text('1',style: TextStyle(fontSize: 18,fontFamily: AppFonts.medium))),
                    const Expanded(flex:7,child: Text('Attendance Reports',style: TextStyle(fontSize: 18,fontFamily: AppFonts.medium))),
                    Expanded(flex:1,child: Icon(visibleAttendanceReports == true ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_sharp))
                  ],
                ),
              )),
          Visibility(
            visible: visibleAttendanceReports,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                GestureDetector(
                  onTap: (){
                    Get.to(const EmployeeInOutPresent());
                  },
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(left: 50,right: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.appColor
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent
                      ),
                      child: const Text('Employee Inout Present',style: TextStyle(fontFamily: AppFonts.regular))),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: (){
                    Get.to(const InOutSummary());
                  },
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(left: 50,right: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.appColor
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent
                      ),
                      child: const Text('In-Out Summary',style: TextStyle(fontFamily: AppFonts.regular))),
                ),
               /* const SizedBox(height: 10),
                GestureDetector(
                  onTap: (){
                    Get.to(const AttendanceRegister());
                  },
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(left: 50,right: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.appColor
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent
                      ),
                      child: const Text('Attendance Register',style: TextStyle(fontFamily: AppFonts.Regular))),
                ),*/
              ],
            ),
          )
        ],
      ),
    );
  }
}
