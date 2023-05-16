import 'package:asa_ruben_visitor/class/firestore_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class VisitorCameraScreen extends StatefulWidget {
  const VisitorCameraScreen({super.key});

  @override
  State<VisitorCameraScreen> createState() => _VisitorCameraScreenState();
}

class _VisitorCameraScreenState extends State<VisitorCameraScreen> {
  late double _height;

  MobileScannerController cameraController = MobileScannerController();
  FlutterTts flutterTts = FlutterTts();

  // class to get data
  final FirestoreClass firestoreClass = FirestoreClass();

  String role = '';

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;

    void speak(String message) async {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1);
      await flutterTts.speak(message);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera"),
        actions: [
          IconButton(
            onPressed: () {
              cameraController.switchCamera();
            },
            icon: const Icon(
              Icons.camera_rear_outlined,
            ),
          ),
          IconButton(
            onPressed: () {
              openDialog();
            },
            icon: const Icon(
              Icons.supervisor_account_outlined,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                cameraController.start();
              },
              onLongPress: () {
                cameraController.stop();
              },
              child: const Icon(Icons.power_settings_new_outlined),
            ),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (value) async {
          List<Barcode> barcodes = value.barcodes;

          for (final barcode in barcodes) {
            String uid = barcode.rawValue.toString();

            if (role == "Teacher") {
              String message =
                  await firestoreClass.getSingleData(uid, 'messageTeacher');
              speak(message);
            } else if (role == "Student") {
              String message =
                  await firestoreClass.getSingleData(uid, 'messageStudent');
              speak(message);
            } else if (role == "Guest") {
              String message =
                  await firestoreClass.getSingleData(uid, 'messageGuest');
              speak(message);
            } else {
              speak("Please select the role do you want");
            }
          }
          barcodes.clear();
        },
      ),
    );
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Select Role"),
          content: SizedBox(
            height: _height / 4,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      role = 'Teacher';

                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: const Text("Teacher"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      role = 'Student';

                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: const Text("Student"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      role = 'Guest';

                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: const Text("Guest"),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      );
}
