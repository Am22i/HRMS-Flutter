import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/reports/openpdf/open_pdf_present.dart';
import 'package:employee_attendance_app/employee/reports/pdfview/pdfview_in_out_present.dart';
import 'package:employee_attendance_app/employee/reports/provider/reports_provider.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../firebase/firebase_collection.dart';
import '../../../utils/app_colors.dart';
import '../../inOut/auth/in_out_fire_auth.dart';

class EmployeeInOutPresent extends StatefulWidget {
  const EmployeeInOutPresent({Key? key}) : super(key: key);

  @override
  State<EmployeeInOutPresent> createState() => _EmployeeInOutPresentState();
}

class _EmployeeInOutPresentState extends State<EmployeeInOutPresent> {

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
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text('In Out Present',style: TextStyle(fontFamily: AppFonts.bold),),
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
                  'EMPLOYEE INOUT PRESENT DAYS',
                  style: TextStyle(fontSize: 18, fontFamily: AppFonts.medium),
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
                                style: TextStyle(fontFamily: AppFonts.medium))),
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
                                  fontSize: 16, fontFamily: AppFonts.medium)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
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
                              style: TextStyle(fontFamily: AppFonts.medium))),
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
                                fontSize: 16, fontFamily: AppFonts.medium)),
                        // child: Text(DateFormat('dd-MM-yyyy').format(snapshot.reportsToDate),style: const TextStyle(fontSize: 16,fontFamily: AppFonts.Medium)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                StreamBuilder(
                    stream: FirebaseCollection().employeeCollection.doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot<Object?>>currentUserDataSnapshot) {
                      if (currentUserDataSnapshot.hasError) {
                        return const Text("Something went wrong",style: TextStyle(fontFamily: AppFonts.medium),);
                      } else if (!currentUserDataSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        Map<String, dynamic> data = currentUserDataSnapshot.data!.data() as Map<String, dynamic>;

                        return StreamBuilder(
                            stream: InOutFireAuth().mainCollection.
                            where('currentDate', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd')
                                .format(snapshot.reportsFromDate).toString())
                                .where('currentDate', isLessThanOrEqualTo: DateFormat('yyyy-MM-dd')
                                .format(DateTime(snapshot.reportsFromDate.year,
                                snapshot.reportsFromDate.month + 1, 0))
                                .toString())
                            .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                    presentSnapshot) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            AppColor.appColor, //// Text Color
                                      ),
                                      onPressed: () async {
                                        debugPrint(presentSnapshot.data!.docs.length
                                            .toString());
                                        PdfViewInOutPresent().makePdfInOutPresent(
                                          department:data['department'] ,
                                            designation:data['designation'],
                                            employeeName:data['employeeName'] ,
                                            fromDate: DateFormat('dd-MM-yyyy').format(snapshot.reportsFromDate),
                                            printDate:DateFormat('dd-MM-yyyy').format(DateTime.now()),
                                            toDate:DateFormat('dd-MM-yyyy').format(snapshot.reportsToDate),
                                            presentDays: presentSnapshot.data!.docs.length
                                                .toString()).then((value) {
                                                  Get.to(OpenPdfInOutPresent(linked: value));
                                        });
                                      },
                                      child: const Text('View',style: TextStyle(fontFamily: AppFonts.regular),)),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            AppColor.appColor, //// Text Color
                                      ),
                                      child: const Text('Back',style: TextStyle(fontFamily: AppFonts.regular),)),
                                ],
                              );
                            });
                      }
                    })
              ],
            );
      })),
    );
  }
}
