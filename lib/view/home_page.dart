import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:student/model/student.dart';
import 'package:student/view/add_page.dart';
import 'package:student/view/edit_page.dart';
import 'package:student/view_model/student_vm.dart';
import 'package:student/widgets/CustomButton.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PermissionStatus? permissionStatus;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: ViewModelBuilder<StudentVM>.reactive(
          viewModelBuilder: () => StudentVM(context),
          builder: (context, viewModel, child) {
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: deviceSize.height * 0.12,
                backgroundColor: Colors.white,
                elevation: 1,
                centerTitle: false,
                title: Text(
                  "List of students",
                  style: TextStyle(
                      color: Colors.black, fontSize: deviceSize.width * 0.044),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: deviceSize.height * 0.036,
                      horizontal: deviceSize.width * 0.04,
                    ),
                    child: CustomButton(
                        height: deviceSize.height * 0.04,
                        width: deviceSize.width * 0.2,
                        backgroundColor: const Color(
                          0xff0C5176,
                        ),
                        title: "Create",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddStudentPage(),
                            ),
                          );
                        }),
                  ),
                ],
              ),
              body: viewModel.isBusy
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('students')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            snapshot.data!.docs.forEach((doc) {
                              var student = Student.fromFirestore(doc);
                              if (viewModel.students
                                  .any((element) => element.id == student.id)) {
                              } else {
                                viewModel.students.add(student);
                              }
                            });

                            viewModel.students
                                .sort((b, a) => a.id.compareTo(b.id));

                            return PaginatedDataTable(
                              horizontalMargin: 10,
                              dataRowHeight: deviceSize.height * 0.064,
                              columnSpacing: deviceSize.width * 0.072,
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  "Photo",
                                )),
                                DataColumn(
                                  label: Text("First Name"),
                                ),
                                DataColumn(
                                  label: Text("Last Name"),
                                ),
                                DataColumn(
                                  label: Text("Birth Date"),
                                ),
                                DataColumn(
                                  label: Text("Actions"),
                                  numeric: false,
                                ),
                              ],
                              source: _MyDataSource(viewModel, context),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
            );
          }),
    );
  }
}

class _MyDataSource extends DataTableSource {
  final StudentVM viewModel;
  final BuildContext context;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  _MyDataSource(this.viewModel, this.context);

  @override
  DataRow? getRow(int index) {
    Size deviceSize = MediaQuery.of(context).size;
    if (index >= students.length) return null;
    final student = students[index];
    return DataRow(cells: [
      DataCell(
        CachedNetworkImage(
          imageUrl: student.photoUrl,
          progressIndicatorBuilder: (context, url, progress) => Center(
            child: SizedBox(
              width: deviceSize.width * 0.04,
              height: deviceSize.width * 0.04,
              child: CircularProgressIndicator(
                value: progress.progress,
              ),
            ),
          ),
          
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  student.photoUrl,
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
          errorWidget: (context, val, err) {
            return Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image:AssetImage("assets/images/Student.png"),
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
      DataCell(
        Text(
          toBeginningOfSentenceCase(student.firstName).toString(),
        ),
      ),
      DataCell(
        Text(
          toBeginningOfSentenceCase(student.lastName).toString(),
        ),
      ),
      DataCell(
        Text(
          formatter.format(student.birthdate),
        ),
      ),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditStudentPage(currentStudent: student)));
            },
            child: Container(
              width: deviceSize.width * 0.16,
              height: deviceSize.height * 0.04,
              // padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(5)),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Update",
                  style: TextStyle(
                      color: Colors.white, fontSize: deviceSize.width * 0.028),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          GestureDetector(
            onTap: () {
              viewModel.deletStudent(student);
            },
            child: Container(
              width: deviceSize.width * 0.16,
              height: deviceSize.height * 0.04,
              // padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(5)),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Delete",
                  style: TextStyle(
                      color: Colors.white, fontSize: deviceSize.width * 0.028),
                ),
              ),
            ),
          ),
        ],
      )),
    ]);
  }

  @override
  List<Student> get students => viewModel.students;
  @override
  int get rowCount => viewModel.students.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
