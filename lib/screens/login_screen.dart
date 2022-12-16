import 'package:flutter/material.dart';
import 'package:mybait/screens/overview_tenant_screen.dart';

import '../screens/overview_manager_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isUserNameValidate = false;
  bool _isPasswordValidate = false;

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginValidation(TextEditingController userNameController,
      TextEditingController passwordController) {
    if (userNameController.text == 'admin') {
      if (passwordController.text == 'admin') {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Login successful!'),
          duration: Duration(seconds: 2),
        ));
        Navigator.of(context)
            .pushReplacementNamed(OverviewManagerScreen.routeName);
      } else {
        // userName correct, password incorrect
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username or Password Invalid, please Try again...'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      // userName incorrect
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username or Password Invalid, please Try again...'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    if (userNameController.text == 'user') {
      if (passwordController.text == 'user') {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Login successful!'),
          duration: Duration(seconds: 2),
        ));
        Navigator.of(context)
            .pushReplacementNamed(OverviewTenantScreen.routeName);
      } else {
        // userName correct, password incorrect
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username or Password Invalid, please Try again...'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      // userName incorrect
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username or Password Invalid, please Try again...'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
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
              child: const Text(
                'Sign in',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: userNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                  errorText: _isUserNameValidate ? 'Field is empty' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  errorText: _isPasswordValidate ? 'Field is empty' : null,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // todo: implement forgot password screen
              },
              child: const Text('Forgot Password'),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    setState(() {
                      loginValidation(userNameController, passwordController);
                      userNameController.text.isEmpty ? _isUserNameValidate = true : _isUserNameValidate = false;
                      passwordController.text.isEmpty ? _isPasswordValidate = true : _isPasswordValidate = false;
                    });
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    // todo: implement forgot sign-up screen
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
