import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';


Widget dashboardDetailsWidget(
    String imageLocation, String title, String description,Color color) {
  return Card(
    elevation: 5,
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
       ),

      child: Container(
        padding: const EdgeInsets.only(left: 5),
        // height: 150,
        decoration:  BoxDecoration(

          borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
          gradient:  LinearGradient(
            colors: [
              color,
              color,
            ],
            begin: const FractionalOffset(0.1, 0.5),
            end: const FractionalOffset(0.1, 3.0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                  const EdgeInsets.only( top: 10),
                  child: Image.network(imageLocation,
                      height: 55, width: 55, fit: BoxFit.contain,color: AppColor.appColor,),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                       top: 20,),
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontFamily: AppFonts.medium),
                      textAlign: TextAlign.start),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5),
                  child: SizedBox(
                    width: 200,
                    child: Text(description,
                        style: const TextStyle(
                            fontSize: 12, fontFamily: AppFonts.medium),maxLines: 2,overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
}


// import 'package:employee_attendance_app/utils/app_fonts.dart';
// import 'package:flutter/material.dart';
//
// import '../../../utils/app_colors.dart';
//
// Widget DashboardDetailsWidget(
//     String imageLocation, String title, String description,Color color) {
//   return Card(
//       //elevation: 5,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//
//       //color: AppColor.whiteColor,
//       child: ClipPath(
//         child: Container(
//           padding: const EdgeInsets.only(left: 5),
//           height: 150,
//           decoration:  BoxDecoration(
//             border: Border(
//               left: BorderSide(color: color, width: 5),
//             ),
//             gradient: const LinearGradient(
//               colors: [
//                  Colors.white,
//                  Colors.tealAccent,
//               ],
//               begin: FractionalOffset(0.1, 0.6),
//               end: FractionalOffset(0.1, 2),
//               stops: [0.0, 1.0],
//               tileMode: TileMode.clamp,
//             ),
//           ),
//           child: Row(
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding:
//                           const EdgeInsets.only(left: 10, right: 60, top: 10),
//                       child: Image.asset(imageLocation,
//                           height: 60, width: 60, fit: BoxFit.contain),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                           left: 10, right: 40, top: 5, bottom: 10),
//                       child: Text(title,
//                           style: const TextStyle(
//                               fontSize: 16, fontFamily: AppFonts.Medium),
//                           textAlign: TextAlign.start),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ));
// }
