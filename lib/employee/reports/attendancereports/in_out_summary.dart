import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/reports/openpdf/open_pdf_in_out_summary.dart';
import 'package:employee_attendance_app/employee/reports/pdfview/pdfview_in_out_summary.dart';
import 'package:employee_attendance_app/employee/reports/provider/reports_provider.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_fonts.dart';

class InOutSummary extends StatefulWidget {
  const InOutSummary({Key? key}) : super(key: key);

  @override
  State<InOutSummary> createState() => _InOutSummaryState();
}

class _InOutSummaryState extends State<InOutSummary> {


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
        title: const Text('In Out Summary',style: TextStyle(fontFamily: AppFonts.bold),),
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
                          'EMPLOYEE INOUT SUMMARY',
                          style: TextStyle(fontSize: 18, fontFamily: AppFonts.medium),
                        )),
                    GestureDetector(
                      onTap: () {
                        snapshot.selectFromDate(context);

                        debugPrint('${
                            FirebaseFirestore.instance.collection('employee').
                            doc(FirebaseAuth.instance.currentUser?.email).collection('InOutTime').doc('2022-07-21').
                            snapshots()
                        }');

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
                                    style: TextStyle(fontFamily: AppFonts.medium,fontSize: 16))),
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
                                    style: TextStyle(fontFamily: AppFonts.medium,fontSize: 16))),
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
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                              AppColor.appColor, //// Text Color
                            ),
                            onPressed: () async {
                              PdfViewInOutSummary().makePdfInOutSummary(
                                DateFormat('dd-MM-yyyy')
                                    .format(snapshot.reportsFromDate),
                                DateFormat('dd-MM-yyyy')
                                    .format(snapshot.reportsToDate),
                                context
                              ).then((value) => Get.to(OpenPdfInOutSummary(linked: value,)));
                            },
                            child: const Text('View',style: TextStyle(fontFamily: AppFonts.medium),)),
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
                            child: const Text('Back',style: TextStyle(fontFamily: AppFonts.medium),)),
                      ],
                    )
                  ],
                );
              })),
    );
  }
}
