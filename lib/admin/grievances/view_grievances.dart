

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/admin/grievances/add_grievance.dart';
import 'package:employee_attendance_app/admin/grievances/grievance_detail.dart';
import 'package:employee_attendance_app/admin/trainingAndDevelopment/add_training_and_development.dart';
import 'package:employee_attendance_app/mixin/button_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewGrievances extends StatefulWidget {
  const ViewGrievances({super.key});

  @override
  State<ViewGrievances> createState() => _ViewGrievancesState();
}

class _ViewGrievancesState extends State<ViewGrievances> {
  var reports = FirebaseFirestore.instance.collection("Grievances").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text(
          'Grievances',
          style: TextStyle(fontFamily: AppFonts.bold),
        ),
      ),

    body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 15,),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: StreamBuilder(
              stream: reports,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text("Something went wrong",
                          style: TextStyle(
                              fontFamily: AppFonts.medium)));
                } else if (!snapshot.hasData) {
                  return const Center(
                      child: Text(
                        "No Data Found",
                        style: TextStyle(fontFamily: AppFonts.medium),
                      ));
                } else if (snapshot
                    .requireData.docChanges.isEmpty) {
                  return const Center(
                      child: Text(
                        "No Data Found",
                        style: TextStyle(fontFamily: AppFonts.medium),
                      ));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            Get.to(const GrievanceDetail(),
                                transition: Transition.rightToLeftWithFade, arguments:  snapshot.data!.docs[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              tileColor: Colors.blueGrey.withOpacity(0.1),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      snapshot.data!.docs[index]
                                      ["title"],
                                      style: const TextStyle(
                                          fontFamily: AppFonts.medium)),
                                  Text(
                                      snapshot.data!.docs[index]
                                      ["description"],
                                      style: const TextStyle(
                                          fontFamily: AppFonts.light)),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return const Center(
                      child: Text('No Data Found',
                          style: TextStyle(
                              fontFamily: AppFonts.medium)));
                }
              }),
        ),

        // Align(alignment: Alignment.bottomRight,
        //   child: Padding(
        //     padding: const EdgeInsets.all(12.0),
        //     child: FloatingActionButton(
        //         onPressed: (){
        //           Get.to(const AddGrievance(),
        //               transition: Transition.rightToLeftWithFade)?.then((value) {
        //             if(value != null){
        //               setState(() {
        //                 reports = FirebaseFirestore.instance.collection("Grievances").snapshots();
        //               });
        //             }
        //           });
        //         },
        //         child: Stack(
        //           children: [
        //             ButtonMixin().stylishButton(
        //                 text: 'Add New'
        //             ),
        //             const Center(child: Icon(Icons.add, size: 30, color: Colors.white,)),
        //           ],
        //         )
        //     ),
        //   ),
        // ),

      ],
    ),);
  }
}
