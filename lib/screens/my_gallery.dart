import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valuation281024/screens/upload_images.dart';

class MyGallery extends StatelessWidget {
  const MyGallery({super.key, required  this.userUID});
  final String userUID;

  @override
  Widget build(BuildContext context) {
    var ff=FirebaseFirestore.instance;
    return  Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 30,left: 5,right: 5,
            child: FutureBuilder(
              future:ff.collection("Users").doc(userUID).get() , 
              builder: (context, snapshot) {
                return  ListTile(
                  title: Text(snapshot.data!['name'],style: const TextStyle(color: Colors.green,fontSize: 20)),
                  leading: CircleAvatar(backgroundImage: NetworkImage(snapshot.data!['image']),),
                  trailing: IconButton(onPressed: ()async{
                    var shPref=await SharedPreferences.getInstance();
                    shPref.remove('userUid');
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    }
                  }, icon: const Icon(Icons.logout),tooltip: "Logout",),
                  );
              },)),
          Positioned.fill(
            top: 100,left: 0,right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15)
                  )),
              child: StreamBuilder(
                stream: ff.collection("UserImages").where("userId",isEqualTo: userUID).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState==ConnectionState.waiting||snapshot.hasError) {
                    const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Card(shadowColor: Colors.transparent,color: Colors.white,child: Image.network(snapshot.data!.docs[index]['url'],fit: BoxFit.fill,));
                    },);
                  } else {
                    return const Center(child: Text("NO Images"),);
                  }
                }
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()async{
       Navigator.push(context, MaterialPageRoute(builder: (context) => UploadImages(userId: userUID,),));
        
      },child: const Icon(Icons.add),),
    );
  }
}