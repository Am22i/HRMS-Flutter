import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';


/*
import 'package:employee_attendance_app/employee/reports/provider/reports_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewInOutPresent extends StatefulWidget {
  late String fromDate,toDate,currentDate,designation,employeeName,department;
  String presentDays;

  PdfViewInOutPresent(this.fromDate, this.toDate, this.currentDate,this.employeeName,
  this.department,this.designation,this.presentDays, {Key? key}) : super(key: key);

  @override
  State<PdfViewInOutPresent> createState() => _PdfViewInOutPresentState();
}

class _PdfViewInOutPresentState extends State<PdfViewInOutPresent> {

  PdfViewerController? controller = PdfViewerController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ReportsProvider>(context,listen:false).makePdf(widget.fromDate,widget.toDate,widget.currentDate,
        widget.employeeName,widget.designation,widget.department,widget.presentDays).then((value) {
      setState((){
        Provider.of<ReportsProvider>(context,listen:false).pdf = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        */
/*body: SfPdfViewer.memory(
            Provider.of<ReportsProvider>(context, listen: false).pdf,
            scrollDirection : PdfScrollDirection.horizontal,
          controller: controller,
        )*//*

    );
  }
}
*/

class PdfViewInOutPresent{

  /*Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = (await getExternalStorageDirectory())?.path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');
  }*/

  Future<Uint8List> makePdfInOutPresent(
      {required dynamic fromDate,
        required dynamic toDate,
        required dynamic printDate,
        required dynamic employeeName,
        required dynamic designation,
        required dynamic department,
      presentDays}) async {
    final pdf = pw.Document();
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
                  child: pw.Text('EMPLOYEE PRESENT DAYS REPORT',style: const pw.TextStyle(fontSize: 20)));
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
                            pw.Text(printDate),
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
                                  pw.Column(children: [pw.Text('EMPLOYEES NAME')]),
                                  pw.Column(children: [pw.Text('DESIGNATION')]),
                                  pw.Column(children: [pw.Text('DEPARTMENT')]),
                                  pw.Column(children: [pw.Text('PRESENT DAYS')]),
                                  pw.Column(children: [pw.Text('OD DAYS')]),
                                ]),
                            pw.TableRow(
                                children: [
                                  pw.Column(children: [pw.Text('1')]),
                                  pw.Column(children: [pw.Text(employeeName)]),
                                  pw.Column(children: [pw.Text(designation)]),
                                  pw.Column(children: [pw.Text(department)]),
                                  pw.Column(children: [pw.Text(presentDays)]),
                                  pw.Column(children: [pw.Text('0.0')]),
                                ]),
                          ]
                      ),
                    ])];
            }));
    //List<int> bytes = await pdf.save();
    //saveAndLaunchFile(bytes, 'Reports.pdf');
    return await pdf.save();
  }

}
