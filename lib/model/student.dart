import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final int id;
  final String docId;
  final String firstName;
  final String lastName;
  final DateTime birthdate;
  final String photoUrl;

  Student({
    required this.id,
    required this.docId,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.photoUrl,
  });

  factory Student.fromFirestore(QueryDocumentSnapshot<Object?> snapshot) {
   int id = snapshot['id'];
                    String docId = snapshot.id;
                    String firstName = snapshot['firstname'];
                    String lastName = snapshot['lastname'];
                    DateTime birthdate = snapshot['birthdate'].toDate();
                    String photoUrl = snapshot['photo'];
    if (snapshot == null) {
      throw FormatException('Document data is null or empty.');
    }
    return Student(
      id: id,
      docId: docId,
      firstName: firstName,
      lastName: lastName,
      birthdate: birthdate,
      photoUrl: photoUrl,
    );
  }
}
