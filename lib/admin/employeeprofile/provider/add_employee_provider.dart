/*
import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddEmployeeProvider extends ChangeNotifier{
  File? file;
  String imageUrl = '';
  String url = '';

  void uploadFile() async {

    //Pick Image File
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image
    );
    if(result == null) return;
    final filePath = result.files.single.path;
    file = File([],filePath!);
    notifyListeners();

    //Store Image in firebase database
    if (file == null) return;
    final fireauth = FirebaseAuth.instance.currentUser!.email;
    final destination = 'images/$fireauth';
    try {

      final ref = FirebaseStorage.instance.ref().child(destination);
      await ref.putFile(file,SettableMetadata(contentType: 'video/mp4'));
      // var dowurl = await (await ref.putFile(file!).whenComplete(() => ref.getDownloadURL()));
      print("Image Upload");

      //  final ref1 =
      //  FirebaseStorage.instance.ref().child("images/${FirebaseAuth.instance.currentUser!.email}.jpg");
      url = (await ref.getDownloadURL()).toString();
      print(url);

    } catch (e) {
      print('error occurred');
    }
  }

}*/
