import 'package:get/get.dart';
import 'package:tvapp/pages/tv/tv_controller.dart';

class TVBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => TVController());
  }}