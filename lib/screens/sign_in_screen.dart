import 'package:flutter/material.dart';

import './TENANT/overview_tenant_screen.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signIn';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    passwordController1.dispose();
    passwordController2.dispose();
    super.dispose();
  }

  void signInValidation(TextEditingController userNameController,
      TextEditingController passwordController,
      TextEditingController valPasswordController) {
    if(passwordController.text != valPasswordController.text){
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The passwords are different, please Try again...'),
          duration: Duration(seconds: 3),
        ),
      );
    }
    //if(userNameController.text.contains(other))
    //TODO check for SPECIAL CHARACTERS
    //https://stackoverflow.com/questions/52835450/flutter-how-to-avoid-special-characters-in-validator
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: userNameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: passwordController1,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: passwordController2,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Confirm the password',
                ),
              ),
            ),
            TextButton(
              child: const Text(
                'next',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const _SignInScreenInfo()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _SignInScreenInfo extends StatelessWidget {
  const _SignInScreenInfo({super.key});
//TODO ADD TextEditingController AND CHANGE THE NAVIGATION FROM SIGN IN SCREEN STATE TO SIGN IN INFO
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
                'Personal Information',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //const SizedBox(height: 40.0),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                    //TODO IMPLMENT CONTROLLER
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'First name',
                    ),
                  ),
                  )
                ),
                Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        //TODO IMPLMENT CONTROLLER
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Last name',
                        ),
                      ),
                    )
                ),
              ],
            ),
            Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        //TODO IMPLMENT CONTROLLER
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'City',
                        ),
                      ),
                    )
                ),
                Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        //TODO IMPLMENT CONTROLLER
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Street',
                        ),
                      ),
                    )
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        //TODO IMPLMENT CONTROLLER
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'building number',
                        ),
                      ),
                    )
                ),
                Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        //TODO IMPLMENT CONTROLLER
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Apartment number',
                        ),
                      ),
                    )
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                //TODO IMPLMENT CONTROLLER
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Email Address',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                //TODO IMPLMENT CONTROLLER
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'payment',
                ),
              ),
            ),
            TextButton(
              child: const Text(
                'next',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Account successfully created!'),
                  duration: Duration(seconds: 2),
                ));
                //TODO MOVE TO TENANT SCREEN
                //Navigator.of(context).pushReplacementNamed(OverviewTenantScreen.routeName);
              },
            )
          ],
        ),
      ),
    );
  }
}
