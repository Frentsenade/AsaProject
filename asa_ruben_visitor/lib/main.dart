import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screen/visitor_camera_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAI7xQzvYR9K8tdEtJOmkOiKx0tnvOv73I",
      projectId: "asareuben-c4501",
      storageBucket: "asareuben-c4501.appspot.com",
      messagingSenderId: "751542278707",
      appId: "1:751542278707:web:3f4b400311947067246146",

      // apiKey: "AIzaSyBWLYyAKIvBhVCm",
      // appId: "1:174878083047:web:187472e1e4959b594d1f42",
      // messagingSenderId: "174878083047",
      // projectId: "asarubenweb-482c2",
      // storageBucket: "asarubenweb-482c2.appspot.com",
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asa Reuben Visitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint(
              snapshot.error.toString(),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            debugPrint(
              "Connection Success",
            );
            return const VisitorCameraScreen();
          }
          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              value: 1,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        },
      ),
    );
  }
}
