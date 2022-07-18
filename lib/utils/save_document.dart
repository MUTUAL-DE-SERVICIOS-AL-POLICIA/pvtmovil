import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

Future<String> saveFile(
  String path,
  String fileName,
  Uint8List data,
) async {
  path = await getDir(path);
  if (!Directory(path).existsSync()) {
    Directory(path).createSync();
  }
  File file = File(path + fileName);
  file.writeAsBytesSync(data);
  return path + fileName;
}

Future<String> getDir(String path) async {
  final externalDirectory = await getTemporaryDirectory();
  return '${externalDirectory.path}/$path/';
}
