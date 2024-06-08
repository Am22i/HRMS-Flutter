import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

class PublicHolidayScreen extends StatefulWidget {

  PublicHolidayScreen({Key? key}) : super(key: key);

  @override
  State<PublicHolidayScreen> createState() => _PublicHolidayScreenState();
}

class _PublicHolidayScreenState extends State<PublicHolidayScreen> {
  var pubilcHolidayDetails = FirebaseFirestore.instance.collection("holiday").snapshots();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text(
          'Public Holiday',
          style: TextStyle(fontFamily: AppFonts.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: pubilcHolidayDetails,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (streamSnapshot.hasError) {
              return const Center(
                  child: Text("Something went wrong",
                      style: TextStyle(fontFamily: AppFonts.regular)));
            } else if (streamSnapshot.connectionState == ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (streamSnapshot.requireData.docChanges.isEmpty ||
                !streamSnapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.calendar_today, size: 60, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No holidays for the current year",
                      style: TextStyle(
                          fontFamily: AppFonts.regular,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Check back later for updates!",
                      style: TextStyle(
                          fontFamily: AppFonts.regular,
                          color: Colors.grey,
                          fontSize: 14),
                    ),
                  ],
                ),
              );
            } else {
              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                  holidayDocuments = streamSnapshot.data?.docs ?? [];
              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                  currentYearHolidayDocuments = holidayDocuments.where((doc) {
                // Assuming your date field is called "holidayDate" in the Firestore document
                String dateString = doc['holidayDate'];
                // Split the date string into day, month, and year components
                List<String> dateComponents = dateString.split('-');
                if (dateComponents.length == 3) {
                  int day = int.parse(dateComponents[0]);
                  int month = int.parse(dateComponents[1]);
                  int year = int.parse(dateComponents[2]);
                  DateTime holidayDate = DateTime(year, month, day);
                  return holidayDate.year == DateTime.now().year;
                }
                return false;
              }).toList();
              currentYearHolidayDocuments.sort((a, b) {
                String dateA = a['holidayDate'];
                String dateB = b['holidayDate'];

                List<String> dateComponentsA = dateA.split('-');
                List<String> dateComponentsB = dateB.split('-');

                int yearA = int.parse(dateComponentsA[2]);
                int monthA = int.parse(dateComponentsA[1]);
                int dayA = int.parse(dateComponentsA[0]);

                int yearB = int.parse(dateComponentsB[2]);
                int monthB = int.parse(dateComponentsB[1]);
                int dayB = int.parse(dateComponentsB[0]);

                if (yearA != yearB) {
                  return yearA.compareTo(yearB);
                } else if (monthA != monthB) {
                  return monthA.compareTo(monthB);
                } else {
                  return dayA.compareTo(dayB);
                }
              });
              if (currentYearHolidayDocuments.isEmpty) {
                currentYearHolidayDocuments.clear();
                holidayDocuments.clear();
              }
              if (streamSnapshot.data!.docs.isEmpty || streamSnapshot.data!.docs.length == 0) {
                currentYearHolidayDocuments.clear();
                holidayDocuments.clear();
              }
              print("length :- ${streamSnapshot.data!.docs.length}");
              return ListView.builder(
                  itemCount: currentYearHolidayDocuments.length,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      color: AppColor.listingBgColor,
                      elevation: 0.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Container(
                                height: 60,
                                width: 60,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                      fontFamily: AppFonts.medium,
                                      color: Colors.white,
                                      fontSize: 20),
                                )),
                            trailing: Text(
                              '${currentYearHolidayDocuments[index]['holidayDate']}',
                              style: const TextStyle(
                                fontFamily: AppFonts.medium,
                              ),
                            ),
                            title: Text(
                              '${currentYearHolidayDocuments[index]['holidayName']}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: AppFonts.medium,
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 1,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('${streamSnapshot.data?.docs[index]['holidayDescription']}',
                                Text(
                                    '${currentYearHolidayDocuments[index]['holidayDescription']}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: AppFonts.medium),
                                    maxLines: 2),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
          }),
    );
  }
}
