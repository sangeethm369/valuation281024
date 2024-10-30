import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class UploadImages extends StatefulWidget {
  const UploadImages({super.key,required this.userId});
  final String userId;

  @override
  State<UploadImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  final List<File> _images=[];
  final picker=ImagePicker();
  late CollectionReference imgRef;
  late fs.Reference ref;
  bool uploading=false;
  double val=0;
  @override
  void initState() {
    imgRef=FirebaseFirestore.instance.collection('UserImages');
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(actions: [TextButton(onPressed: (){
          setState(() {
            uploading=true;
          });
          imgUpload().whenComplete(pop(context));
          
        }, child: const Text("upload"))],),
        body: Stack(
          children: [
            GridView.builder(
              itemCount: _images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
              itemBuilder:  (context, index) {
                return Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(image: DecorationImage(image: FileImage(_images[index]),fit: BoxFit.fill)),
                );
              },),
              uploading?Center(child: CircularProgressIndicator(value: val,valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),),):Container(),
          ],
        ),
        floatingActionButton: IconButton(onPressed: (){
          chooseImages();
        }, icon: const Icon(Icons.add)),
      ),
    );
  }
  chooseImages()async{
    final imgPicker=await picker.pickImage(source: ImageSource.gallery);
    setState(() {
        _images.add(File(imgPicker!.path));
    }); 
    
  }
  pop(BuildContext context){
    Navigator.pop(context);
  }
 
  Future imgUpload()async{
    int i=1;
    for (var img in _images) {
      setState(() {
        val=i/_images.length;
      });
      ref=fs.FirebaseStorage.instance.ref().child('images/${widget.userId}/${path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async{
        await ref.getDownloadURL().then((value) {
          imgRef.add({'url':value,'userId':widget.userId});
          i++;
        },);
      },);
      
    }
  }

}