import 'package:facedetectionapp/Controller/homePage_controller.dart';
import 'package:facedetectionapp/view/widgit/anyWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomaePage extends StatelessWidget {
  const HomaePage({super.key});

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
                      ? Icon(
                          Icons.add_a_photo,
                          size: 60,
                        )
                      : Image.file(Conttl.image!),
                ),
                BTN(
                    btntext: "Add from Gallry",
                    sizetext: 25,
                    sizebtn: double.infinity,
                    onPressed: () async {
                      await Conttl.function_Add_from_Picture(
                              Chosse: ImageSource.gallery)
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
                        Chosse: ImageSource.camera);
                  },
                ),
                Spacer(),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      CustomTXT("Numper Of Faces is : ", 20),
                      CustomTXT(Conttl.facees!.length.toString(), 50),
                    ],
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
