// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class Forgot extends StatefulWidget {
  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 50, right: 50),
      child: Container(
        alignment: Alignment.topRight,
        height: 20,
        child: TextButton(
          onPressed: () {},
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }
}