import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../firebase/firebase_collection.dart';
import '../../../login/provider/loading_provider.dart';

class AddEmployeeFireAuth {

  List<dynamic> employeeData = [];

  /*
  savePdf(asset, String name) async{
    try {
      print("Method calll ");
      final path = 'file/$name';
      // final file = File(asset.path);
      final prefs = await SharedPreferences.getInstance();
      String? number = prefs.getString("number");

      final ref = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadsTask =  ref.putData(asset);
      // UploadTask uploadsTask =  ref.putFile(asset.path);
      final snapshot = await uploadsTask.whenComplete(() {});

      final urlDownloads = await snapshot.ref.getDownloadURL().whenComplete(() {});
      if(urlDownloads.isNotEmpty){
        Map<String, dynamic> pdf = {"auth_id": currentUserId,"file_name": fileName, "link": urlDownloads,"phone_No": number, 'timestamp': DateTime.now()};
        await firestore.collection("pdfDetails").doc(draftsID).set(pdf).whenComplete(() => debugPrint("Success pdf.."));
        // singleton.pdfDetails(urlDownloads);
        // firestore.collection("drafts").doc(singleton.draftsID).update({"link" : urlDownloads}).whenComplete(() => debugPrint("Pdf Update"));
        // singleton.updateDrafts(urlDownloads);
      }

      debugPrint("PDF URL = $urlDownloads");
    } on Exception catch (e) {
      debugPrint("catch ${e.toString()}");
      // TODO
    }
  }
  */



  static Future<User?> registerEmployeeUsingEmailPassword({
    required String employeeName,
    required String email,
    required String password,
    required BuildContext context

  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateDisplayName(employeeName);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
        AppUtils.instance.showToast(toastMessage: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
        AppUtils.instance.showToast(toastMessage: "The account already exists for that email.");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return user;
  }

  static Future<User?> signInEmployeeUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
        AppUtils.instance.showToast(toastMessage: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided.');
        AppUtils.instance.showToast(toastMessage: 'Wrong password provided.');
      }
    }
    return user;
  }

  Future<void> addEmployee(
      {required String email,
        required String employeeName,
        required String mobile,
        required String dob,
        required String address,
        required String designation,
        required String department,
        required String branch,
        required String dateOfJoining,
        required String employmentType,
        required String exprience,
        required String manager,
        required String imageUrl,
        required String type}) async {
    DocumentReference documentReferencer = FirebaseCollection().employeeCollection.doc(email);
    print("Document Reference $documentReferencer");
    Map<String, dynamic> data = <String, dynamic>{
      "email": email.toString(),
      "employeeName": employeeName.toString(),
      "mobile": mobile.toString(),
      "dob": dob.toString(),
      "address": address.toString(),
      "designation": designation.toString(),
      "department": department.toString(),
      "branch": branch.toString(),
      "dateofjoining": dateOfJoining.toString(),
      "employment_type": employmentType.toString(),
      "imageUrl": imageUrl.toString(),
      "exprience": exprience.toString(),
      "manager": manager.toString(),
      "type": 'Employee'
    };
    debugPrint('employee data Map Object => $data');

    FirebaseCollection().employeeCollection.get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        // print(result.data());
        employeeData.add(result.data());
      }
    });
    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint("Added Employee Details"))
        .catchError((e) => debugPrint(e));
  }

}