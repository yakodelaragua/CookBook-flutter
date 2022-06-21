import 'dart:io';

import 'package:flutter/material.dart';
//curso 51 faltan cosas
typedef OnImageSelected = Function(File imageFile);

class ImagePickerWidget extends StatelessWidget {
  final File imageFile;
  final OnImageSelected;
  ImagePickerWidget({required this.imageFile, required this.OnImageSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.cyan[300]!, Colors.cyan[800]!,
          ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        image: imageFile != null?DecorationImage(
            image: FileImage(imageFile),
            fit: BoxFit.cover):null //si no se cumple devuelve null
          ),
      child: IconButton(
        icon: Icon(Icons.camera_alt),
        onPressed: (){
          _showPikerOptions(context);
          },
        iconSize: 90,
        color: Colors.white,
      ),
    );
  }

  void _showPikerOptions(BuildContext context) {

  }
}
