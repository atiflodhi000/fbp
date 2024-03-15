import 'package:fbp/ui/auth/login_screen.dart';
import 'package:fbp/ui/auth/signup_screen.dart';
import 'package:fbp/utilis/utils.dart';
import 'package:fbp/widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  final _formfield = GlobalKey<FormState>();
  final emailcontroller =TextEditingController();
  final passcontroller =TextEditingController();
  FirebaseAuth _auth =FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontroller.dispose();
    passcontroller.dispose();
  }
  void login(){
    setState(() {
      loading=true;
    });
    _auth.createUserWithEmailAndPassword(
        email: emailcontroller.text.toString(),
        password: passcontroller.text.toString()).then((value){
          Utils().toastMessage('Registered Successfully'+'\n'+value.user!.email.toString());
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      setState(() {
        loading=false;
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading=false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Text('SignUp'),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formfield,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailcontroller,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter Email';
                        }else
                        {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline_rounded)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter Password';
                        }else
                        {
                          return null;
                        }
                      },
                    ),
                  ],
                )),
            SizedBox(height: 50,),
            RoundWidget(
              title: 'SignUp',
              loading: loading,
              onTap: (){
                setState(() {
                  loading=false;
                });
                if(_formfield.currentState!.validate()){
                  login();
                }
              },
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account'),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                },
                    child: Text('Login',style: TextStyle(color: Colors.deepPurple),))
              ],
            )
          ],
        ),
      ),
    );
  }
}
