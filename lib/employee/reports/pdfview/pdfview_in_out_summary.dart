import 'dart:typed_data';
import 'package:employee_attendance_app/employee/reports/provider/reports_provider.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import '../../inOut/auth/in_out_fire_auth.dart';

class PdfViewInOutSummary extends ChangeNotifier{

  /* Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = (await getExternalStorageDirectory())?.path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');
  }
*/
  Future<Uint8List> makePdfInOutSummary(fromDate,toDate,BuildContext? context) async {
    final pdf = pw.Document();
    var querySnapshots = await InOutFireAuth().mainCollection.get();
    var leaveCollection = await FirebaseCollection().leaveCollection.get();
    var providerData = Provider.of<ReportsProvider>(context!,listen: false);
    String? inTime,outTime,duration;

    //querySnapshots.docChanges.where((element) => element.doc.get('inTime'));

 /*   List inTimeList = [];
    for (var snapshot in querySnapshots.docChanges){
      print(snapshot.doc.get("inTime"));
      inTime = snapshot.doc.get("inTime");
      inTimeList.add(snapshot.doc.get("inTime"));
      outTime = snapshot.doc.get("outTime");
      duration = snapshot.doc.get("duration");
    }
*/

    pdf.addPage(
        pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            header: (pw.Context context) {
              return pw.Container(
                  alignment: pw.Alignment.topCenter,
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                  child: pw.Text('IN OUT DETAILS',style: const pw.TextStyle(fontSize: 20)));
            },
            build: (pw.Context context) {
              return <pw.Widget>[
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.SizedBox(height: 20),
                      pw.Row(
                          children: [
                            pw.Text('COMPANY NAME : ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(width: 5),
                            pw.Text('ELSNER TECHNOLOGIES PVT LTD'),
                            pw.Spacer(),
                            pw.Text('Print Date : ',style:  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(width: 5),
                            pw.Text(DateTime.now().toString().substring(0,10)),
                          ]
                      ),
                      pw.SizedBox(height: 10),
                      pw.Row(
                          children: [
                            pw.Text('COMPANY ADDRESS : ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(width: 5),
                            pw.Text('AHMEDABAD'),
                            pw.Spacer(),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Row(
                                      children: [
                                        pw.Text('From Date : ',style:  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                        pw.SizedBox(width: 5),
                                        pw.Text(fromDate),
                                      ]
                                  ),
                                  pw.Row(
                                      children: [
                                        pw.Text('To Date : ',style:  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                        pw.SizedBox(width: 5),
                                        pw.Text(toDate),
                                      ]
                                  )
                                ]
                            ),
                          ]
                      ),
                      pw.SizedBox(height: 10),

                      pw.Table(
                          border: pw.TableBorder.all(width: 1),
                          children: [
                            pw.TableRow(
                                children: [
                                  pw.Column(children: [pw.Text('SR.')]),
                                  pw.Column(children: [pw.Text('ON DATE')]),
                                  pw.Column(children: [pw.Text('SHIFT TIME'),pw.Divider(height: 1),
                                      pw.Row(
                                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                          children: [
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.only(left: 12),
                                              child: pw.Text('From'),
                                            ),
                                            pw.Container(
                                              height: 20,
                                              color: const PdfColor(0, 0, 0, 0), width: 1),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.only(right: 20),
                                              child: pw.Text('To'),
                                            ),
                                          ]
                                      )
                                  ]),

                                  pw.Column(children: [pw.Text('ACTUAL TIME'),pw.Divider(height: 1),
                                    pw.Row(
                                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                                        children: [
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.only(left: 20,right: 7),
                                            child: pw.Text('From'),
                                          ),
                                          pw.Container(
                                              height: 20,
                                              color: const PdfColor(0, 0, 0, 0), width: 1),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.only(right: 12,left: 10),
                                            child: pw.Text('To'),
                                          ),
                                          pw.Container(
                                              height: 20,
                                              color: const PdfColor(0, 0, 0, 0), width: 1),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.only(right: 10),
                                            child: pw.Text('Duration'),
                                          ),
                                        ]
                                    )
                                  ]),
                                  pw.Column(children: [pw.Text('LEAVE')]),
                                ]),

                            for(int i=providerData.reportsFromDate.day;i<=providerData.reportsToDate.day;i++)...{
                              pw.TableRow(
                                  children: [

                                    pw.Column(children: [pw.Text('$i')]),
                                    pw.Column(children: [pw.Text("${i.toString().length == 1 ? '0$i' : i}"
                                        "-${providerData.reportsFromDate.month.toString().length != 1 ? providerData.reportsFromDate.month :
                                    '0${providerData.reportsFromDate.month}'}"
                                        "-${providerData.reportsFromDate.year}")]),

                                    pw.Column(children: [
                                      pw.Row(
                                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.SizedBox(width: 7),
                                          pw.Text('9.45'),
                                          pw.Container(
                                              height: 13,
                                              color: const PdfColor(0, 0, 0, 0), width: 1),
                                          pw.Text('7.15'),
                                          pw.SizedBox(width: 2),
                                        ]
                                    )]),
                                    pw.Column(children: [
                                      pw.Row(
                                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                          children: [
                                            pw.SizedBox(width: 5,),
                                          /*  for(var data in inTimeList)...{
                                              pw.Text(' ${data}') },
*/
                                            pw.Column(
                                              children: [
                                                ...querySnapshots.docs.map((e){
                                                  inTime = e['inTime'];
                                                  debugPrint('InTime => ${e["inTime"]}');
                                                  return e['currentDate'] == "${providerData.reportsFromDate.year}""-${providerData.reportsFromDate.month
                                                      .toString().length != 1 ? providerData.reportsFromDate.month :
                                                  '0${providerData.reportsFromDate.month}'}"
                                                      "-${i.toString().length == 1 ? '0$i' : i}"
                                                      ? inTime != '' ? pw.Text('$inTime') : pw.Text('') : pw.Text('');
                                                },),
                                              ]
                                            ),

                                            pw.Container(
                                                height: 13,
                                                color: const PdfColor(0, 0, 0, 0), width: 1),


                                            /*querySnapshots.docs.map((e) =>
                                            e['currentDate']

                                                ==  "${providerData.reportsFromDate.year}"
                                                "-${providerData.reportsFromDate.month.toString().length != 1 ? providerData.reportsFromDate.month :
                                            '0${providerData.reportsFromDate.month}'}"
                                                "-${i.toString().length == 1 ? '0$i' : i}"?
                  *//*                          FirebaseCollection().inOutCollection.doc(
              "${providerData.reportsFromDate.year}"
              "-${providerData.reportsFromDate.month.toString().length != 1 ? providerData.reportsFromDate.month :
              '0${providerData.reportsFromDate.month}'}"
              "-${i.toString().length == 1 ? '0$i' : i}"
              ).id*//*
                                            e['inTime']                        : ''

                                            )*/

                                            pw.Column(
                                                children: [
                                                  ...querySnapshots.docs.map((e){
                                                    outTime = e['outTime'];
                                                    debugPrint('outTime => ${e["outTime"]}');
                                                    return e['currentDate'] == "${providerData.reportsFromDate.year}""-${providerData.reportsFromDate.month
                                                        .toString().length != 1 ? providerData.reportsFromDate.month :
                                                    '0${providerData.reportsFromDate.month}'}"
                                                        "-${i.toString().length == 1 ? '0$i' : i}"
                                                        ? outTime != '' ? pw.Text('$outTime') : pw.SizedBox(width: 29) : pw.Text('');
                                                  },),
                                                ]
                                            ),
                                            pw.Container(
                                                height: 13,
                                                color: const PdfColor(0, 0, 0, 0), width: 1),
                                            pw.Column(
                                                children: [
                                                  ...querySnapshots.docs.map((e){
                                                    duration = e['duration'];
                                                    return e['currentDate'] == "${providerData.reportsFromDate.year}""-${providerData.reportsFromDate.month
                                                        .toString().length != 1 ? providerData.reportsFromDate.month :
                                                    '0${providerData.reportsFromDate.month}'}"
                                                        "-${i.toString().length == 1 ? '0$i' : i}"
                                                        ? duration != '' ? pw.Text('$duration') : pw.Text('') : pw.Text('');
                                                  },),
                                                ]
                                            ),
                                            pw.SizedBox(width: 5,),
                                          ]
                                      )
                                    ]),
                                    pw.Column(
                                        children: [
                                          ...leaveCollection.docs.map((e){
                                            return e['leaveForm'] == "${providerData.reportsFromDate.year}""-${providerData.reportsFromDate.month
                                                .toString().length != 1 ? providerData.reportsFromDate.month :
                                            '0${providerData.reportsFromDate.month}'}"
                                                "-${i.toString().length == 1 ? '0$i' : i}"
                                                ? duration != '' ? pw.Text('${e['leaveType']}') : pw.Text('') : pw.Text('');
                                          },),
                                        ]
                                    ),
                                  ]),
                            }
                          ]
                      ),

                    ])];
            }));
    return await pdf.save();

    //saveAndShared(bytes, 'In Out Summary Reports.pdf');
    // return await pdf.save();
  }

}