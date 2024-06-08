import 'package:employee_attendance_app/admin/home/screen/admin_home_screen.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import '../admin/adminProfile/admin_profile.dart';
import '../utils/app_colors.dart';

class AdminBottomNavBarScreen extends StatefulWidget {
  const AdminBottomNavBarScreen({super.key});

  @override
  State<AdminBottomNavBarScreen> createState() => _AdminBottomNavBarScreenState();
}

class _AdminBottomNavBarScreenState extends State<AdminBottomNavBarScreen> {

  int _selectedIndex=0;
  String imageUrl="https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg";
  List<Widget> buildScreen(){
    return [
       AdminHomeScreen(),
      const AdminProfile()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      body: buildScreen().elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        backgroundColor: AppColor.whiteColor,
        selectedLabelStyle: const TextStyle(color: AppColor.appColor,fontFamily: AppFonts.bold),
        unselectedLabelStyle: const TextStyle(color: AppColor.appBlackColor,fontFamily: AppFonts.regular),
        selectedItemColor: AppColor.appColor,
        unselectedItemColor: AppColor.greyColor,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home,size: 30,
              )),
          BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(Icons.person,size: 30,
              )),
        ],
      ),
    );
  }
}
