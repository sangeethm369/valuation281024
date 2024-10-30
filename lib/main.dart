import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valuation281024/controllers/firebase_ctrl.dart';
import 'package:valuation281024/controllers/image_ctrl.dart';
import 'package:valuation281024/controllers/obsc_ctrl.dart';
import 'package:valuation281024/firebase_options.dart';
import 'package:valuation281024/screens/my_gallery.dart';
import 'package:valuation281024/screens/signup_pg.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  var shPref=await SharedPreferences.getInstance();

  runApp(MyApp(uid: shPref.getString('userUid')));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.uid});
  final String? uid;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ObscureController(),),
        ChangeNotifierProvider(create: (context) => ImageCtrl(),),
        ChangeNotifierProvider(create: (context) => FirbaseController(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
      
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: uid!=null?MyGallery(userUID: uid!):SignUpPg(),
      ),
    );
  }
}
