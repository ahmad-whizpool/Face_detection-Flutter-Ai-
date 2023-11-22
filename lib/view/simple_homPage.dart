import 'dart:math' as math;
import 'dart:math';

import 'package:facedetectionapp/Controller/homePage_controller.dart';
import 'package:facedetectionapp/view/widgit/anyWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

class HomaePage extends StatefulWidget {
  HomaePage({super.key});

  @override
  State<HomaePage> createState() => _HomaePageState();
}

class _HomaePageState extends State<HomaePage> {
  img.Image? croppedImage;

  final List<Color> colors = [
    Colors.red,
    Colors.black,
    Colors.white,
    Colors.pinkAccent,
    Colors.pink,
    Colors.blue,
    Colors.green,
    Colors.amber,
    Colors.purple,
    Colors.transparent
  ];
  Color? currentColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: GetBuilder<homePage_controller>(
            init: homePage_controller(),
            builder: (Conttl) => Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.grey,
                  height: 400,
                  child: Conttl.image == null
                      ? const Icon(
                          Icons.add_a_photo,
                          size: 60,
                        )
                      :
                      //  Stack(
                      //     children: [
                      //       Image.file(
                      //         Conttl.image!,
                      //       ),
                      //       ...Conttl.facees.map((e) {
                      //         croppedImage = img.copyCrop(
                      //           Conttl.cropedImage!,
                      //           height: e.boundingBox.height.toInt(),
                      //           width: e.boundingBox.width.toInt(),
                      //           x: e.boundingBox.left.toInt(),
                      //           y: e.boundingBox.top.toInt(),
                      //         );
                      //         final index = Conttl.cropedImage?.getPixel(
                      //           e.boundingBox.left.toInt(),
                      //           e.boundingBox.top.toInt(),
                      //         );
                      //         print(e.boundingBox.left /
                      //             (Conttl.imgess?.width.toDouble() ?? 0) *
                      //             MediaQuery.of(context).size.width);
                      //         print((e.boundingBox.top /
                      //             (Conttl.imgess?.height ?? 0) *
                      //             MediaQuery.of(context).size.height));
                      //         // final croppedBytes = img.encodeJpg(croppedImage!);
                      //         return Positioned(
                      //           top: (e.boundingBox.top /
                      //               (Conttl.imgess?.height ?? 0) *
                      //               MediaQuery.of(context).size.height),
                      //           left: e.boundingBox.left /
                      //               (Conttl.imgess?.width.toDouble() ?? 0) *
                      //               MediaQuery.of(context).size.width,

                      //           child: Container(
                      //             height: e.boundingBox.height,
                      //             width: e.boundingBox.width,
                      //             color: Colors.red,
                      //           ),
                      //           // child: ImageFiltered(
                      //           //   imageFilter: ui.ImageFilter.blur(
                      //           //     sigmaX: 20,
                      //           //     sigmaY: 20,
                      //           //   ),
                      //           //   child: Image.memory(
                      //           //     Uint8List.fromList(croppedBytes),
                      //           //     height: e.boundingBox.height,
                      //           //     width: e.boundingBox.width,
                      //           //   ),
                      //           // ),
                      //         );
                      //       }).toList(),
                      //     ],
                      //   ),
                      CustomPaint(
                          size: Size(Conttl.imgess!.width.toDouble(),
                              Conttl.imgess!.height.toDouble()),
                          painter: FaceDraw(
                            faces: Conttl.facees,
                            listImageModel: Conttl.listImageModel,
                            image: Conttl.imgess!,
                            color: currentColor ?? Colors.transparent,
                          ),

                          //     //     // child: Image.file(Conttl.image!),
                          //   ),
                          // : CustomPaint(
                          //     painter: FaceDraw(
                          //       faces: Conttl.facees,
                          //       image: Conttl.imgess!,
                          //     ),

                          //     // child: Image.file(Conttl.image!),
                          //   ),
                        ),
                ),
                BTN(
                    btntext: "Add from Gallry",
                    sizetext: 25,
                    sizebtn: double.infinity,
                    onPressed: () async {
                      await Conttl.function_Add_from_Picture(
                              chosse: ImageSource.gallery)
                          .then((value) {
                        if (Conttl.image != null) {
                          Conttl.Func_detectFaces_from_picure(Conttl.image!);
                        }
                      });
                    }),
                BTN(
                  btntext: "Add from Camera",
                  sizetext: 25,
                  sizebtn: double.infinity,
                  onPressed: () async {
                    await Conttl.function_Add_from_Picture(
                            chosse: ImageSource.camera)
                        .then((value) {
                      if (Conttl.image != null) {
                        Conttl.Func_detectFaces_from_picure(Conttl.image!);
                      }
                    });
                  },
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      CustomTXT("Numper Of Faces is : ", 20),
                      CustomTXT(Conttl.facees.length.toString(), 50),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: colors.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(2),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            currentColor = colors[index];
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors[index],
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FaceDraw extends CustomPainter {
  List<Face> faces;
  ui.Image image;
  List<ImageModel> listImageModel;
  Color color;
  // BuildContext context;
  FaceDraw(
      {required this.faces,
      required this.image,
      required this.color,
      required this.listImageModel});

  @override
  void paint(Canvas canvas, Size size) {
    double imageWidth = image.width.toDouble();
    double imageHeight = image.height.toDouble();

    // Calculate scaling factors
    double scaleX = size.width / imageWidth;
    double scaleY = size.height / imageHeight;
    double scale = math.min(scaleX,
        scaleY); // Choose the smaller scale factor to fit the entire image

    // Apply scaling transformations to the canvas
    canvas.translate((size.width - imageWidth * scale) / 2,
        (size.height - imageHeight * scale) / 2);
    canvas.scale(scale);

    // Draw the scaled image
    canvas.drawImage(image, Offset.zero, Paint()
        // ..colorFilter = ColorFilter.mode(
        //   color.withOpacity(.5),
        //   BlendMode.overlay,
        // ),
        );
    if (listImageModel.length > 2) {
      for (ImageModel imageModel in listImageModel) {
        imageModel.face.landmarks.forEach((key, value) {
          canvas.drawCircle(
              Offset(value!.position.x.toDouble(), value.position.y.toDouble()),
              (10 / 360) * imageModel.face.boundingBox.width,
              Paint()..color = Colors.red);
        });

        print('adsfasfsdfdsf: ${imageModel.face.leftEyeOpenProbability}');
      }
    } else {
      for (ImageModel imageModel in listImageModel) {
        print('asfasdfdsfasdfdsf $imageModel');
        // canvas.drawImage(
        //     imageModel.image,
        //     Offset(
        //       (imageModel.face.boundingBox.left * 600) /
        //           imageModel.face.boundingBox.width,
        //       imageModel.face.boundingBox.top,
        //     ),
        //     Paint());
        final paths = Path();
        List<Offset> upperlipsTopOffset = [];
        List<Offset> upperlipsBottomOffset = [];
        List<Offset> lowerlipsTopOffset = [];
        List<Offset> lowerlipsBottomOffset = [];
        List<Offset> leftEyeOffsets = [];
        List<Offset> rightEyeOffsets = [];
        Point? leftcheekOffset =
            imageModel.face.landmarks[FaceLandmarkType.leftCheek]!.position;
        Point? rightcheekOffset =
            imageModel.face.landmarks[FaceLandmarkType.rightCheek]!.position;
        Point? rightEyeOffset =
            imageModel.face.landmarks[FaceLandmarkType.rightEye]!.position;
        Point? leftEyeOffset =
            imageModel.face.landmarks[FaceLandmarkType.leftEye]!.position;

        imageModel.face.contours.forEach((key, value) {
          if (value!.points.length == 3) {
            // print('adsfasfsdfdsf: $key ${value.points}');
          }
          if (key == FaceContourType.noseBridge) {}
          for (var element in value.points) {
            // if (key == FaceContourType.face) {
            // canvas.drawCircle(Offset(element.x.toDouble(), element.y.toDouble()),
            //     10, Paint()..color = Colors.red);
            // }
            if (key == FaceContourType.upperLipTop) {
              print('adfasfsdfasdfs ${value.points}');

              upperlipsTopOffset
                  .add(Offset(element.x.toDouble(), element.y.toDouble()));
            } else if (key == FaceContourType.upperLipBottom) {
              upperlipsBottomOffset
                  .add(Offset(element.x.toDouble(), element.y.toDouble()));
            } else if (key == FaceContourType.lowerLipTop) {
              lowerlipsTopOffset
                  .add(Offset(element.x.toDouble(), element.y.toDouble()));
              // canvas.drawCircle(
              //     Offset(element.x.toDouble(), element.y.toDouble()),
              //     2,
              //     Paint()..color = Colors.red);
            } else if (key == FaceContourType.lowerLipBottom) {
              // canvas.drawCircle(
              //     Offset(element.x.toDouble(), element.y.toDouble()),
              //     2,
              //     Paint()..color = Colors.red);
              lowerlipsBottomOffset
                  .add(Offset(element.x.toDouble(), element.y.toDouble()));
            } else if (key == FaceContourType.leftEye) {
              // leftEyeOffset
              //     .add(Offset(element.x.toDouble(), element.y.toDouble()));
            } else if (key == FaceContourType.rightEye) {
              // rightEyeOffset
              //     .add(Offset(element.x.toDouble(), element.y.toDouble()));
            } else if (key == FaceContourType.leftCheek) {
              // leftcheekOffset = value.points[0];
              // leftcheekOffset = Offset(
              //     value.points[0].x.toDouble(), value.points[0].y.toDouble());
              // canvas.drawCircle(
              // Offset(element.x.toDouble(), element.y.toDouble()),
              // imageModel.face.boundingBox.size.width / 8,
              // Paint()
              //   ..color = color.withOpacity(.5)
              //   ..blendMode = BlendMode.softLight
              // // ..maskFilter = MaskFilter.blur(
              // //   BlurStyle.normal,
              // //   100,
              // // ),
              // );
            } else if (key == FaceContourType.rightCheek) {
              // rightcheekOffset = value.points[0];
              // rightcheekOffset = Offset(
              //     value.points[0].x.toDouble(), value.points[0].y.toDouble());
              // canvas.drawCircle(
              //   Offset(element.x.toDouble(), element.y.toDouble()),
              //   imageModel.face.boundingBox.size.width / 7,
              //   Paint()
              //     ..color = color.withOpacity(.5)
              //     ..blendMode = BlendMode.softLight
              //     ..maskFilter = MaskFilter.blur(
              //       BlurStyle.normal,
              //       100,
              //     ),
              // );
            }
          }
        });

        // if (leftcheekOffset != null) {
        // final distance = calculateDistance(
        //     leftcheekOffset!,
        //     Offset(
        //         imageModel
        //             .face.contours[FaceContourType.noseBridge]!.points[0].x
        //             .toDouble(),
        //         imageModel
        //             .face.contours[FaceContourType.noseBridge]!.points[0].y
        //             .toDouble()));

        final cheeksPaint = Paint()
          ..color = color.withOpacity(.7)
          ..blendMode = BlendMode.softLight
          ..imageFilter = ui.ImageFilter.blur(
              sigmaX: (10 / 360) * imageModel.face.boundingBox.width,
              sigmaY: (10 / 360) * imageModel.face.boundingBox.width)
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            (10 / 360) * imageModel.face.boundingBox.width,
          );
        canvas.drawCircle(
          Offset(leftcheekOffset.x.toDouble(), leftcheekOffset.y.toDouble()),
          leftcheekOffset.distanceTo(imageModel
                  .face.landmarks[FaceLandmarkType.leftMouth]!.position) *
              .7,
          cheeksPaint,
        );
        // }
        // if (rightcheekOffset ) {
        canvas.drawCircle(
          Offset(rightcheekOffset.x.toDouble(), rightcheekOffset.y.toDouble()),
          rightcheekOffset.distanceTo(imageModel
                  .face.landmarks[FaceLandmarkType.rightMouth]!.position) *
              .8,
          cheeksPaint,
        );

        canvas.drawCircle(
            Offset(leftEyeOffset.x.toDouble(), leftEyeOffset.y.toDouble()),
            (8 / 360) * imageModel.face.boundingBox.width,
            Paint()
              ..color = color.withOpacity(1)
              ..blendMode = BlendMode.softLight
            // ..imageFilter = ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10)
            // ..maskFilter = const MaskFilter.blur(
            //   BlurStyle.normal,
            //   50,
            // ),
            );
        canvas.drawCircle(
            Offset(rightEyeOffset.x.toDouble(), rightEyeOffset.y.toDouble()),
            (8 / 360) * imageModel.face.boundingBox.width,
            Paint()
              ..color = color.withOpacity(1)
              ..blendMode = BlendMode.softLight
            // ..imageFilter = ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10)
            // ..maskFilter = const MaskFilter.blur(
            //   BlurStyle.normal,
            //   50,
            // ),
            );
        // }
        print("adfadsfasdfsdf ${imageModel.face.smilingProbability}");
        if ((imageModel.face.smilingProbability ?? 0) > .8) {
          paths.addPolygon(
            [
              ...lowerlipsBottomOffset,
              ...lowerlipsTopOffset.reversed,
              lowerlipsBottomOffset.first,
              upperlipsBottomOffset.reversed.first,
              ...upperlipsTopOffset.reversed,
              lowerlipsBottomOffset.reversed.first,
              upperlipsBottomOffset.first,
              ...upperlipsBottomOffset,
              lowerlipsTopOffset.first,
            ],
            false,
          );
        } else {
          paths.addPolygon(
            [
              ...lowerlipsBottomOffset,
              ...upperlipsBottomOffset,
              ...lowerlipsTopOffset,
              ...upperlipsTopOffset,
            ],
            false,
          );
        }
        paths.addPolygon(
          leftEyeOffsets,
          false,
        );
        paths.addPolygon(
          rightEyeOffsets,
          false,
        );
        // paths.addPolygon(
        //   [
        //     ...lowerlipsBottomOffset,
        //   ],
        //   false,
        // );
        // paths.addPolygon(
        //   [
        //     ...lowerlipsBottomOffset,
        //     ...lowerlipsTopOffset.reversed,
        //     lowerlipsBottomOffset[0],
        //     upperlipsBottomOffset[0],
        //   ],
        //   true,
        // );
        // paths.addPolygon(
        //   leftcheekOffset,
        //   false,
        // );
        // canvas.drawPoints(
        //     ui.PointMode.polygon,
        //     [
        //       ...lowerlipsBottomOffset,
        //       ...lowerlipsTopOffset.reversed,
        //       lowerlipsBottomOffset.first,
        //       upperlipsBottomOffset.reversed.first,
        //       ...upperlipsTopOffset.reversed,
        //       lowerlipsBottomOffset.reversed.first,
        //       upperlipsBottomOffset.first,
        //       ...upperlipsBottomOffset,
        //       lowerlipsTopOffset.first,
        //     ],
        //     Paint()..color = color.withOpacity(1));

        canvas.drawPath(
            paths,
            Paint()
              ..color = color.withOpacity(.6)
              ..blendMode = BlendMode.softLight
            // ..style = PaintingStyle.stroke
            // ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 5),
            );
        // List<Offset> points = [];
        // for (var element in face.landmarks.entries) {
        //   print('asdfsadfsdf $element.value');
        //   if (element.value != null) {
        //     points.add(Offset(element.value!.position.x.toDouble(),
        //         element.value!.position.y.toDouble()));
        //   }
        // }
        // canvas.drawPoints(
        //     ui.PointMode.points,
        //     points,
        //     Paint()
        //       ..style = PaintingStyle.fill
        //       ..color = Colors.transparent);
        // Draw face bounding box using scaled coordinates
        // canvas.drawRect(
        //     imageModel.face.boundingBox,
        //     Paint()
        //       ..style = PaintingStyle.fill
        //       ..color = Colors.transparent
        //       ..colorFilter =
        //           ColorFilter.mode(color.withOpacity(.1), BlendMode.color));
        // print('asdfsadfsdf ${face.boundingBox}');
        // Rect logicalRect = face.boundingBox;

        // Obtain the device pixel ratio
        // double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

        // Create a transformation matrix to convert logical coordinates to device coordinates
        // Matrix4 transformMatrix = Matrix4.identity()
        //   ..scale(devicePixelRatio, devicePixelRatio);

        // Use MatrixUtils.transformRect to apply the transformation to the Rect
        // Rect deviceRect = MatrixUtils.transformRect(transformMatrix, logicalRect);
        // print('asdfsadfsdf Logical Rect: $logicalRect');
        // print('asdfsadfsdf Device Rect: $deviceRect');
        // canvas.drawRect(
        //   face.boundingBox,
        //   Paint()
        //     ..style = PaintingStyle.stroke
        //     ..color = Colors.blueAccent
        //     ..strokeWidth = 4,
        // );
      }
    }
  }

  double calculateDistance(Offset point1, Offset point2) {
    double dx = point2.dx - point1.dx;
    double dy = point2.dy - point1.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
