import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:student/model/student.dart';
import 'package:student/services/validator.service.dart';
import 'package:student/view_model/edit_student_vm.dart';

class EditStudentPage extends StatefulWidget {
  Student currentStudent;
  EditStudentPage({Key? key, required this.currentStudent}) : super(key: key);

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return ViewModelBuilder<EditStudentVM>.reactive(
        onModelReady: (vm) async {
          vm.setBusy(true);
          vm.firstNameController.text = widget.currentStudent.firstName;
          vm.lastNameController.text = widget.currentStudent.lastName;
          vm.imageUrl = widget.currentStudent.photoUrl;
          vm.birthDateController = widget.currentStudent.birthdate;
          vm.setBusy(false);
        },
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: deviceSize.height * 0.12,
              elevation: 2,
              centerTitle: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "Edit Student${vm.firstNameController.text}",
                style: TextStyle(
                    color: Colors.black, fontSize: deviceSize.width * 0.048),
              ),
            ),
           
            body: vm.isBusy
                ? const CircularProgressIndicator()
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: deviceSize.width * 0.04),
                    child: SingleChildScrollView(
                      child: Form(
                        key: vm.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: deviceSize.height * 0.04,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  vm.selectImage(context, deviceSize);
                                },
                                child: vm.selectedProfileImage !=null ?CircleAvatar(
                                  radius: deviceSize.width * 0.12,
                                  backgroundColor: Colors.teal,
                                  child: CircleAvatar(
                                          radius: deviceSize.width * 0.11,
                                          backgroundColor: Colors.white,
                                          backgroundImage: FileImage(
                                              vm.selectedProfileImage!),
                                        ),
                                ) : CircleAvatar(
                                  radius: deviceSize.width * 0.12,
                                  backgroundColor: Colors.teal,
                                  child: CircleAvatar(
                                          radius: deviceSize.width * 0.11,
                                          backgroundColor: Colors.white,
                                          backgroundImage:
                                              NetworkImage(vm.imageUrl),
                                        )
                                      
                                ),
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.04,
                            ),
                            Text(
                              "First Name",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: deviceSize.width * 0.04,
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.02,
                            ),
                            TextFormField(
                              controller: vm.firstNameController,
                              validator: (value) =>
                                  FormValidator.validateFirstName(value!),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.02,
                            ),
                            Text(
                              "Last Name",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: deviceSize.width * 0.04,
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.02,
                            ),
                            TextFormField(
                              controller: vm.lastNameController,
                              validator: (value) =>
                                  FormValidator.validateLastName(value!),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.02,
                            ),
                            Text(
                              "Date Of Birth",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: deviceSize.width * 0.04,
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.02,
                            ),
                            GestureDetector(
                              onTap: () {
                                vm.getBirthDate();
                              },
                              child: Text(
                                  vm.birthDateController.toIso8601String()),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.04,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await vm
                                        .updateProfile(widget.currentStudent);
                                  },
                                  child: const Text("Update"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("cancel"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        },
        viewModelBuilder: () => EditStudentVM(context, widget.currentStudent));
  }
}
