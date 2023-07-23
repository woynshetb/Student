import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:student/model/student.dart';

class MyBaseViewModel extends BaseViewModel {
  BuildContext? viewContext;
  PermissionStatus? permissionStatus;
  final imagePicker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  initialise() {}

  Future<DateTime?> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: viewContext!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), 
      lastDate: DateTime(2101), 

      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    if (picked != null && picked != DateTime.now()) {
      return picked;
    } else {
      return null;
    }
  }



  Future<XFile?> handleImageFromGallery() async {
    permissionStatus = await Permission.photos.request();
    if (permissionStatus == PermissionStatus.granted) {
      final image = await imagePicker.pickImage(
          source: ImageSource.gallery, maxHeight: 400, maxWidth: 400);

      return image;
    }
  }

  Future<XFile?> handleImageFromCamera() async {
    permissionStatus = await Permission.camera.request();
    final image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 400,
      maxWidth: 400,
    );
    if (permissionStatus == PermissionStatus.granted) {
      return image;
    }
  }

  Future<int> getNextStudentId() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .orderBy('id', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Student lastStudent = Student.fromFirestore(querySnapshot.docs.first);
        return lastStudent.id + 1;
      }
      return 1;
    } catch (e) {
      debugPrint('Error getting next student ID: $e');
      return 1;
    }
  }
}
