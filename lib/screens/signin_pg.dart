import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valuation281024/controllers/firebase_ctrl.dart';
import 'package:valuation281024/screens/my_gallery.dart';
import 'package:valuation281024/utils/cust_widgets/cust_textformfield.dart';

class SignInPg extends StatelessWidget {
  SignInPg({super.key});
  final TextEditingController email=TextEditingController();
  final TextEditingController password=TextEditingController();

  @override
  Widget build(BuildContext context) {
    var fireCtr=Provider.of<FirbaseController>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Log In",style: TextStyle(fontSize: 22,fontWeight:FontWeight.bold),),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
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
                Provider.of<FirbaseController>(context,listen: false).loginMethod(email: email.text, password: password.text);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyGallery(userUID: Provider.of<FirbaseController>(context).userUID,),));
                var shPref=await SharedPreferences.getInstance();
                shPref.setString('uid',fireCtr.userUID );
               }, child: const Text("Log in")),
            const SizedBox(height: 10,),
             Row(children: [
                const Text("Don't have an account?"),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Sign Up"))
              ],)
          ],
        ),
      ),
    );
  }
}