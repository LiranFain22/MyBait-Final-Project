import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/welcome_screen.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    return userCredential;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        UserCredential? userCredential = await _signInWithGoogle();
        if (userCredential != null) {
          // Handle successful sign-in
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.uid)
              .set({
            'uid': userCredential.user!.uid,
            'userType': 'TENANT',
            'email': userCredential.user!.email,
            'firstName': userCredential.user!.displayName,
          });
          await ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
        }
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          elevation: 10,
          side: const BorderSide(
            width: 0.5,
            color: Colors.blue,
          )),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Image(
            image: AssetImage("assets/google_logo.png"),
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
