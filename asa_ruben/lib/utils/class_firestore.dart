// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:asa_ruben/class/qr_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UtilsFirestore {
  CollectionReference firestore =
      FirebaseFirestore.instance.collection('images');
  // final colRef = firestore.collection('images');

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

    final qrdata = QRdata(
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

  getSingleData(String uid, String message) async {
    // final snapshot = await firestore.where(uid).get();
    // final data = snapshot.docs
    //     .map((doc) =>
    //         QRdata.fromJson(doc as DocumentSnapshot<Map<String, dynamic>>))
    //     .single;

    final datas = firestore.doc(uid);
    final docSnapshot = await datas.get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      final value = data[message];
      return value;
    }
  }

  Future getData(String uid) async {
    final snapshot = await firestore.where(uid).get();
    final data = snapshot.docs
        .map((doc) =>
            QRdata.fromJson(doc as DocumentSnapshot<Map<String, dynamic>>))
        .single;
  }

  updateData(String uid, String messageTeacher, String messageStudent,
      String messageGuest) async {
    firestore.doc(uid).update({
      'messageTeacher': messageTeacher,
      'messageStudent': messageStudent,
      'messageGuest': messageGuest,
    });
  }

  deleteData(String uid, String url) async {
    firestore.doc(uid).delete();
    FirebaseStorage.instance.refFromURL(url).delete();
  }

  Stream<List<QRdata>> readData() =>
      firestore.orderBy("name").snapshots().map((snapshot) => snapshot.docs
          .map((doc) =>
              QRdata.fromJson(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList());
}
