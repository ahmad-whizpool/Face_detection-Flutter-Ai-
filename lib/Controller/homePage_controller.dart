import 'dart:io';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class homePage_controller extends GetxController {
  File? image;
  // homePage_controller() {
  //   Func_detectFaces_from_picure(image!);
  // }

  Future<void> function_Add_from_Picture({required ImageSource Chosse}) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: Chosse);

    if (pickedImage != null) {
      image = File(pickedImage.path);
      update();
    }
  }

  List<Face> facees = [];
  Future Func_detectFaces_from_picure(File image) async {
    final option = FaceDetectorOptions();
    final faceDetector = FaceDetector(options: option);
    final inputImage = InputImage.fromFilePath(image.path);
    facees = await faceDetector.processImage(inputImage);

    update();
  }
}
