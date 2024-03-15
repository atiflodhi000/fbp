import 'package:fbp/utilis/utils.dart';
import 'package:fbp/widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fogot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextFormField(
              controller: emailcontroller,
              decoration: InputDecoration(
                hintText: 'Email'
              ),
            ),
            SizedBox(height: 40,),
            RoundWidget(title: 'Forgot', onTap: (){
              auth.sendPasswordResetEmail(email: emailcontroller.text.toString()).then((value){
                Utils().toastMessage('Recovery mail Send to Your Email');
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            })

          ],
        ),
      ),
    );
  }
}
