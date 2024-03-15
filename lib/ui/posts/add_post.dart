import 'package:fbp/utilis/utils.dart';
import 'package:fbp/widget/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final postcontroller = TextEditingController();
  bool loading = false;
  final databaseref = FirebaseDatabase.instance.ref('Psot');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: postcontroller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'What is in your mind',
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RoundWidget(title: 'Add',
                loading: loading,
                onTap: (){
              setState(() {
                loading=true;
              });

              String id = DateTime.now().microsecondsSinceEpoch.toString();
              databaseref.child(id).set({
                'id': id,
                'title':postcontroller.text.toString()
              }).then((value){
                Utils().toastMessage('Post Added');
                setState(() {
                  loading=false;
                });
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
                setState(() {
                  loading=false;
                });
              });
            })
          ],
        ),
      ),
    );
  }
}
