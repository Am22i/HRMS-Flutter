import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/admin/adminProfile/admin_profile_screen.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:employee_attendance_app/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../firebase/firebase_collection.dart';
import '../login/screen/login_screen.dart';
import '../utils/app_colors.dart';

class AdminDrawerScreen extends StatelessWidget {
  const AdminDrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.whiteColor,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColor.whiteColor,
            ),
            child: StreamBuilder(
                stream: FirebaseCollection().adminCollection.doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {

                  if(snapshot.connectionState == ConnectionState.none){
                    return const Text('Something went wrong');
                  } else if(snapshot.connectionState == ConnectionState.waiting){
                    return const Text('Your connection is waiting');
                  }
                  else if(snapshot.hasData){
                    Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                            child:
                            // Image.network('https://miro.medium.com/max/1400/0*0fClPmIScV5pTLoE.jpg',height: 70,width: 70,fit: BoxFit.fill)
                            Container(
                                color: AppColor.appColor,
                                height: 70,width: 70,
                                child: Center(
                                  child: Text('${data['companyName']?.substring(0,1).toUpperCase()}',
                                    style: const TextStyle(color: AppColor.whiteColor,fontSize: 30,fontFamily: AppFonts.regular)),
                                ))
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            const SizedBox(height: 10),
                            Text('${data['companyName']}',style: const TextStyle(fontSize: 18,fontFamily: AppFonts.medium,color: AppColor.blackColor)),
                            const SizedBox(height:3),
                            Text('${FirebaseAuth.instance.currentUser?.email}',style: const TextStyle(color: AppColor.blackColor,fontFamily: AppFonts.regular),),
                          ],
                        ),
                      ],
                    );
                  }
                  else{
                    return const Text('Data is loaded');
                  }
              }
            ),
          ),
          const Divider(height: 1,color: AppColor.darkGreyColor,),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home',style: TextStyle(fontFamily: AppFonts.medium)),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile',style: TextStyle(fontFamily: AppFonts.medium)),
            onTap: () {
              Navigator.pop(context);
              Get.to(const AdminProfileScreen(),
                  duration: const Duration(seconds: 1),
                  transition: Transition.rightToLeftWithFade);
            },
          ),

          /*ListTile(
            leading: const Icon(Icons.mark_chat_read_outlined),
            title: const Text('Attendance',style: TextStyle(fontFamily: AppFonts.Medium)),
            onTap: () {
              Get.to(const AttendanceScreen());
            },
          ),*/

          const Divider(height: 1,color: AppColor.darkGreyColor,),

         /* ListTile(
            leading: const Icon(Icons.report_gmailerrorred_sharp),
            title: const Text('Reports'),
            onTap: () {
              Get.to(const ReportScreen());
            },
          ),
*/
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout',style: TextStyle(fontFamily: AppFonts.medium)),
            onTap: () {
              FirebaseAuth.instance.signOut();
              AppUtils.instance.clearPref().then((value) => Get.offAll(LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
