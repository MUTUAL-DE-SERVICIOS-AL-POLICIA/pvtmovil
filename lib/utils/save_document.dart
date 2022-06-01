import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> saveFile(
    BuildContext context, String folder, String name, dynamic response) async {
  await Permission.storage.request();
  await Permission.manageExternalStorage.request();
  await Permission.accessMediaLocation.request();
  Directory documentDirectory =
      await Directory('/storage/emulated/0/Muserpol/$folder')
          .create(recursive: true);
  String documentPath = documentDirectory.path;
  String fullPaths = "$documentPath/$name";
  File myFile = File(fullPaths);
  Uint8List file = response.bodyBytes;
  myFile.writeAsBytesSync(file);
  return fullPaths;
}
