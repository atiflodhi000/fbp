import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbp/firestore/add_firestore_data.dart';
import 'package:fbp/ui/auth/login_screen.dart';
import 'package:fbp/ui/posts/add_post.dart';
import 'package:fbp/utilis/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/services.dart';
import 'package:fbp/ui/auth/login_screen.dart';
import 'package:fbp/ui/posts/add_post.dart';
import 'package:fbp/utilis/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({Key? key}) : super(key: key);

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  //final ref1 = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
       // SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
         // automaticallyImplyLeading: false,
          title: Text('FireStore Screen'),
          centerTitle: true,
          actions: [
            InkWell(
                onTap: (){
                  auth.signOut().then((value){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                    Utils().toastMessage('Logout');
                  }).onError((error, stackTrace){
                    Utils().toastMessage(error.toString());
                  });

                },
                child: Icon(Icons.logout_outlined,color: Colors.white,)),
            SizedBox(width: 20,),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 10,),
            StreamBuilder<QuerySnapshot>(
              stream: firestore,
                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting)
                    return CircularProgressIndicator();
                  if(snapshot.hasError)
                    return Text('Some Error');
                  return Expanded(

                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context,index){
                            final title=snapshot.data!.docs[index]['title'].toString();
                            return ListTile(
                              title: Text(snapshot.data!.docs[index]['title'].toString()),
                              subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                                trailing: PopupMenuButton(

                                  icon: Icon(Icons.more_vert),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value:1,
                                        child: ListTile(
                                          onTap: (){
                                            Navigator.pop(context);
                                            showMyDialog(title,snapshot.data!.docs[index]['id'].toString());
                                          },
                                          leading: Icon(Icons.edit),
                                          title: Text('Edit'),
                                        )
                                    ),
                                    PopupMenuItem(
                                        value:1,
                                        child: ListTile(
                                          onTap: (){
                                            Navigator.pop(context);
                                            ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                                            Utils().toastMessage('Delete');
                                          },
                                          leading: Icon(Icons.update),
                                          title: Text('Delete'),
                                        )
                                    )
                                  ],
                                )
                            );
                          })
                  );
                }
            ),

          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFirestoreDataScreen()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> showMyDialog(String title,String id) async{
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(
                    hintText: 'Edit'
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Cancel')),
              TextButton(onPressed: (){
                ref.doc(id).update({
                  'title': editController.text.toLowerCase()
                }).then((value) {
                  Utils().toastMessage("updated");
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
                Navigator.pop(context);
              }, child: Text('Update')),

            ],
          );
        }
    );
  }

}
