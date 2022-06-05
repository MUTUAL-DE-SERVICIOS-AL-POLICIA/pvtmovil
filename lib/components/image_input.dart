import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/model/files_model.dart';

class ImageInputComponent extends StatefulWidget {
  final double sizeImage;
  final Function(InputImage, File) onPressed;
  final FileDocument itemFile;
  const ImageInputComponent(
      {Key? key,
      required this.sizeImage,
      required this.onPressed,
      required this.itemFile})
      : super(key: key);

  @override
  _ImageInputComponentState createState() => _ImageInputComponentState();
}

class _ImageInputComponentState extends State<ImageInputComponent> {
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Center(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: widget.itemFile.imageFile == null
                            ? Image.asset(
                                widget.itemFile.imagePathDefault!,
                                // fit: BoxFit.cover,
                                gaplessPlayback: true,
                                width: widget.sizeImage,
                                height: widget.sizeImage,
                              )
                            : Image.file(
                                widget.itemFile.imageFile!,
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                                width: widget.sizeImage,
                                height: widget.sizeImage,
                              )),
                    Positioned(
                        bottom: 2,
                        right: -14,
                        child: IconBtnComponent(
                            iconSize: 20.w,
                            icon: Icons.camera_alt,
                            onPressed: () => _displayPickImageDialog()))
                  ],
                ),
              ),
                      if(!widget.itemFile.validateState)
              Flexible(child: Text(widget.itemFile.textValidate!)),
            ]))));
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 240,
      maxHeight: 320,
      imageQuality: 100,
    );
    if (pickedFile == null) return;
    final inputImage = InputImage.fromFilePath(pickedFile.path);
    final file = File(pickedFile.path);
    widget.onPressed(inputImage, file);
  }

  _displayPickImageDialog() {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
              title: const Text(
                'Seleccionar medio de Imagen',
              ),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: const Text('Cámara'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop("Discard");
                    _onImageButtonPressed(ImageSource.camera, context: context);
                  },
                ),
                CupertinoActionSheetAction(
                  child: const Text('Galería'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop("Discard");
                    _onImageButtonPressed(ImageSource.gallery,
                        context: context);
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop("Discard");
                },
              ));
        });
  }
}
