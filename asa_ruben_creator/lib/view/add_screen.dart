import 'dart:html';

import 'package:asa_ruben_creator/class/firestore_class.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late double _height, _width;

  TextEditingController QrName = TextEditingController();
  TextEditingController QrMessageTeacher = TextEditingController();
  TextEditingController QrMessageStudent = TextEditingController();
  TextEditingController QrMessageGuest = TextEditingController();
  TextEditingController QrUID = TextEditingController();
  TextEditingController QrLabel = TextEditingController();

  String imageURL = "";
  String name = "";
  String message = "";
  String uid = "";
  String label = "";

  final FirestoreClass firestoreClass = FirestoreClass();

  final keyImage = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    uploadImage(GlobalKey key) async {
      final boundery =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundery.toImage();
      final bytedata = await image.toByteData(format: ui.ImageByteFormat.png);
      final imagebyte = bytedata?.buffer.asUint8List();

      if (imagebyte != null) {
        final blob = Blob([imagebyte]);
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImage = referenceRoot.child('images').child(name);
        Reference referenceImageToUpload = referenceDirImage.child(uid);

        try {
          await referenceImageToUpload.putBlob(blob).then(
              (snapshot) => {debugPrint("Uploaded a blob or image success")});

          imageURL = await referenceImageToUpload.getDownloadURL();

          await firestoreClass.sendData(
            QrName.text,
            QrUID.text,
            QrLabel.text,
            QrMessageTeacher.text,
            QrMessageStudent.text,
            QrMessageGuest.text,
            imageURL,
          );

          QrName.clear();
          QrUID.clear();
          QrLabel.clear();
          QrMessageTeacher.clear();
          QrMessageStudent.clear();
          QrMessageGuest.clear();

          return const SnackBar(
            content: Text("Done Uploading..."),
          );
        } on firebase_core.FirebaseException catch (error) {
          debugPrint(error.toString());
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create QR"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                child: RepaintBoundary(
                  key: keyImage,
                  child: Column(
                    children: [
                      SizedBox(
                        // height: _height / 2,
                        width: _width / 2,
                        child: Column(
                          children: [
                            QrImage(
                              data: uid,
                              backgroundColor: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                label,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: QrName,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    // labelText: "QR Name",
                    hintText: "Insert QR Name Here",
                    hintStyle: const TextStyle(
                      fontSize: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: QrUID,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    // labelText: "QR Name",
                    hintText: "Insert UID For QR",
                    hintStyle: const TextStyle(
                      fontSize: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      uid = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: QrLabel,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    // labelText: "QR Name",
                    hintText: "Insert Label For QR",
                    hintStyle: const TextStyle(
                      fontSize: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      label = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: QrMessageTeacher,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    // labelText: "QR Name",
                    hintText: "Insert Message Here For Teacher",
                    hintStyle: const TextStyle(
                      fontSize: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: QrMessageStudent,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    // labelText: "QR Name",
                    hintText: "Insert Message Here For Student",
                    hintStyle: const TextStyle(
                      fontSize: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: QrMessageGuest,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    // labelText: "QR Name",
                    hintText: "Insert Message Here For Guest",
                    hintStyle: const TextStyle(
                      fontSize: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  // onPressed: () => downloadImage(keyImage),
                  onPressed: () => uploadImage(keyImage),
                  icon: const Icon(
                    IconData(0xe695, fontFamily: 'MaterialIcons'),
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
