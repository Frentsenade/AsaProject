import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreClass {
  CollectionReference firestore =
      FirebaseFirestore.instance.collection('images');

  getSingleData(String uid, String message) async {
    final datas = firestore.doc(uid);
    final docSnapshot = await datas.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      final value = data[message];
      return value;
    }
  }
}
