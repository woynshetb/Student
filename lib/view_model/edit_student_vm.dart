import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student/model/api_response.dart';
import 'package:student/model/student.dart';
import 'package:student/network/api.dart';
import 'package:student/view/home_page.dart';
import 'package:student/view_model/base_vm.dart';

class EditStudentVM extends MyBaseViewModel {
  Student? studentIntials;
  EditStudentVM(BuildContext context, Student studentIntials) {
    viewContext = context;
    studentIntials = studentIntials;
  }
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  DateTime birthDateController = DateTime.now();
  String imageUrl = "";
  File? selectedProfileImage;

  

  updateProfile(Student student) async {
    if (formKey.currentState!.validate()&& selectedProfileImage!=null) {
      setBusy(true);
      ApiResponse apiResponse = await ApiClient().update(
          student: student,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          birthdate: birthDateController,
          studentImageFile: selectedProfileImage!);

      if (apiResponse.code == 200) {
        Navigator.push(viewContext!, MaterialPageRoute(builder: (context)=>HomePage()));
      } else {
        // print("error");
        Navigator.pop(viewContext!);
      }

      setBusy(false);
      notifyListeners();
    }
    else if(formKey.currentState!.validate() && selectedProfileImage ==null){
       setBusy(true);
      ApiResponse apiResponse = await ApiClient().updateWithoutImage(
          student: student,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          birthdate: birthDateController,
          imageUrl: student.photoUrl
          );

      if (apiResponse.code == 200) {
        Navigator.push(viewContext!, MaterialPageRoute(builder: (context)=>HomePage()));
      } else {
        // print("error");
        Navigator.pop(viewContext!);
      }

      setBusy(false);
      notifyListeners();
    }
  }

  selectImage(BuildContext parentContext, Size deviceSize) {
    return showModalBottomSheet(
        context: parentContext,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                15,
              ),
              topRight: Radius.circular(
                15,
              )),
        ),
        backgroundColor: Theme.of(viewContext!).cardColor,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(deviceSize.width * 0.048),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: deviceSize.height * 0.012,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: deviceSize.width * 0.02,
                  ),
                  child: Text(
                    "Add profile photo",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: deviceSize.width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.032,
                ),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    selectedProfileImage =
                        File((await handleImageFromCamera())!.path);
                    notifyListeners();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                      SizedBox(
                        width: deviceSize.width * 0.03,
                      ),
                      Text(
                        "Take Image From Camera",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: deviceSize.width * 0.04),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.032,
                ),
                InkWell(
                  child: Row(
                    children: [
                      Icon(Icons.photo_library_outlined),
                      SizedBox(
                        width: deviceSize.width * 0.03,
                      ),
                      Text(
                        "Select From Gallery",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: deviceSize.width * 0.04),
                      )
                    ],
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    selectedProfileImage =
                        File((await handleImageFromGallery())!.path);
                    notifyListeners();
                  },
                ),
                SizedBox(
                  height: deviceSize.height * 0.032,
                ),
              ],
            ),
          );
        });
  }

  getBirthDate() async {
    birthDateController = (await selectDate())!;
    notifyListeners();
  }
}
