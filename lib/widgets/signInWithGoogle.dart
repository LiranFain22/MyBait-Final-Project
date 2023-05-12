import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/MANAGER/overview_manager_screen.dart';
import '../screens/TENANT/overview_tenant_screen.dart';
import '../screens/welcome_screen.dart';
import 'custom_toast.dart';

class GoogleSignInButton extends StatefulWidget {
  final String userType;
  const GoogleSignInButton(this.userType, {super.key});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  var customToast = CustomToast();
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
          // todo: Handle successful sign-in
          // Get a reference to the user's document you want to check
          DocumentReference documentReference = FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid);

          // Retrieve user's  document snapshot
          DocumentSnapshot userDocumentSnapshot = await documentReference.get();

          // Check if the user's document exists
          if (userDocumentSnapshot.exists) {
            // User's document exists, check if the 'buildingID' field exists
            Map<String, dynamic> data =
                userDocumentSnapshot.data() as Map<String, dynamic>;
            if (data.containsKey('buildingID')) {
              // 'buildingID' field exists, check which type of user is
              if (data.containsValue('MANAGER')) {
                Navigator.pushReplacementNamed(
                    context, OverviewManagerScreen.routeName);
              } else {
                Navigator.pushReplacementNamed(
                    context, OverviewTenantScreen.routeName);
              }
            }
          } else {
            createNewUser(userCredential, context);
          }
        } else {}
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

  Future<void> createNewUser(
      UserCredential userCredential, BuildContext context) async {
    final String? token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userCredential.user!.uid)
        .set({
      'uid': userCredential.user!.uid,
      'userType': 'TENANT',
      'email': userCredential.user!.email,
      'userName': userCredential.user!.displayName,
      'token': token,
    });
    customToast.showCustomToast(
        'Login successfully 🥳', Colors.white, Colors.green);
    Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
  }
}
