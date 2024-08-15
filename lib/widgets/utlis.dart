import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagepicker = ImagePicker();
  XFile? _pickedFile = await _imagepicker.pickImage(source: source);

  if (_pickedFile != null) {
    return await _pickedFile.readAsBytes();
  }
  print("no image picked");
}