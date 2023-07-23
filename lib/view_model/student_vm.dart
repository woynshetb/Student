import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:student/model/api_response.dart';
import 'package:student/model/student.dart';
import 'package:student/network/api.dart';
import 'package:student/view_model/base_vm.dart';

class StudentVM extends MyBaseViewModel {
  StudentVM(BuildContext context) {
    viewContext = context;
  }

  List<Student> students = [];

  deletStudent(Student student) {
    AwesomeDialog(
        context: viewContext!,
        dialogType: DialogType.WARNING,
        desc:
            "Are you sure you want to delete this student ? This Action can not be undone ",
        btnOkOnPress: () async {
          setBusy(true);
          notifyListeners();
          ApiResponse apiResponse = await ApiClient().delete(student: student);
          setBusy(false);
          notifyListeners();
        },
        btnCancelOnPress: () {
          Navigator.pop(viewContext!);
        }).show();
  }
}
