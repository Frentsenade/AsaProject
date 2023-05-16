import 'dart:html' as html;
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

class LoadCreateScreen extends StatelessWidget {
  const LoadCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Asa Reuben"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            html.window.open('https://asarubenwebcreator.web.app/', '_self');
          },
          child: const Text("Open Creator QR"),
        ),
      ),
    );
  }
}
