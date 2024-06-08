import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:employee_attendance_app/employee/attendance_details/provider/attendance_details_provider.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//ignore: must_be_immutable
class AttendanceDetailsScreen extends StatefulWidget {
  AttendanceDetailsScreen({Key? key,required this.passType,required this.email}) : super(key: key);

  String passType,email;

  @override
  State<AttendanceDetailsScreen> createState() => _AttendanceDetailsScreenState();
}

class _AttendanceDetailsScreenState extends State<AttendanceDetailsScreen> {
  /*  var inOutTimeEmployee = FirebaseFirestore.instance.collection("employee")
       .doc(FirebaseAuth.instance.currentUser!.email).collection('InOutTime').snapshots();
*/
  dynamic inOutTimeEmployee;


  @override
  void initState() {
    // TODO: implement initState
    Provider.of<AttendanceDetailsProvider>(context,listen: false).onWillPop();
    super.initState();
    Provider.of<AttendanceDetailsProvider>(context, listen: false)
        .generateYearList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Attendance Details',style: TextStyle(fontFamily: AppFonts.bold),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Container(
              width: double.infinity,
              color: Colors.transparent,
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text('Month',style: TextStyle(fontFamily: AppFonts.medium),),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7.5, horizontal: 7.5),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.black)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          value: Provider.of<AttendanceDetailsProvider>(context,
                                  listen: false)
                              .selectMonth,
                          isDense: true,
                          // selectedItemHighlightColor: AppColor.backgroundColor,
                          // dropdownMaxHeight: 200,
                          style: const TextStyle(
                              color: AppColor.appBlackColor,
                              fontSize: 14,
                              fontFamily: AppFonts.medium),
                          dropdownStyleData: DropdownStyleData(
                              padding: const EdgeInsets.only(top: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),

                              ),
                              scrollbarTheme: const ScrollbarThemeData(
                                thickness: MaterialStatePropertyAll(3),
                              ),
                              maxHeight: 200,
                              useSafeArea: true,
                              isOverButton: false,
                              offset: const Offset(0, -10)
                          ),

                          // iconOnClick: const Icon(Icons.arrow_drop_up),
                          // icon: const Icon(Icons.arrow_drop_down),
                          // scrollbarRadius: const Radius.circular(40),
                          // scrollbarThickness: 3,
                          // scrollbarAlwaysShow: true,
                          // dropdownDecoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(10),
                          // ),
                          // buttonDecoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(10),
                          // ),
                          onChanged: (String? newValue) {
                            setState(() {
                              Provider.of<AttendanceDetailsProvider>(context,
                                      listen: false)
                                  .selectMonth = newValue!;
                              Provider.of<AttendanceDetailsProvider>(context,
                                      listen: false)
                                  .getMonth;
                            });
                          },
                          items: Provider.of<AttendanceDetailsProvider>(context,
                                  listen: false)
                              .monthItem
                              .map<DropdownMenuItem<String>>(
                                  (String leaveName) {
                            return DropdownMenuItem<String>(
                                value: leaveName,
                                child: Text(
                                  leaveName,
                                  style: const TextStyle(
                                    fontFamily: AppFonts.regular,
                                  ),
                                  textAlign: TextAlign.center,
                                ));
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              width: double.infinity,
              color: Colors.transparent,
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text('Year',style: TextStyle(fontFamily: AppFonts.medium)),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7.5, horizontal: 7.5),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.black)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          value: Provider.of<AttendanceDetailsProvider>(context,
                                  listen: false)
                              .selectYear,
                          dropdownStyleData: DropdownStyleData(
                              padding: const EdgeInsets.only(top: 0),
                                scrollbarTheme: const ScrollbarThemeData(
                                  thickness: MaterialStatePropertyAll(3),
                                ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              maxHeight: 200,
                              useSafeArea: true,
                              isOverButton: false,
                              offset: const Offset(0, -10)
                          ),

                          // dropdownMaxHeight: 200,
                          // selectedItemHighlightColor: AppColor.backgroundColor,
                          isDense: true,
                          style: const TextStyle(
                              color: AppColor.appBlackColor,
                              fontSize: 14,
                              fontFamily: AppFonts.medium),
                          // iconOnClick: const Icon(Icons.arrow_drop_up),
                          // icon: const Icon(Icons.arrow_drop_down),
                          // scrollbarRadius: const Radius.circular(40),
                          // scrollbarThickness: 3,
                          // scrollbarAlwaysShow: true,
                          // dropdownDecoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(10),
                          // ),
                          // buttonDecoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(10),
                          // ),
                          onChanged: (String? newValue) {
                            setState(() {
                              Provider.of<AttendanceDetailsProvider>(context,
                                      listen: false)
                                  .selectYear = newValue!;
                              Provider.of<AttendanceDetailsProvider>(context,
                                      listen: false)
                                  .getYear;
                            });
                          },
                          items: Provider.of<AttendanceDetailsProvider>(context,
                                  listen: false)
                              .years
                              .map<DropdownMenuItem<String>>(
                                  (String leaveName) {
                            return DropdownMenuItem<String>(
                                value: leaveName,
                                child: Text(
                                  leaveName,
                                  style: const TextStyle(
                                      fontFamily: AppFonts.regular),
                                ));
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.only(left: 25),
                    child: const Text('Filtered data',style: TextStyle(fontSize: 18,fontFamily: AppFonts.medium),)),
                // Container(
                //     margin: const EdgeInsets.only(right: 20),
                //     child: TextButton(onPressed: (){
                //       setState((){
                //         debugPrint(DateFormat.yMMMM().format(DateTime.now()));
                //         debugPrint(Provider.of<AttendanceDetailsProvider>(context,listen: false).selectMonth);
                //         debugPrint(Provider.of<AttendanceDetailsProvider>(context,listen: false).selectYear);
                //         debugPrint('${Provider.of<AttendanceDetailsProvider>(context,listen: false).selectMonth} ${Provider.of<AttendanceDetailsProvider>(context,listen: false).selectYear}');
                //         inOutTimeEmployee = FirebaseFirestore.instance.collection("employee")
                //             .doc(FirebaseAuth.instance.currentUser!.email).collection('InOutTime').
                //         where('yearMonth',isEqualTo: '${Provider.of<AttendanceDetailsProvider>(context,listen: false).selectMonth} ${Provider.of<AttendanceDetailsProvider>(context,listen: false).selectYear}').snapshots();
                //       });
                //     }, child: const Text('Go',style: TextStyle(fontFamily: AppFonts.medium),))),
              ],
            ),
            const SizedBox(height: 10,),
            const Divider(height: 1,thickness: 1),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("employee")
                    .doc('${widget.passType=='Admin' ? widget.email : FirebaseAuth.instance.currentUser!.email}').collection('InOutTime').
                where('yearMonth',isEqualTo: '${Provider.of<AttendanceDetailsProvider>(context,listen: false).selectMonth} ${Provider.of<AttendanceDetailsProvider>(context,listen: false).selectYear}').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
                  } else{
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context,index) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator());
                          }else{
                            return Container(
                              margin: const EdgeInsets.only(left: 10,right: 10),
                              child: Card(
                                child: ExpansionTile(
                                  textColor: AppColor.appColor,
                                  iconColor: AppColor.appColor,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  childrenPadding:
                                  const EdgeInsets.symmetric(vertical: 0, horizontal: 70),
                                  expandedCrossAxisAlignment: CrossAxisAlignment.end,
                                  maintainState: true,
                                  title: Text('${snapshot.data?.docs[index]['currentDate']}',style: const TextStyle(fontSize: 18,fontFamily: AppFonts.medium)),
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('In Time',style: TextStyle(fontFamily: AppFonts.medium),),
                                              const Text('Out Time',style: TextStyle(fontFamily: AppFonts.medium)),
                                              const Text('Duration',style: TextStyle(fontFamily: AppFonts.medium)),
                                            ],
                                          ) ,
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${snapshot.data?.docs[index]['inTime']}',style: const TextStyle(fontFamily: AppFonts.medium)),
                                              Text('${snapshot.data?.docs[index]['outTime']}',style: const TextStyle(fontFamily: AppFonts.medium)),
                                              Text('${snapshot.data?.docs[index]['duration']}',style: const TextStyle(fontFamily: AppFonts.medium)),
                                            ],
                                          )
                                        ],)
                                    ],
                                ),
                              ),
                            );
                          }
                        }
                    );
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}
