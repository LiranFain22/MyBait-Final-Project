import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mybait/screens/overview_manager_screen.dart';
import 'package:mybait/screens/welcome_screen.dart';

class CreateBuildingScreen extends StatefulWidget {
  static const routeName = '/registerBuilding';

  CreateBuildingScreen({super.key});

  @override
  State<CreateBuildingScreen> createState() => _CreateBuildingScreenState();
}

class _CreateBuildingScreenState extends State<CreateBuildingScreen> {
  final chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(_rnd.nextInt(chars.length))));

  final _formkey = GlobalKey<FormState>();

  var _country = '';
  var _city = '';
  var _street = '';
  var _buildingNumber = '';

  final _auth = FirebaseAuth.instance;

  void _congratulationsDialog(String joinID) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('You have created a new building!'),
          content: Text(
              'Congratulations!\nYou have created a new building\nIn order to add tenants to the building you have to share this code:\n $joinID'),
          actions: [
            CupertinoDialogAction(
              child: const Text("Got it!"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _updateApartmentNumberDialog() {
    String inputNumber = "";
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Last thing 😄'),
          content: Card(
            color: Colors.transparent,
            elevation: 0.0,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Enter Apartment Number",
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onSubmitted: (value) {
                    inputNumber = value;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    return inputNumber;
  }

  void _trySubmit(BuildContext context) {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formkey.currentState!.save();
      _submitAuthForm(
        context,
        _country.trim(),
        _city,
        _street,
        _buildingNumber,
      );
    }
  }

  void _submitAuthForm(
    BuildContext context,
    String country,
    String city,
    String street,
    String buildingNumber,
  ) async {
    try {
      String joinID = getRandomString(5);
      UserCredential userCredential = (_auth.currentUser) as UserCredential;
      await FirebaseFirestore.instance.collection("Buildings").add({
        'buildingID': 'temporary',
        'buildingNumber': buildingNumber,
        'city': city,
        'country': country,
        'joinID': joinID,
        'manager': userCredential.user?.uid,
        'street': street,
        'tenants': [userCredential.user?.uid],
      }).then((value) {
        FirebaseFirestore.instance.collection('Buildings').doc(value.id).set({
          'buildingID': value.id,
          'buildingNumber': buildingNumber,
          'city': city,
          'country': country,
          'joinID': getRandomString(5),
          'manager': userCredential.user?.uid,
          'street': street,
          'tenants': [userCredential.user?.uid]
        });

        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .update({
          'userType': 'MANAGER',
        });
      });

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).update({
        'apartmentNumber': _updateApartmentNumberDialog
      });

      _congratulationsDialog(joinID);

      await ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pushReplacementNamed(context, OverviewManagerScreen.routeName);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Theme.of(context).errorColor,
        duration: const Duration(seconds: 2),
      ));
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
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Building Information',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  key: const ValueKey('country'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.location_city_outlined),
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter country name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _country = value!;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  key: const ValueKey('city'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.location_city_outlined),
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter City Name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _city = value!;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  key: const ValueKey('Street'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.near_me_outlined),
                    labelText: 'Street',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Street Name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _street = value!;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  key: const ValueKey('Building Number'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.numbers),
                    labelText: 'Building Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Building Number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _buildingNumber = value!;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 40,
                      width: 170,
                      child: ElevatedButton(
                        child: const Text(
                          'Create Building',
                          style: TextStyle(fontSize: 17),
                        ),
                        onPressed: () {
                          _trySubmit(context);
                        },
                      ),
                    ),
                  ),
                  TextButton(
                    child: const Text('Back'),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(WelcomeScreen.routeName);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
