import 'package:asa_ruben_creator/class/qr_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreClass {
  CollectionReference firestore =
      FirebaseFirestore.instance.collection('images');

  sendData(
    String _name,
    String _uid,
    String _label,
    String _messageTeacher,
    String _messageStudent,
    String _messageGuest,
    String _imagePath,
  ) async {
    String name = _name;
    String uid = _uid;
    String label = _label;
    String messageTeacher = _messageTeacher;
    String messageStudent = _messageStudent;
    String messageGuest = _messageGuest;
    String imagePath = _imagePath;

    final collectionName = firestore.doc(uid);

    final qrdata = QrClass(
      name: name,
      uid: uid,
      label: label,
      messageTeacher: messageTeacher,
      messageStudent: messageStudent,
      messageGuest: messageGuest,
      imagePath: imagePath,
    );
    final data = qrdata.toJson();

    await collectionName.set(data);
  }
}
