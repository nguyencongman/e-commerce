import 'package:get/get.dart';

class CoffeeSizeController extends GetxController{
  RxString size = 'Small'.obs;
  RxBool expand=false.obs;

  selectSize(String s){
    size.value=s;
  }
}