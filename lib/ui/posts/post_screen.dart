import 'package:fbp/ui/auth/login_screen.dart';
import 'package:fbp/ui/posts/add_post.dart';
import 'package:fbp/utilis/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Psot');
  final searchfilter = TextEditingController();
  final editController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
       // SystemNavigator.pop();
      return true;
      },
      child: Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          title: Text('Post Screen'),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: searchfilter,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(

                  )

                ),
                  onChanged: (String value){
                    setState(() {

                    });
                  }
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: Text('loading'),
                  query: ref,
                  itemBuilder: (context, snapshot, animation, index){

                  final title = snapshot.child('title').value.toString();
                  if(searchfilter.text.isEmpty){
                    return  ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(

                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value:1,
                            child: ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                showMyDialog(title,snapshot.child('id').value.toString());
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
                                  ref.child(snapshot.child('id').value.toString()).remove();
                                  Utils().toastMessage('Delete');
                                },
                                leading: Icon(Icons.update),
                                title: Text('Delete'),
                              )
                          )
                        ],
                      )
                    );
                  }
                  else if (title.toLowerCase().contains(searchfilter.text.toLowerCase().toString())){
                    return  ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  }
                  else{
                    return Container();
                  }

                  }
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPost()));
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
              ref.child(id).update({
                'title': editController.text.toLowerCase()
              }).then((value) {
                Utils().toastMessage('Post Update');
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
