import 'package:employee_attendance_app/admin/addholiday/auth/add_holiday_fire_auth.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../mixin/button_mixin.dart';
import '../../../utils/app_colors.dart';
import '../../../widget/admin_bottom_navigationbar.dart';
import '../provider/add_holiday_provider.dart';

class AddHolidayScreen extends StatefulWidget {
  const AddHolidayScreen({Key? key}) : super(key: key);

  @override
  State<AddHolidayScreen> createState() => _AddHolidayScreenState();
}

class _AddHolidayScreenState extends State<AddHolidayScreen> {

  TextEditingController holidayNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  bool selectDateVal = false;
  bool fromDateValidation = false;

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<AddHolidayProvider>(context,listen: false).picked = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          title: const Text('Add Public Holiday',style: TextStyle(fontFamily: AppFonts.bold),),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30),

                Container(
                    padding: const EdgeInsets.only(left: 25,bottom: 5),
                    child: const Text('Holiday Date',style: TextStyle(fontFamily: AppFonts.medium))),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: fromDateValidation== true ? AppColor.redColor : AppColor.darkGreyColor),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  margin: const EdgeInsets.only(left: 20,right: 20),
                  padding: const EdgeInsets.only(top:15,bottom: 15),
                  child: Consumer<AddHolidayProvider>(builder: (_, snapshot, __) {
                    return GestureDetector(
                      onTap : () => snapshot.selectDate(context),
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  const Icon(Icons.date_range_outlined,color: AppColor.appColor,),
                                  const SizedBox(width: 10),
                                  Text(snapshot.picked==null? 'Please Select Date' : DateFormat('dd-MM-yyyy').format(snapshot.holidayDate),style: const TextStyle(fontFamily: AppFonts.regular)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 4,),
                Visibility(
                    visible: fromDateValidation== false ? false : true,
                    child: const Padding(
                        padding: EdgeInsets.only(left: 30),
                        child:  Text('Please choose date',style: TextStyle(fontSize: 12,color: AppColor.redColor,fontFamily: AppFonts.regular),))),
                const SizedBox(height: 10),

                Container(
                    padding: const EdgeInsets.only(left: 25,bottom: 5,top: 10),
                    child: const Text('Holiday Name',style: TextStyle(fontFamily: AppFonts.medium))),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    cursorColor:  AppColor.appColor,
                    style: const TextStyle(fontFamily: AppFonts.medium),
                    keyboardType: TextInputType.multiline,
                    controller: holidayNameController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.fromLTRB(10, 00, 00, 00),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.appColor),
                      ),),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter holiday name';
                      }
                      else if(value.trim().isEmpty){
                        return "Please enter holiday name";
                      }
                      return null;
                    },
                  ),
                ),

                Container(
                    padding: const EdgeInsets.only(left: 25,bottom: 5,top: 15),
                    child: const Text('Description',style: TextStyle(fontFamily: AppFonts.medium),)),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Scrollbar(
                    child: TextFormField(
                      cursorColor:  AppColor.appColor,
                      maxLines: null,
                      style: const TextStyle(fontFamily: AppFonts.medium,fontSize: 14),
                      keyboardType: TextInputType.multiline,
                      controller: descriptionController,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(10, 00, 00, 00),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.appColor),
                        ),),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter description';
                        }else if(value.trim().isEmpty){
                          return "Please enter description";
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () async {
                      setState((){
                        fromDateValidation = true;
                      });
                      if(Provider.of<AddHolidayProvider>(context,listen: false).picked !=null){
                        setState((){
                          fromDateValidation = false;
                        });
                      }
                      /*setState((){
                        selectDateVal = true;
                      });
                      if(Provider.of<AddHolidayProvider>(context,listen: false).picked !=null){
                        setState((){
                          selectDateVal = false;
                        });
                      }*/
                      if(_formKey.currentState!.validate() && Provider.of<AddHolidayProvider>(context,listen: false).picked !=null) {
                        AddHolidayFireAuth().addPublicHoliday(holidayDate: DateFormat('dd-MM-yyyy').format(Provider.of<AddHolidayProvider>(context,listen: false).holidayDate),
                            holidayName: holidayNameController.text.trim(),
                            holidayDescription: descriptionController.text.trim());
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const AdminBottomNavBarScreen()), (route) => false);
                        Provider.of<AddHolidayProvider>(context,listen: false).picked =null;
                        holidayNameController.clear();
                        descriptionController.clear();
                      }
                    },
                    child: ButtonMixin()
                        .stylishButton(onPress: () {}, text: 'Add Holiday'),
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
