import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../firebase/firebase_collection.dart';

class GrievanceDetail extends StatefulWidget {
  const GrievanceDetail({super.key});

  @override
  State<GrievanceDetail> createState() => _GrievanceDetailState();
}

class _GrievanceDetailState extends State<GrievanceDetail> {
  late var detail;
  String employeeName = "", employeeEmail = "";
  String formattedDate = "";
  @override
  void initState() {
    // TODO: implement initState
    detail = Get.arguments;
    getReportedByDetails();



    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text(
          'Grievance',
          style: TextStyle(fontFamily: AppFonts.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Complain:", style: const TextStyle(fontFamily: AppFonts.medium)),
          const SizedBox(
            height: 5,
          ),
          Text(detail["title"],
              style: const TextStyle(fontFamily: AppFonts.medium)),
          const SizedBox(
            height: 8,
          ),
          Divider(height: 3, color: Colors.black12,),
          const SizedBox(
            height: 8,
          ),
          Text("Detail:", style: const TextStyle(fontFamily: AppFonts.medium)),
          const SizedBox(
            height: 5,
          ),
          Text(detail["description"],
              style: const TextStyle(fontFamily: AppFonts.medium)),
          const SizedBox(
            height: 8,
          ),
          Divider(height: 3, color: Colors.black12,),
          const SizedBox(
            height: 8,
          ),
          Text("Reported on:",
              style: const TextStyle(fontFamily: AppFonts.medium)),
          const SizedBox(
            height: 5,
          ),
          Text(detail["dateTime"],
              style: const TextStyle(fontFamily: AppFonts.medium)),
          const SizedBox(
            height: 8,
          ),
          Divider(height: 3, color: Colors.black12,),
          const SizedBox(
            height: 8,
          ),
          Text("Reported by",
              style: const TextStyle(fontFamily: AppFonts.medium)),
          const SizedBox(
            height: 5,
          ),
          Text(employeeName,
              style: const TextStyle(fontFamily: AppFonts.medium)),
          Text(employeeEmail,
              style: const TextStyle(fontFamily: AppFonts.medium)),
        ]),
      ),
    );
  }

  void getReportedByDetails() async {
    //Format Grievance reported date:
    var collection = FirebaseFirestore.instance.collection('employee');
    var docSnapshot = await collection.doc(detail['employeeId']).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      print(data);
      setState(() {
        employeeName =
            data?['employeeName']; // <-- The value you want to retrieve.
        employeeEmail = data?['email']; // <-- The value you want to retrieve.
      });
    }
  }
//   FirebaseCollection()
//       .grievancesCollection
//       .doc(detail['employeeId'])
//       .get() => then(function(document) {
//   print(document("name"));
//   });
// }
}
