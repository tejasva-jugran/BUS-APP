// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:minoragain/pages/login.page.dart';

class UserOld extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 30),
      child: Container(
        alignment: Alignment.topRight,
        //color: Colors.red,
        height: 20,
        child: Row(
          children: <Widget>[
            Text(
              'Have we met before?',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              label: Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}