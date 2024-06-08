/*import 'package:employee_attendance_app/employee/reports/provider/reports_provider.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_fonts.dart';*/
/*
class AttendanceRegister extends StatefulWidget {
  const AttendanceRegister({Key? key}) : super(key: key);

  @override
  State<AttendanceRegister> createState() => _AttendanceRegisterState();
}

class _AttendanceRegisterState extends State<AttendanceRegister> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var todayDate = DateTime.now();
    Provider.of<ReportsProvider>(context, listen: false).reportsFromDate = DateTime(todayDate.year, todayDate.month, 1);
    Provider.of<ReportsProvider>(context, listen: false).reportsToDate = DateTime(todayDate.year, todayDate.month + 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('Attendance Register',
            style: TextStyle(fontFamily: AppFonts.Medium)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Consumer<ReportsProvider>(
              builder: (BuildContext context, snapshot, Widget? child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Center(
                        child: Text(
                          'EMPLOYEE ATTENDANCE REGISTER',
                          style: TextStyle(fontSize: 18, fontFamily: AppFonts.Medium),
                        )),
                    GestureDetector(
                      onTap: () {
                        snapshot.selectFromDate(context);
                      },
                      child: Container(
                        width: double.infinity,
                        color: Colors.transparent,
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: const EdgeInsets.only(left: 15, bottom: 5),
                                child: const Text('From Date',
                                    style: TextStyle(fontFamily: AppFonts.Medium,fontSize: 16))),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColor.appColor,
                                  )),
                              child: Text(
                                  DateFormat('dd-MM-yyyy')
                                      .format(snapshot.reportsFromDate),
                                  style: const TextStyle(
                                      fontSize: 16, fontFamily: AppFonts.Medium)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        color: Colors.transparent,
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: const EdgeInsets.only(left: 15, bottom: 5),
                                child: const Text('To Date',
                                    style: TextStyle(fontFamily: AppFonts.Medium,fontSize: 16))),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColor.appColor,
                                  )),
                              child: Text(
                                  DateFormat('dd-MM-yyyy')
                                      .format(DateTime(snapshot.reportsFromDate.year,
                                      snapshot.reportsFromDate.month + 1, 0))
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 16, fontFamily: AppFonts.Medium)),
                              // child: Text(DateFormat('dd-MM-yyyy').format(snapshot.reportsToDate),style: const TextStyle(fontSize: 16,fontFamily: AppFonts.Medium)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor:
                              AppColor.appColor, //// Text Color
                            ),
                            onPressed: () async {
                            },
                            child: const Text('View')),
                        const SizedBox(
                          width: 50,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor:
                              AppColor.appColor, //// Text Color
                            ),
                            child: const Text('Back')),
                      ],
                    )
                  ],
                );
              })),
    );
  }
}*/
