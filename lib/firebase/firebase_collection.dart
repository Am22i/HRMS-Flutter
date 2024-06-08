import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCollection {

  final adminCollection = FirebaseFirestore.instance.collection('admin');
  CollectionReference employeeCollection = FirebaseFirestore.instance.collection('employee');
  CollectionReference holidayCollection = FirebaseFirestore.instance.collection('holiday');
  var inOutCollection = FirebaseFirestore.instance.collection('employee').doc(FirebaseAuth.instance.currentUser?.email).collection('InOutTime');
  var leaveCollection = FirebaseFirestore.instance.collection('leave');
  CollectionReference trainingProgramsCollection = FirebaseFirestore.instance.collection('trainingAndDevelopments');
  CollectionReference grievancesCollection = FirebaseFirestore.instance.collection('Grievances');

}