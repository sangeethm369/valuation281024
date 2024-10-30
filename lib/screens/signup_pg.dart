import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valuation281024/controllers/firebase_ctrl.dart';
import 'package:valuation281024/controllers/image_ctrl.dart';
import 'package:valuation281024/screens/my_gallery.dart';
import 'package:valuation281024/screens/signin_pg.dart';
import 'package:valuation281024/utils/cust_widgets/cust_textformfield.dart';

class SignUpPg extends StatelessWidget {
  SignUpPg({super.key});
  final TextEditingController name=TextEditingController();
  final TextEditingController email=TextEditingController();
  final TextEditingController password=TextEditingController();

  @override
  Widget build(BuildContext context) {
    var imgPicker=Provider.of<ImageCtrl>(context);
    var fireCtr=Provider.of<FirbaseController>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up",style: TextStyle(fontSize: 22,fontWeight:FontWeight.bold),),centerTitle: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              InkWell(
              onTap: () {
                Provider.of<ImageCtrl>(context,listen: false).imagePicker();
              },
              child: CircleAvatar(radius: 45,backgroundImage:imgPicker.profilepath!=null? FileImage(imgPicker.profilepath!):null,)),
              const SizedBox(height: 10,),
              CustomTextFormField(
                controller: name, 
                obscured: false, 
                labal: "Name"),
              const SizedBox(height: 10,),
                CustomTextFormField(
                controller: email, 
                obscured: false, 
                labal: "Email"),
              const SizedBox(height: 10,),
                CustomTextFormField(
                controller: password, 
                obscured: false, 
                labal: "Passord"),
              const SizedBox(height: 10,),
              ElevatedButton(onPressed: ()async{
                if(imgPicker.profilepath!=null){
                Provider.of<FirbaseController>(context,listen: false).databaseAdd(email: email.text, password: password.text, data: {"name":name.text,"email":email.text,}, image: imgPicker.profilepath!);
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyGallery(userUID:fireCtr.userUID ),));
                var shPref=await SharedPreferences.getInstance();
                shPref.setString('uid',fireCtr.userUID );
               }
              }, child: const Text("Sign Up")),
              const SizedBox(height:10),

              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                const Text("Already have an account?"),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPg(),));
                  },
                  child: const Text("Sign In"))
              ],)
            ],
          ),
        ),
      ),
    );
  }
}