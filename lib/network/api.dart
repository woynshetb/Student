import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:student/model/api_response.dart';
import 'package:student/model/student.dart';

class ApiClient {
  ApiClient();
  Future<ApiResponse> add(
      {required int nextStudentId,
      required String firstName,
      required String lastName,
      required DateTime birthdate,
      required File studentImageFile}) async {
    try {
      String fileName = '$nextStudentId.jpg';
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(studentImageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      final studentReference =
          await FirebaseFirestore.instance.collection('students').add({
        'id': nextStudentId,
        'firstname': firstName,
        'lastname': lastName,
        'birthdate': birthdate,
        'photo': imageUrl,
      });

      return ApiResponse(
          code: 200,
          body: studentReference,
          message: 'Student profile data added to Firestore.');
    } catch (e) {
      return ApiResponse(
          code: 404,
          body: e,
          message: 'Student profile data added to Firestore.');
    }
  }

  Future update(
      {required Student student,
      required String firstName,
      required String lastName,
      required DateTime birthdate,
      required File studentImageFile}) async {
    try {
      DocumentReference studentRef =
          FirebaseFirestore.instance.collection('students').doc(student.docId);

      if (student.photoUrl.isNotEmpty) {
        try {
          Reference firebaseStorageRef =
              FirebaseStorage.instance.refFromURL(student.photoUrl);

          await firebaseStorageRef.delete();
        } catch (e) {
          debugPrint("photo is doesnot exist in storage ");
        }
      }
      String fileName = '${student.id}.jpg';

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(studentImageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      await studentRef.update({
        'firstname': firstName,
        'lastname': lastName,
        'birthdate': birthdate,
        'photo': imageUrl,
      });
      return ApiResponse(
          code: 200,
          body: studentRef,
          message: 'Student updated successfully!');
    } catch (e) {
      return ApiResponse(code: 404, body: e, message: 'Error updating student');
    }
  }

  Future<ApiResponse> updateWithoutImage({
    required Student student,
    required String firstName,
    required String lastName,
    required DateTime birthdate,
    required String imageUrl,
  }) async {
    try {
      DocumentReference studentRef =
          FirebaseFirestore.instance.collection('students').doc(student.docId);
      await studentRef.update({
        'firstname': firstName,
        'lastname': lastName,
        'birthdate': birthdate,
        'photo': imageUrl,
      });
      return ApiResponse(
          code: 200,
          body: studentRef,
          message: 'Student updated successfully!');
    } catch (e) {
      return ApiResponse(code: 404, body: e, message: 'Error updating student');
    }
  }

  Future<ApiResponse> delete({required Student student}) async {
    try {
      if (student.photoUrl.isNotEmpty) {
        Reference firebaseStorageRef =
            FirebaseStorage.instance.refFromURL(student.photoUrl);
        await firebaseStorageRef.delete();
      }
      await FirebaseFirestore.instance
          .collection('students')
          .doc(student.docId)
          .delete();

      return ApiResponse(
          code: 200, body: "", message: 'Student deleted successfully!');
    } catch (e) {
      return ApiResponse(
          code: 404, body: "", message: 'Error deleting student: $e');
    }
  }
}
