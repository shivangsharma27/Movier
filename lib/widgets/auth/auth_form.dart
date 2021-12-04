import 'package:flutter/material.dart';
import '../global.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;

  AuthForm(
    this.isLoading,
  );

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  

  Future<void> _trySubmit() async {
    try {
      setState(() {
        _isLoading = true;
      });
      GoogleSignInAccount googleSignInAccount = await globals.googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/Movier.png',
              width: MediaQuery.of(context).size.width - 60,
            ), // for logo
            SizedBox(
              height: 50,
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white,))
                : Form(
                    key: _formKey,
                    child: SignInButtonBuilder(
                      text: 'Sign in with Google',
                      fontSize: 18,
                      onPressed: _trySubmit,
                      backgroundColor: Colors.blueGrey[800],
                      image: Container(
                        // padding: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Image.asset('assets/images/google.png'),
                      ),
                      padding: EdgeInsets.only(left: 15),
                      width: MediaQuery.of(context).size.width * 0.7,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}


// ButtonStyle(
//                       shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10))),
//                       padding: MaterialStateProperty.all(EdgeInsets.all(13)),
//                       elevation: MaterialStateProperty.all(10),
//                       backgroundColor:
//                           MaterialStateProperty.all(globals.themeColor[900]),
//                     ),