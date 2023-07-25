
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:student/model/api_response.dart';

import 'package:student/model/student.dart';
import 'package:student/network/api.dart';
import 'package:student/view/home_page.dart';

import 'package:student/view_model/base_vm.dart';

import 'package:student/widgets/customButton.dart';

class StudentVM extends MyBaseViewModel {
  StudentVM(BuildContext context) {
    viewContext = context;
  }

  List<Student> students = [];

  deletStudent(Student student) {
    AwesomeDialog(
        context: viewContext!,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        dialogType: DialogType.NO_HEADER,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(viewContext!).size.width * 0.1,
              height: MediaQuery.of(viewContext!).size.width * 0.1,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 5),
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: MediaQuery.of(viewContext!).size.width * 0.08,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(viewContext!).size.height * 0.02,
            ),
            Text(
              "Delete",
              style: TextStyle(
                  fontSize: MediaQuery.of(viewContext!).size.width * 0.038,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(viewContext!).textTheme.bodyText1!.color),
            ),
            SizedBox(
              height: MediaQuery.of(viewContext!).size.height * 0.01,
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "Are you sure you want to delete this student ? This Action can not be undone",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: MediaQuery.of(viewContext!).size.width * 0.032),
                )),
            SizedBox(
              height: MediaQuery.of(viewContext!).size.height * 0.015,
            ),
            Divider(
              color: Theme.of(viewContext!).primaryColor.withOpacity(0.5),
            ),
            SizedBox(
              height: MediaQuery.of(viewContext!).size.height * 0.015,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  height: MediaQuery.of(viewContext!).size.height * 0.04,
                  width: MediaQuery.of(viewContext!).size.width * 0.16,
                  title: "Yes",
                  backgroundColor: Colors.red,
                  onPressed: () async {
                    Navigator.pop(viewContext!);
                    setBusy(true);

                    notifyListeners();
                    
                        await ApiClient().delete(student: student).then((value) => {
                          Navigator.push(viewContext!, MaterialPageRoute(builder: (context)=>HomePage()))
                        });
                    setBusy(false);
                    notifyListeners();
                  },
                ),
                CustomButton(
                  height: MediaQuery.of(viewContext!).size.height * 0.04,
                  width: MediaQuery.of(viewContext!).size.width * 0.16,
                  title: "No",
                  backgroundColor: Color(0xffB0CFE0),
                  onPressed: () {
                    Navigator.pop(viewContext!);
                  },
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(viewContext!).size.height * 0.015,
            ),
          ],
        )).show();
  }
}
