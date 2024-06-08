import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/admin/employeeprofile/employee_profile_screen.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_fonts.dart';
//ignore: must_be_immutable
class EmployeeDetailsScreen extends StatelessWidget {
   EmployeeDetailsScreen({Key? key}) : super(key: key);

  var registerEmployeeEmail = FirebaseFirestore.instance.collection("employee").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text('View Details',style: TextStyle(fontFamily: AppFonts.bold),),
      ),
      body: StreamBuilder(
          stream: registerEmployeeEmail,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }else if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong",style: TextStyle(fontFamily: AppFonts.medium)));
            }
            else if (!snapshot.hasData) {
              return  const Center(
                  child: Text("No Data Found",style: TextStyle(fontFamily: AppFonts.medium),));
            } else if (snapshot.requireData.docChanges.isEmpty){
              return  const Center(
                  child: Text("No Data Found",style: TextStyle(fontFamily: AppFonts.medium),));
            } else if (snapshot.hasData){
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context,index) {
                    return GestureDetector(
                      onTap: (){Get.to(ViewAdminEmployeeProfileScreen(email: snapshot.data!.docs[index].id));},
                      child: ListTile(
                        tileColor: index.isOdd ? Colors.blueGrey.withOpacity(0.1) : Colors.white,
                        title: Text(snapshot.data!.docs[index].id,style: const TextStyle(fontFamily: AppFonts.medium)),
                        leading: Text('${index+1}',style: const TextStyle(fontFamily: AppFonts.medium)),
                        trailing: const Icon(Icons.arrow_forward_ios,size: 12),
                        // trailing: Icons,
                      ),
                    );
                  }
              );
            }
            else{
              return const Center(child: Text('No Data Found',style: TextStyle(fontFamily: AppFonts.medium)));
            }
          }
      ),
    );
  }
}
