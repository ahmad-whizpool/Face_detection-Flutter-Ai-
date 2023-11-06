import 'package:facedetectionapp/Controller/homePage_controller.dart';
import 'package:get/get.dart';

class bind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => homePage_controller());
  }
}
