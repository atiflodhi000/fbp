import 'package:fbp/ui/auth/forgot_password.dart';
import 'package:fbp/ui/auth/loginviaphone.dart';
import 'package:fbp/ui/auth/selectionscreen.dart';
import 'package:fbp/ui/auth/signup_screen.dart';
import 'package:fbp/ui/posts/post_screen.dart';
import 'package:fbp/utilis/utils.dart';
import 'package:fbp/widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formfield = GlobalKey<FormState>();
  final emailcontroller =TextEditingController();
  final passcontroller =TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
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
    _auth.signInWithEmailAndPassword(
        email: emailcontroller.text.toString(),
        password: passcontroller.text.toString()).then((value){
      setState(() {
        loading=false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectionScreen()));
          Utils().toastMessage('Welcome'+'\n'+value.user!.email.toString());

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
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Login'),
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
                loading: loading,
                title: 'Login',
              onTap: (){
                if(_formfield.currentState!.validate()){
                  login();

                }
              },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
                },
                    child: Text('Forgot Password?',style: TextStyle(color: Colors.deepPurple),)),
              ),
              SizedBox(height: 20,),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Dont have an account'),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                  },
                      child: Text('SignUp',style: TextStyle(color: Colors.deepPurple),))
                ],
              ),
              SizedBox(height: 30,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginWithPhone()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  child:const Center(
                    child: Text('Login with phone'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
