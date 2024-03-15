import 'package:fbp/ui/posts/post_screen.dart';
import 'package:fbp/utilis/utils.dart';
import 'package:fbp/widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyCode extends StatefulWidget {
  final String verify;
  const VerifyCode({Key? key,required this.verify}) : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final  Phonenumcontroller= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 50,),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: Phonenumcontroller,
              decoration: InputDecoration(
                  hintText: '6 digit code'
              ),
            ),
            SizedBox(height: 80,),
            RoundWidget(
                loading: loading,
                title: 'Verify',
                onTap: () async{
                  setState(() {
                    loading=true;
                  });
                  final creditentials =PhoneAuthProvider.credential(
                      verificationId: widget.verify,
                      smsCode: Phonenumcontroller.text.toString()
                  );
                  try{
                    await auth.signInWithCredential(creditentials);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
                  }catch(e){
                    setState(() {
                      loading=true;
                    });
                    Utils().toastMessage(e.toString());
                  }
                },)
          ],
        ),
      ),
    );
  }
}
