// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class homePage_controller extends GetxController {
  File? image;
  ui.Image? imgess;
  img.Image? cropedImage;
  Uint8List? bytesImage;
  bool isLoading = false;

  // set setIsLoading(bool value) {
  //   isLoading = value;
  //   update();
  // }
  // homePage_controller() {
  //   Func_detectFaces_from_picure(image!);
  // }

  Future<void> function_Add_from_Picture({required ImageSource chosse}) async {
    facees.clear();
    listImageModel.clear();
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: chosse);

    if (pickedImage != null) {
      image = File(pickedImage.path);
      bytesImage = image?.readAsBytesSync();
      imgess = await convertFileToImage(image!);
      cropedImage = await img.decodeImageFile(image!.path);
      update();
    }
  }

  List<Face> facees = [];
  Future Func_detectFaces_from_picure(File image) async {
    final option = FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.accurate,
      enableContours: true,
    );
    final faceDetector = FaceDetector(options: option);

    final inputImage = InputImage.fromFilePath(image.path);
    facees = await faceDetector.processImage(inputImage);
    await getFacesInfo();
    faceDetector.close();
    update();
  }

  // List<ui.Image> faceImages = [];
  List<ImageModel> listImageModel = [];
  Future<void> getFacesInfo() async {
    final assetsImage =
        (await rootBundle.load('assets/masks.png')).buffer.asUint8List();
    final makeUpImage = img.decodeImage(assetsImage);
    print('adsfdsafdsf ${facees.length}');
    for (Face face in facees) {
      final croppedImage = img.copyResize(makeUpImage!,
          width: face.boundingBox.size.width.toInt(),
          height: face.boundingBox.size.height.toInt());
      // faceInfo.add(base64Encode(img.encodeJpg(croppedImage)));
      ui.decodeImageFromList(assetsImage, (result) {
        listImageModel.add(
          ImageModel(image: result, face: face),
        );
      });

      // print();
      // bytesImage = await Beautyplugin.beauty(fairLevel, faceInfo, bytesImage!);
    }
  }

  List<Pose> poses = [];
  Future Func_detectPose_from_picure(File image) async {
    final option = PoseDetectorOptions();
    final faceDetector = PoseDetector(options: option);
    final inputImage = InputImage.fromFilePath(image.path);
    poses = await faceDetector.processImage(inputImage);

    update();
  }

  Future<ui.Image> convertFileToImage(File picture) async {
    List<int> imageBase64 = picture.readAsBytesSync();
    String imageAsString = base64Encode(imageBase64);
    Uint8List uint8list = base64.decode(imageAsString);
    Completer<ui.Image?> currentImage = Completer();
    ui.decodeImageFromList(uint8list, (value) {
      currentImage.complete(value);
    });
    final iamgess = await currentImage.future;
    return iamgess!;
  }

  List<Rect> convertFaceBoundingBoxes(List<Face> faces, Size imageSize) {
    double imageWidth = imageSize.width;
    double imageHeight = imageSize.height;

    List<Rect> convertedBoundingBoxes = [];
    for (var face in faces) {
      double left = (face.boundingBox.left * imageWidth)
          .clamp(0, imageWidth - 1)
          .toDouble();
      double top = (face.boundingBox.top * imageHeight)
          .clamp(0, imageHeight - 1)
          .toDouble();
      double right = (face.boundingBox.right * imageWidth)
          .clamp(0, imageWidth - 1)
          .toDouble();
      double bottom = (face.boundingBox.bottom * imageHeight)
          .clamp(0, imageHeight - 1)
          .toDouble();

      convertedBoundingBoxes.add(Rect.fromLTRB(left, top, right, bottom));
    }

    return convertedBoundingBoxes;
  }

  List<double> convertRectCoordinateIntoPixel(Rect rect, BuildContext context) {
    // double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Convert Rect coordinates to pixels
    double leftInPixels = rect.left * devicePixelRatio;
    double topInPixels = rect.top * devicePixelRatio;
    double rightInPixels = rect.right * devicePixelRatio;
    double bottomInPixels = rect.bottom * devicePixelRatio;

    // Ensure the converted coordinates fit within the screen boundaries
    leftInPixels = leftInPixels.clamp(0, screenWidth);
    topInPixels = topInPixels.clamp(0, screenHeight);
    rightInPixels = rightInPixels.clamp(0, screenWidth);
    bottomInPixels = bottomInPixels.clamp(0, screenHeight);

    // Calculate the width and height of the screen
    double screenRectWidth = rightInPixels - leftInPixels;
    double screenRectHeight = bottomInPixels - topInPixels;

    // Ensure the screenRect fits within the screen boundaries
    screenRectWidth = screenRectWidth.clamp(0, screenWidth);
    screenRectHeight = screenRectHeight.clamp(0, screenHeight);

    // Adjust left, top, right, and bottom coordinates accordingly
    rightInPixels = leftInPixels + screenRectWidth;
    bottomInPixels = topInPixels + screenRectHeight;
    return [topInPixels, bottomInPixels, leftInPixels, rightInPixels];
  }
}

class ImageModel {
  ui.Image image;
  Face face;
  ImageModel({required this.image, required this.face});
}
