import 'package:flutter/material.dart';

class ObscureController extends ChangeNotifier {
  bool obscure=true;
  Icon icon=const Icon(Icons.visibility_off);
  void setObscure(){
    if(obscure){
      icon=const Icon(Icons.visibility);
      obscure=false;
    }else{
      icon=const Icon(Icons.visibility_off);
      obscure=true;
    }
    notifyListeners();
  }
  
}