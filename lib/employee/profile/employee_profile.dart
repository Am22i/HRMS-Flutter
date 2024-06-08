import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/profile/employee_profile_screen.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:employee_attendance_app/mixin/button_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../login/screen/login_screen.dart';
import '../../utils/app_utils.dart';


class EmployeeProfile extends StatefulWidget {
  const EmployeeProfile({Key? key}) : super(key: key);

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {

  String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to logout?',style: TextStyle(fontSize: 20,fontFamily: AppFonts.semiBold),),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.pop(context, false);
            },
            child: ButtonMixin().stylishButton(
                text: 'No'
            ),
          ),
          GestureDetector(
            onTap: (){
              FirebaseAuth.instance.signOut();
              AppUtils.instance.clearPref().then((value) => Get.offAll(LoginScreen()));
              AppUtils.instance.showToast(toastMessage: "Logged out successfully.");
            },
            child: ButtonMixin().stylishButton(
                text: 'Yes'
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseCollection().employeeCollection.doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
              if (snapshot.hasError) {
                debugPrint('Something went wrong');
                return const Text("Something went wrong",style: TextStyle(fontFamily: AppFonts.regular),);
              }
              else if (!snapshot.hasData || !snapshot.data!.exists) {
                debugPrint('Document does not exist');
                return const Center(child: CircularProgressIndicator());
              } else if(snapshot.requireData.exists){
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height/2.7,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColor.appColor.withOpacity(0.9),
                                  AppColor.appColor.withOpacity(0.4),
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(60),
                                  bottomLeft: Radius.circular(60)
                              ),
                              color: AppColor.appColor,
                            ),
                          ),
                          Positioned(
                            top: 60,
                            left: 0,right: 0,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  ClipOval(
                                      child:
                                      data['imageUrl'] == "" ? Container(
                                        color: AppColor.appColor,
                                        height: 80,width: 80,child: Center(
                                        child: Text('${data['employeeName']?.substring(0,1).toUpperCase()}',
                                            textScaleFactor: 1.0,
                                            // overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(color: Colors.white,fontSize: 30,fontFamily: AppFonts.medium)),
                                      ),) :
                                      Image.network(
                                          '${data['imageUrl']}',
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover)
                                  ),
                                  Text(capitalizeAllWord(data['employeeName']),
                                      style: const TextStyle(fontSize: 35,color: AppColor.whiteColor,fontFamily: AppFonts.medium)),
                                  Text(data['department'],
                                      style: const TextStyle(fontSize: 20,color: Colors.white,fontFamily: AppFonts.medium)),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              right:20,
                              top: 50,
                              child: GestureDetector(
                                onTap: (){
                                  Get.to(const EmployeeProfileScreen())!.then((value){
                                    setState(() {

                                    });
                                  });
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: AppColor.whiteColor.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: const Icon(Icons.edit,color: AppColor.whiteColor,)),
                              )
                          )
                        ]
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      margin: const EdgeInsets.only(left: 20,right: 20),
                      width: double.infinity,
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: const Icon(Icons.person,color: AppColor.appColor,)),
                            const SizedBox(height: 5,),
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: Text(data['employeeName'],style: const TextStyle(fontFamily: AppFonts.medium),)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      margin: const EdgeInsets.only(left: 20,right: 20),
                      width: double.infinity,
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: const Icon(Icons.email,color: AppColor.appColor,)),
                            const SizedBox(height: 5,),
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: Text(data['email'],style: const TextStyle(fontFamily: AppFonts.medium),)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      margin: const EdgeInsets.only(left: 20,right: 20),
                      width: double.infinity,
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: const Icon(Icons.phone_iphone_rounded,color: AppColor.appColor,)),
                            const SizedBox(height: 5,),
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: Text(data['mobile'],style: const TextStyle(fontFamily: AppFonts.medium),)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      margin: const EdgeInsets.only(left: 20,right: 20),
                      width: double.infinity,
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: const Icon(Icons.date_range_outlined,color: AppColor.appColor,)),
                            const SizedBox(height: 5,),
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: Text(data['dob'],style: const TextStyle(fontFamily: AppFonts.medium),)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      margin: const EdgeInsets.only(left: 20,right: 20),
                      width: double.infinity,
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: const Icon(Icons.location_city,color: AppColor.appColor,)),
                            const SizedBox(height: 5,),
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: Text(data['address'],style: const TextStyle(fontFamily: AppFonts.medium),)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: (){
                          showLogoutConfirmationDialog(context);
                          },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: ButtonMixin().stylishButton(
                            text: 'Logout'
                          ),
                        )
                    )
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return const Center(child: CircularProgressIndicator(),);
              } else{
                return const Center(child: CircularProgressIndicator(),);
              }
          }
        ),
      ),
    );
  }
}
