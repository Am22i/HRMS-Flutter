import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/login/screen/login_screen.dart';
import 'package:employee_attendance_app/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../employee/profile/employee_profile_screen.dart';
import '../firebase/firebase_collection.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class EmployeeDrawerScreen extends StatelessWidget {
  const EmployeeDrawerScreen({Key? key}) : super(key: key);

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
                stream: FirebaseCollection().employeeCollection.doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>?> snapshot) {

                  if(snapshot.connectionState == ConnectionState.none){
                    return const Text('Something went wrong',style: TextStyle(fontFamily: AppFonts.regular),);
                  }
                  else if(!snapshot.hasData){
                    return const Text('Unable to fin data',style: TextStyle(fontFamily: AppFonts.regular),);
                  }
                  else{
                    Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          child:
                          // Image.network('https://miro.medium.com/max/1400/0*0fClPmIScV5pTLoE.jpg',height: 70,width: 70,fit: BoxFit.fill)
                          data['imageUrl'] == "" ? Container(
                              color: AppColor.backgroundColor,
                              height: 70,width: 70,
                              child: Center(
                                child: Text('${data['employeeName']?.substring(0,1).toUpperCase()}',
                                  style: const TextStyle(color: AppColor.appBlackColor,fontSize: 30,fontFamily: AppFonts.medium),),
                              )) :
                          Image.network(
                              '${data['imageUrl']}',
                              height: 70, width: 70, fit: BoxFit.cover),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            const SizedBox(height: 5),
                            Text('${data['employeeName']}',style: const TextStyle(fontSize: 18,fontFamily: AppFonts.regular)),
                            Text('${FirebaseAuth.instance.currentUser?.email}',style: const TextStyle(color: AppColor.blackColor,fontFamily: AppFonts.regular),),
                          ],
                        ),
                      ],
                    );
                  }
              }
            ),
          ),
          const Divider(height: 1,color: AppColor.darkGreyColor,),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home',style: TextStyle(fontFamily: AppFonts.medium)),
            onTap: () {
             // Navigator.pop(context);
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile',style: TextStyle(fontFamily: AppFonts.medium)),
            onTap: () {
              Navigator.pop(context);
              Get.to(const EmployeeProfileScreen(),
                  duration: const Duration(seconds: 1),
                  transition: Transition.rightToLeftWithFade);
            },
          ),

          const Divider(height: 1,color: AppColor.darkGreyColor,),

       /*   ListTile(
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
