import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signIn';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
                //TODO IMPLMENT CONTROLLER
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                //TODO IMPLMENT CONTROLLER
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                //TODO IMPLMENT CONTROLLER
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                //TODO IMPLMENT CONTROLLER
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'First name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                //TODO IMPLMENT CONTROLLER
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Last Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                //TODO IMPLMENT CONTROLLER
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'City',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                //TODO IMPLMENT CONTROLLER
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Street',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                //TODO IMPLMENT CONTROLLER
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'building number',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                //TODO IMPLMENT CONTROLLER
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Apartment number',
                ),
              ),
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
          ],
        ),
      ),
    );
  }
}
