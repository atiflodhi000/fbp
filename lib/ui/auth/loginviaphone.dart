import 'package:fbp/ui/auth/verifycode.dart';
import 'package:fbp/utilis/utils.dart';
import 'package:fbp/widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({Key? key}) : super(key: key);

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final  Phonenumcontroller= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with Phone'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 50,),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: Phonenumcontroller,
              decoration: InputDecoration(
                hintText: '+92 300 1234567'
              ),
            ),
            SizedBox(height: 80,),
            RoundWidget(
              loading: loading,
                title: 'Login',
                onTap: (){
                  setState(() {
                    loading=true;
                  });
                  auth.verifyPhoneNumber(
                    phoneNumber: Phonenumcontroller.text.toString(),
                      verificationCompleted: (_){
                        setState(() {
                          loading=false;
                        });
                      },
                      verificationFailed: (e){
                      Utils().toastMessage(e.toString());
                      },
                      codeSent: (String verification,int? token){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyCode(verify: verification,)));
                      setState(() {
                        loading=false;
                      });
                      },
                      codeAutoRetrievalTimeout: (e){
                      Utils().toastMessage(e.toString());
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
