import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valuation281024/controllers/obsc_ctrl.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    
    required this.controller,
    this.hint,
    required this.obscured, 
    required this.labal,
    this.inputType,
  });
  final bool obscured;
  final TextInputType? inputType;
  final TextEditingController controller;
  final String? hint;
  final String labal;

  @override
  Widget build(BuildContext context) {
    
    final obscureProvider=Provider.of<ObscureController>(context);
    return TextFormField(
      keyboardType: inputType,
     obscureText: obscured?obscureProvider.obscure:obscured,
     controller: controller,
     decoration: InputDecoration(
      isDense: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      label: Text(labal),
      suffixIcon: obscured? IconButton(onPressed: (){
         Provider.of<ObscureController>(context,listen: false).setObscure();
       }, icon: obscureProvider.icon):null,
       focusedBorder: const OutlineInputBorder(
         borderSide: BorderSide(color: Colors.green),
         borderRadius: BorderRadius.only(
           bottomLeft: Radius.circular(15),
           topRight: Radius.circular(15)
           )),
       hintText: hint,
       border: const OutlineInputBorder(
         borderRadius: BorderRadius.only(
           bottomLeft: Radius.circular(15),
           topRight: Radius.circular(15)
           )
         )
       
     ),
     validator: (value) {
       if (value==null||value.isEmpty) {
         return "Please enter the $labal";
       }else{
        switch (labal) {
          case "Password" :
            if(value.length<6){
              return "Short password";
            }
          case "Email":
            if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value)){
              return "Wrong email";
            }
        }
        return null;
       }
     },
     );
  }
}