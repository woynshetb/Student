import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:student/services/validator.service.dart';
import 'package:student/view_model/add_vm.dart';
import 'package:student/widgets/CustomButton.dart';
import 'package:student/widgets/customTextForm.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({Key? key}) : super(key: key);

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return ViewModelBuilder<AddVm>.reactive(
        builder: (context, vm, child) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: deviceSize.height * 0.1,
                elevation: 2,
                centerTitle: true,
                backgroundColor: Colors.white,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  ),
                ),
                title: Text(
                  "Create New Student",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: deviceSize.width * 0.044,
                      fontWeight: FontWeight.w700),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: deviceSize.width * 0.08,
                ),
                child: vm.isBusy
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Form(
                          key: vm.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: deviceSize.height * 0.048,
                              ),
                              Text(
                                "First Name",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: deviceSize.width * 0.036,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.016,
                              ),
                              CustomTextForm(
                                controller: vm.firstNameController,
                                filled: true,
                                authoFocus: false,
                                filledColor: Color(0xffEDF1F9),
                                validator: (value) =>
                                    FormValidator.validateFirstName(value!),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.032,
                              ),
                              Text(
                                "Last Name",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: deviceSize.width * 0.036,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: deviceSize.width * 0.016,
                              ),
                              CustomTextForm(
                                controller: vm.lastNameController,
                                filled: true,
                                filledColor: Color(0xffEDF1F9),
                                authoFocus: false,
                                validator: (value) =>
                                    FormValidator.validateLastName(value!),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.032,
                              ),
                              Text(
                                "Date Of Birth",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: deviceSize.width * 0.036,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.016,
                              ),
                              CustomButton(
                                width: deviceSize.width,
                                height: deviceSize.height * 0.064,
                                backgroundColor: Color(0xffEDF1F9),
                                borderColor: Theme.of(context).primaryColor,
                                textColor: Colors.black,
                                title: vm.birthDateController == DateTime.now()
                                    ? "Select Birth Date"
                                    : formatter.format(vm.birthDateController),
                                onPressed: () {
                                  vm.selectDate();
                                },
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.032,
                              ),
                              Text(
                                "Photo",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: deviceSize.width * 0.036,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.016,
                              ),
                              CustomButton(
                                  width: deviceSize.width,
                                  height: deviceSize.height * 0.06,
                                  borderColor: Theme.of(context).primaryColor,
                                  backgroundColor: Color(0xffEDF1F9),
                                  textColor: Colors.black,
                                  title: vm.profilePicture == null
                                      ? "Upload Photo"
                                      : vm.profilePicture!.path,
                                  onPressed: () {
                                    vm.selectImage(context, deviceSize);
                                  }),
                              SizedBox(
                                height: deviceSize.height * 0.08,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: () async {
                                        await vm.createStudent();
                                      },
                                      title: "Create",
                                      height: deviceSize.height * 0.054,
                                      backgroundColor: Color(0xff0C5176),
                                    ),
                                  ),
                                  SizedBox(
                                    width: deviceSize.width * 0.04,
                                  ),
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      title: "Cancel",
                                      height: deviceSize.height * 0.054,
                                      backgroundColor: Color(0xffB0CFE0),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
        viewModelBuilder: () => AddVm(context));
  }
}
