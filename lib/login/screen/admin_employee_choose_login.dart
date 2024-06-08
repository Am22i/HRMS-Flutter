import 'package:employee_attendance_app/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class AdminEmployeeChooseLoginScreen extends StatelessWidget {
  const AdminEmployeeChooseLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Image.network(
                'https://png.pngtree.com/png-vector/20201203/ourlarge/pngtree-penguin-with-christmas-hat-background-png-image_2508812.jpg',
                height: 300),
            const SizedBox(height: 20),
            const Text(
              'Choose a Admin or Employee',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 34.0),
              child: Text(
                'rofessor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18,wordSpacing: -1),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: ()=> Get.to(LoginScreen()),
                  child: Container(
                    padding: const EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [AppColor.appColor, AppColor.greyColorLight])),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10),
                      child: Text("Admin",
                          style: TextStyle(
                              letterSpacing: 0.5,
                              color: Colors.black,
                              )),
                    ),
                  ),
                ),
                Container(width:1,height: 50,color: AppColor.appBlackColor),
                GestureDetector(
                  onTap: ()=> Get.to(LoginScreen()),
                  child: Container(
                    padding: const EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [AppColor.greyColorLight, AppColor.appColor])),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10),
                      child: Text("Employee",
                          style: TextStyle(
                              letterSpacing: 0.5,
                              color: Colors.black,
                          )),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
