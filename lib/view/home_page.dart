import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:student/model/student.dart';
import 'package:student/view/add_page.dart';
import 'package:student/view/edit_page.dart';
import 'package:student/view_model/student_vm.dart';

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
    return ViewModelBuilder<StudentVM>.reactive(
        viewModelBuilder: () => StudentVM(context),
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: deviceSize.height * 0.12,
              backgroundColor: Colors.white,
              elevation: 2,
              centerTitle: true,
              title: Text(
                "List of students",
                style: const TextStyle(color: Colors.black),
              ),
              actions: [
                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddStudentPage()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(
                        vertical: 28, horizontal: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text(
                      "Create",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: viewModel.isBusy ? CircularProgressIndicator() : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Expanded(
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

                        viewModel.students.sort((b,a)=>a.id.compareTo(b.id));
                        return ListView.builder(
                          itemCount: viewModel.students.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                  '${viewModel.students[index].firstName} ${viewModel.students[index].lastName}'),
                              subtitle: Text(
                                  'Birthdate: ${viewModel.students[index].birthdate.toString()}'),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    viewModel.students[index].photoUrl),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditStudentPage(
                                                    currentStudent: viewModel
                                                        .students[index],
                                                  )));
                                      // handleImage().then(
                                      //   (xfile) {
                                      //     updateStudent(
                                      //       student: viewModel.students[index],
                                      //       studentImageFile: File(xfile!.path),
                                      //     );
                                      //   },
                                      // );
                                    },
                                    child: const Text("update"),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      viewModel.deletStudent(
                                       viewModel.students[index]);
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  

}
