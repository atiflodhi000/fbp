
import 'dart:io';
import 'dart:math';

import 'package:fbp/utilis/utils.dart';
import 'package:fbp/widget/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  bool loading= false;
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseref = FirebaseDatabase.instance.ref('Post');

  Future getImageGallery() async{
    final pickedfile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
    setState(() {
      if(pickedfile != null){
        _image = File(pickedfile.path);
      }else{
        Utils().toastMessage('no image pic');
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('upload image'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: (){
                  getImageGallery();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  child: _image != null ? Image.file(_image!.absolute) : Center(child: Icon(Icons.image)),
                ),
              ),
            ),
            SizedBox(height: 10,),
            RoundWidget(
              loading: loading,
                title: 'upload',
                onTap: () async{
                  setState(() {
                    loading=true;
                  });
                  final id =DateTime.now().millisecondsSinceEpoch.toString();
                  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/atif/'+id);
                  firebase_storage.UploadTask uploadtask = ref.putFile(_image!.absolute);


                  Future.value(uploadtask).then((value) async{
                    var newUrl =await ref.getDownloadURL();
                    databaseref.child(id).set({
                      'id':id,
                      'title':  newUrl.toString()
                    }).then((value){
                      setState(() {
                        loading=false;
                      });
                      Utils().toastMessage('uploaded');
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading=false;
                      });
                      Utils().toastMessage(error.toString());
                    });

                  }).onError((error, stackTrace) {
                    setState(() {
                      loading=false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                         }),

          ],
        ),
      ),
    );
  }
}
