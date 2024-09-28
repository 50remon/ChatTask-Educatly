import 'package:flutter/material.dart';
import 'package:flutter_master_chat_app/components/custome_material_button.dart';
import 'package:flutter_master_chat_app/constants.dart';
import 'package:flutter_master_chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "registration_screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      //here we wrap the whole body with progressHUD inorder to implement progress indicator
      // sign while disabling access to the rest of the widgets (components)
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/master_chat_icon.png'),
                  ),
                ),
                const SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kFormFieldsInputDecoration.copyWith(
                    hintText: "Enter Your Email",
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  obscuringCharacter: '#',
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kFormFieldsInputDecoration.copyWith(
                      hintText: "Enter Your Password"),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                CustomMaterialButton(
                  buttonText: "Register",
                  buttonColor: Colors.blueAccent,
                  onPressed: () async {
                    // and in here we activate the progress indicator in the async method
                    final progressIndicator = ProgressHUD.of(context);
                    progressIndicator?.showWithText("Registering ...");

                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);

                      Navigator.pushNamed(context, ChatScreen.id);
                      // and we will disable the progress indicator it after the async method finished it's work
                      progressIndicator?.dismiss();
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
