import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mybait/screens/MANAGER/overview_manager_screen.dart';
import 'package:mybait/screens/TENANT/overview_tenant_screen.dart';
import 'package:mybait/screens/register_screen.dart';
import '../widgets/custom_toast.dart';

import '../widgets/signInWithGoogle.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _isLoading = false;
  var _userType = '';

  var customToast = CustomToast();

  void _trySubmit() {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formkey.currentState!.save();
      _submitAuthForm(
          _userEmail.trim(), _userName.trim(), _userPassword.trim(), _isLogin);
    }
  }

  void _submitAuthForm(
      String email, String username, String password, bool isLogin) async {
    UserCredential userCredential;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get()
            .then((value) {
          setState(() {
            _userType = value.data()!['userType'];
          });
        });

        customToast.showCustomToast('Login successfully 🥳', Colors.white, Colors.green);

        if (_userType == 'MANAGER') {
          Navigator.pushReplacementNamed(
              context, OverviewManagerScreen.routeName);
        } else {
          Navigator.pushReplacementNamed(
              context, OverviewTenantScreen.routeName);
        }
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': username,
          'email': email,
          'uid': userCredential.user!.uid,
          'userType': 'TENANT',
        });

        customToast.showCustomToast('Login successfully 🥳', Colors.white, Colors.green);

        Navigator.pushReplacementNamed(context, OverviewTenantScreen.routeName);

      }
    } on PlatformException catch (error) {
      var message = 'An error occurred, please check your credentials!';

      if (error.message != null) {
        message = error.message!;
      }

      customToast.showCustomToast(message, Colors.white, Colors.red);

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      customToast.showCustomToast('An error occurred, please check your credentials!', Colors.white, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'MyBait',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.home_outlined,
                    color: Colors.blue,
                    size: 40,
                  )
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  _isLogin ? 'Login' : 'Sign in',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  key: ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.email_outlined),
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please Enter an Correct Email Address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                ),
              ),
              if (!_isLogin)
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    key: ValueKey('username'),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.account_box_outlined),
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please Enter at least 4 character';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value!;
                    },
                  ),
                ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  key: ValueKey('password'),
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.lock_outline),
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userPassword = value!;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              if (_isLoading) const CircularProgressIndicator.adaptive(),
              if (!_isLoading)
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                      onPressed: _trySubmit,
                    )),
              if (!_isLoading)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      child: const Text(
                        'Create new account',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RegisterScreen.routeName);
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ForgotPasswordScreen.routeName);
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: const [
                        Expanded(child: Divider()),
                        Text("Or continue with"),
                        Expanded(child: Divider()),
                      ]),
                    ),
                    GoogleSignInButton(_userType),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
