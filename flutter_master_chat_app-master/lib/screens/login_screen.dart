import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master_chat_app/components/custome_material_button.dart';
import 'package:flutter_master_chat_app/constants.dart';
import 'package:flutter_master_chat_app/screens/chat_screen.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/master_chat_icon.png'),
                  ),
                ),
                SizedBox(height: 48.0),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kFormFieldsInputDecoration.copyWith(
                      hintText: "Enter Your Email"),
                ),
                SizedBox(height: 8.0),
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
                SizedBox(height: 24.0),
                CustomMaterialButton(
                  buttonText: "Login",
                  buttonColor: Colors.lightBlueAccent,
                  onPressed: () async {
                    final progressIndicator = ProgressHUD.of(context);
                    progressIndicator?.showWithText("Signing In ...");

                    if (email.isEmpty || password.isEmpty) {
                      progressIndicator?.dismiss();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter your email and password")),
                      );
                      return;
                    }

                    try {
                      var signedInUser = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);

                      if (signedInUser != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                    } on FirebaseAuthException catch (e) {
                      print("from firebase: ");
                      print(e.message);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.message ?? "Login failed")),
                      );
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("An error occurred")),
                      );
                    } finally {
                      progressIndicator?.dismiss();
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
