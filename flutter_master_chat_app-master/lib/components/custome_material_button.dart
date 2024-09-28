import 'package:flutter/material.dart';
// this class is create for the purpose of implementing DRY principle
// since we were using similar buttons three different places we decided to
// do not repeat ourselves and reuse the code by making it independent widget

class CustomMaterialButton extends StatelessWidget {
  String buttonText = "";
  Function onPressed;
  Color buttonColor = Colors.lightBlueAccent;

  CustomMaterialButton(
      {required this.buttonText,
      required this.buttonColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            onPressed();
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
