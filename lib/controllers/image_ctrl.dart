import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class ImageCtrl extends ChangeNotifier {
  File? profilepath;
  Future<void> imagePicker()async{
    final imgPicker=ImagePicker();
    XFile? file=await imgPicker.pickImage(source: ImageSource.gallery);
    if (file!=null) {
      profilepath=File(file.path);
    }
    notifyListeners();
  }

}