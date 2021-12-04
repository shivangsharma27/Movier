import '../main.dart';
import '../widgets/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../widgets/global.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/images/bg.png',fit: BoxFit.cover,),
          ),
          AuthForm(
            _isLoading,
          ),
        ],
      ),
    );
  }
}
