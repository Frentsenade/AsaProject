// ignore_for_file: non_constant_identifier_names, avoid_web_libraries_in_flutter

import 'dart:html';
import 'dart:ui' as ui;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:asa_ruben/utils/class_firestore.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

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

  WidgetsToImageController QrImageC = WidgetsToImageController();

  String name = "";
  String message = "";
  String uid = "";
  String label = "";

  String imageURL = "";

  final UtilsFirestore utilsfirestore = UtilsFirestore();

  final keyImage = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    // Uint8List? bytes;

    // downloadImage(GlobalKey key) async {
    //   final boundery =
    //       key.currentContext?.findRenderObject() as RenderRepaintBoundary;
    //   final image = await boundery.toImage();
    //   final bytedata = await image.toByteData(format: ImageByteFormat.png);
    //   final imagebyte = bytedata?.buffer.asUint8List();

    //   if (imagebyte != null) {
    //     final blob = Blob([imagebyte]);
    //     final url = Url.createObjectUrlFromBlob(blob);

    //     final anchor = document.createElement('a') as AnchorElement
    //       ..href = url
    //       ..style.display = 'none'
    //       ..download = 'qr-$name.png';

    //     document.body?.children.add(anchor);
    //     anchor.click();
    //     anchor.remove();
    //   }
    // }

    uploadImage(GlobalKey key) async {
      // uploadImage(WidgetsToImageController imageC) async {
      final boundery =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundery.toImage();
      final bytedata = await image.toByteData(format: ui.ImageByteFormat.png);
      // bytes = await imageC.capture();
      final imagebyte = bytedata?.buffer.asUint8List();
      // debugPrint(bytes.toString());

      if (imagebyte != null) {
        final blob = Blob([imagebyte]);
        final file = Url.createObjectUrlFromBlob(blob);

        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImage = referenceRoot.child('images').child(name);
        Reference referenceImageToUpload = referenceDirImage.child(uid);
        try {
          await referenceImageToUpload.putBlob(blob).then(
              (snapshot) => {debugPrint("Uploaded a blob or image success")});

          // await referenceImageToUpload.putData(imagebyte).then((snapshot) =>
          //     {debugPrint("Uploaded a byte data or image success")});

          imageURL = await referenceImageToUpload.getDownloadURL();

          await utilsfirestore.sendData(
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
        title: const Text(
          'Create QR',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                child: RepaintBoundary(
                  // controller: QrImageC,
                  key: keyImage,
                  child: Column(
                    children: [
                      SizedBox(
                        // height: _height / 2,
                        width: _width / 2,
                        child: QrImage(
                          data: uid,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      // Container( // Name Of QR
                      //   // height: _height / 2,
                      //   width: _width / 3,
                      //   padding: const EdgeInsets.all(10),
                      //   alignment: Alignment.center,
                      //   decoration: const BoxDecoration(
                      //     color: Colors.white,
                      //   ),
                      //   child: Text(
                      //     name,
                      //     style: const TextStyle(
                      //       fontSize: 20,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
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
                  onChanged: (value) {
                    setState(() {
                      message = value;
                    });
                  },
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
                  // onChanged: (value) {
                  //   setState(() {
                  //     message = value;
                  //   });
                  // },
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
                  // onChanged: (value) {
                  //   setState(() {
                  //     message = value;
                  //   });
                  // },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(10),
              //   child: ElevatedButton(
              //     onPressed: () => setState(() {}),
              //     style: ElevatedButton.styleFrom(
              //         minimumSize: const Size.fromHeight(50)),
              //     child: const Text("Generate QR"),
              //   ),
              // ),
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
                // child: ElevatedButton(
                //   onPressed: () => uploadImage(QrImageC),
                //   child: Text("Generate Image"),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
