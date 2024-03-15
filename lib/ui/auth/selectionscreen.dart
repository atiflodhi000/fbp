import 'package:fbp/firestore/firestore_list_screen.dart';
import 'package:fbp/ui/posts/post_screen.dart';
import 'package:fbp/ui/upload_image.dart';
import 'package:fbp/widget/round_button.dart';
import 'package:flutter/material.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         Padding(
           padding: const EdgeInsets.all(20),
           child: RoundWidget(
               title: 'RealTime DataBAse',
               onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
               }),
         ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: RoundWidget(
                title: ''
                    'firestore DataBAse',
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FireStoreScreen()));
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: RoundWidget(
                title: ''
                    'Image Upload in fb',
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadImage()));
                }),
          )
        ],
      ),
    );
  }
}
