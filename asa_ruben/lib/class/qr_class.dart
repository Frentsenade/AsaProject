// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class QRdata {
  final String name;
  final String uid;
  final String label;
  final String messageTeacher;
  final String messageStudent;
  final String messageGuest;
  final String imagePath;

  QRdata({
    required this.name,
    required this.uid,
    required this.label,
    required this.messageTeacher,
    required this.messageStudent,
    required this.messageGuest,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'label': label,
        'messageTeacher': messageTeacher,
        'messageStudent': messageStudent,
        'messageGuest': messageGuest,
        'imagePath': imagePath,
      };

  static QRdata fromJson(DocumentSnapshot<Map<String, dynamic>> json) => QRdata(
        name: json['name'],
        uid: json['uid'],
        label: json['label'],
        messageTeacher: json['messageTeacher'],
        messageStudent: json['messageStudent'],
        messageGuest: json['messageGuest'],
        imagePath: json['imagePath'],
      );
}
