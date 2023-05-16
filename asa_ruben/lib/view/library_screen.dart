import 'dart:convert';
import 'dart:html';
import 'dart:ui';

import 'package:asa_ruben/class/qr_class.dart';
import 'package:asa_ruben/utils/class_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:universal_html/html.dart' as html;

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late double _height, _width;
  var imageBase64;

  final UtilsFirestore utilsFirestore = UtilsFirestore();

  TextEditingController MessageTeacher = TextEditingController();
  TextEditingController MessageStudent = TextEditingController();
  TextEditingController MessageGuest = TextEditingController();

  final keyImage = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Library QR',
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<QRdata>>(
        stream: utilsFirestore.readData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong ${snapshot.error}");
          } else if (snapshot.hasData) {
            final datas = snapshot.data!;

            // return ListView(
            //   // children: datas.map(buildData).toList(),
            //   children: datas.map(buildCard).toList(),
            // );
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return ListView(
                    children: datas.map(buildCardMobile).toList(),
                  );
                } else {
                  return ListView(
                    children: datas.map(buildCardDesktop).toList(),
                  );
                }
              },
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                value: 1,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }
        },
      ),
    );
  }

  // convertImage(String url) async {
  //   http.Response imageResponse = await http.get(Uri.parse(url));
  //   imageBase64 = base64Encode(imageResponse.bodyBytes);
  //   // return imageBase64;
  // }

  Widget buildData(QRdata qRdata) => ListTile(
        leading: Text(qRdata.name),
        title: Text(qRdata.uid),
        subtitle: Text(qRdata.messageTeacher),
      );

  Widget buildCardMobile(QRdata qRdata) => Card(
        elevation: 5,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      // RepaintBoundary(
                      //   key: keyImage,
                      Container(
                        //tambahin widget
                        child: Image.network(
                          qRdata.imagePath.toString(),
                          width: 200,
                          height: 200,
                        ),
                      ),
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              qRdata.name,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "Message For Teacher :",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 5),
                            child: Text(
                              qRdata.messageTeacher,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "Message For Student :",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 5),
                            child: Text(
                              qRdata.messageStudent,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "Message For Guest :",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              qRdata.messageGuest,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          // downloadImage(qRdata.imagePath.toString());
                          // downloadImageQR(keyImage, qRdata.uid);
                          // downloadImage(
                          //   qRdata.imagePath.toString(),
                          //   qRdata.uid,
                          // );
                          // showImageDialog(
                          //   qRdata.imagePath.toString(),
                          //   qRdata.name,
                          // );
                          downloadImageUrl(qRdata.imagePath.toString());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text("Download Image"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          openDialog(
                              qRdata.name,
                              qRdata.uid,
                              qRdata.messageTeacher,
                              qRdata.messageStudent,
                              qRdata.messageGuest);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text("Edit"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          deleteDialog(
                              qRdata.uid, qRdata.name, qRdata.imagePath);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Delete"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildCardDesktop(QRdata qRdata) => Card(
        elevation: 5,
        // child: FittedBox(
        //   fit: BoxFit.fitWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    // RepaintBoundary(
                    //   key: keyImage,
                    Container(
                      //tambahin widget
                      child: Image.network(
                        qRdata.imagePath.toString(),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            qRdata.name,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            "Message For Teacher :",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, bottom: 5),
                          child: Text(
                            qRdata.messageTeacher,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            "Message For Student :",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, bottom: 5),
                          child: Text(
                            qRdata.messageStudent,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            "Message For Guest :",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            qRdata.messageGuest,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        // downloadImage(qRdata.imagePath.toString());
                        // downloadImageQR(keyImage, qRdata.uid);
                        // downloadImage(
                        //   qRdata.imagePath.toString(),
                        //   qRdata.uid,
                        // );
                        // showImageDialog(
                        //   qRdata.imagePath.toString(),
                        //   qRdata.name,
                        // );
                        downloadImageUrl(qRdata.imagePath.toString());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text("Download Image"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        openDialog(
                            qRdata.name,
                            qRdata.uid,
                            qRdata.messageTeacher,
                            qRdata.messageStudent,
                            qRdata.messageGuest);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text("Edit"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        deleteDialog(qRdata.uid, qRdata.name, qRdata.imagePath);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Delete"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // ),
      );

  downloadImageUrl(String url) {
    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = 'image_$url.jpg';
    anchorElement.click();
  }

  Future deleteDialog(String uid, String name, String url) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Warning"),
          content: Text(
            'Are you sure to delete $name',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                utilsFirestore.deleteData(
                  uid,
                  url,
                );

                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );

  Future openDialog(String name, String uid, String messageTeacher,
          String messageStudent, String messageGuest) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(name),
          content: Container(
            height: _height / 4,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: MessageTeacher,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: messageTeacher,
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: MessageStudent,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: messageStudent,
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: MessageGuest,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: messageGuest,
                      hintStyle: const TextStyle(
                        fontSize: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ElevatedButton(
                //     onPressed: () {
                //       utilsFirestore.updateData(uid, MessageTeacher.text,
                //           MessageStudent.text, MessageGuest.text);

                //       Navigator.of(context).pop();
                //     },
                //     child: const Text("Update"),
                //   ),
                // ),
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
            TextButton(
              onPressed: () {
                utilsFirestore.updateData(uid, MessageTeacher.text,
                    MessageStudent.text, MessageGuest.text);

                Navigator.of(context).pop();
              },
              child: const Text("Update"),
            ),
          ],
        ),
      );
}
