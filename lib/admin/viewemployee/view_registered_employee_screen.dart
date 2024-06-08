import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../employee/attendance_details/attendance_details_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';

class ViewEmployeeAttendance extends StatefulWidget {
  const ViewEmployeeAttendance({Key? key}) : super(key: key);

  @override
  State<ViewEmployeeAttendance> createState() => _ViewEmployeeAttendance();
}

class _ViewEmployeeAttendance extends State<ViewEmployeeAttendance> with SingleTickerProviderStateMixin{
  late TabController tabController;

  var registerEmployeeEmail =
  FirebaseFirestore.instance.collection("employee").snapshots();

  var registerAdminEmail =
  FirebaseFirestore.instance.collection("admin").snapshots();

  static const List<Tab> registeredTab = <Tab>[
    Tab(text: 'Employee'),
    Tab(text: 'Admin'),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: registeredTab.length);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          title: const Text('View Registered Details',style: TextStyle(fontFamily: AppFonts.bold),),
          bottom : const TabBar(
            indicatorColor: AppColor.appColor,
            labelColor: AppColor.appColor,
            tabs: registeredTab,
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
                stream: registerEmployeeEmail,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }else if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong",style: TextStyle(fontFamily: AppFonts.medium)));
                  }
                  else if (!snapshot.hasData) {
                    return  const Center(
                        child: Text("No Employee Record Found",style: TextStyle(fontFamily: AppFonts.medium),));
                  } else if (snapshot.requireData.docChanges.isEmpty){
                    return  const Center(
                        child: Text("No Employee Record Found",style: TextStyle(fontFamily: AppFonts.medium),));
                  } else{
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context,index) {
                          return GestureDetector(
                            onTap: (){Get.to(AttendanceDetailsScreen(email: snapshot.data!.docs[index].id,passType: 'Admin',));},
                            child: ListTile(
                              tileColor: index.isOdd ? Colors.blueGrey.shade50 : Colors.white,
                              leading: Text('${index+1}',style: const TextStyle(fontFamily: AppFonts.medium)),
                              title: Text(snapshot.data!.docs[index].id,style: const TextStyle(fontFamily: AppFonts.medium)),
                              trailing: const Icon(Icons.arrow_forward_ios,size: 12,),
                            ),
                          );
                        }
                    );
                  }
                }
            ),
            StreamBuilder(
                stream: registerAdminEmail,
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
                  }
                  else{
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context,index) {
                          return ListTile(
                            tileColor: index.isOdd ? Colors.blueGrey.shade50 : Colors.white,
                            leading: Text('${index+1}',style: const TextStyle(fontFamily: AppFonts.medium)),
                            title: Text(snapshot.data!.docs[index].id,style: const TextStyle(fontFamily: AppFonts.medium)),
                          );
                        }
                    );
                  }
                }
            ),
          ],
        )
      ),
    );
  }
}
