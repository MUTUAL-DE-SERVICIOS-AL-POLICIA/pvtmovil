import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<String> saveFile(
    String folderName, String fileName, Uint8List data) async {
  try {
    // Validar que tenemos datos
    if (data.isEmpty) {
      throw Exception('No hay datos para guardar');
    }
    
    Directory directory;
    
    if (Platform.isAndroid) {
      // Para Android, usar el directorio de caché externo que es más accesible
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        directory = externalDir;
      } else {
        // Fallback a directorio temporal si no hay almacenamiento externo
        directory = await getTemporaryDirectory();
      }
    } else {
      // Para iOS usar el directorio de documentos
      directory = await getApplicationDocumentsDirectory();
    }
    
    final folderPath = Directory(p.join(directory.path, folderName));

    // Crear carpeta si no existe
    if (!await folderPath.exists()) {
      await folderPath.create(recursive: true);
    }

    // Crear el archivo
    final filePath = p.join(folderPath.path, fileName);
    final file = File(filePath);

    // Escribir los datos
    await file.writeAsBytes(data, flush: true);
    
    // Verificar que el archivo se escribió correctamente
    if (!await file.exists()) {
      throw Exception('El archivo no se pudo crear');
    }
    
    final fileSize = await file.length();
    print('Archivo guardado: $filePath (${fileSize} bytes)');

    return file.path;
  } catch (e) {
    print('Error al guardar archivo: $e');
    rethrow;
  }
}
