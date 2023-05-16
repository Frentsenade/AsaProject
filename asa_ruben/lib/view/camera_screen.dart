import 'package:asa_ruben/utils/class_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late double _height, _width;
  MobileScannerController cameraController = MobileScannerController();
  FlutterTts flutterTts = FlutterTts();

  final UtilsFirestore utilsFirestore = UtilsFirestore();

  String status = '';

  bool isSwitch = false;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    void speak(String text) async {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1);
      await flutterTts.speak(text);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
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
            icon: const Icon(Icons.supervisor_account_outlined),
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
            debugPrint("Barcode Found : ${barcode.rawValue}");
            String word = barcode.rawValue.toString();

            // debugPrint(utilsFirestore.getSingleData(word));
            debugPrint(status);
            if (status == "Teacher") {
              String data =
                  await utilsFirestore.getSingleData(word, 'messageTeacher');
              debugPrint(data);
              speak(data);
            } else if (status == "Student") {
              String data =
                  await utilsFirestore.getSingleData(word, 'messageStudent');
              debugPrint(data);
              speak(data);
            } else if (status == "Guest") {
              String data =
                  await utilsFirestore.getSingleData(word, 'messageGuest');
              debugPrint(data);
              speak(data);
            } else {
              speak("Please select the role do you want");
            }

            // word = "";
          }
          barcodes.clear();
        },
      ),
    );
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Select"),
          content: Container(
            height: _height / 4,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      status = 'Teacher';

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
                      status = 'Student';

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
                      status = 'Guest';

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
                child: const Text("Cancel"))
          ],
        ),
      );
}
