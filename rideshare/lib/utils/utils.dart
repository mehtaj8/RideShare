import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String title, String content,
    ContentType contentType) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    margin: const EdgeInsets.fromLTRB(0, 150, 0, 0),
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Transform.scale(
      scale: 0.9,
      child: AwesomeSnackbarContent(
          title: title, message: content, contentType: contentType),
    ),
    behavior: SnackBarBehavior.floating,
  ));
}

Future<File?> pickImage(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context, "Error", e.toString(), ContentType.failure);
  }

  return image;
}
