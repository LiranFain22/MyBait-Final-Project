import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/app_drawer.dart';

class PeronalInformationScreen extends StatefulWidget {
  static const routeName = '/personalInformation';

  const PeronalInformationScreen({super.key});

  @override
  State<PeronalInformationScreen> createState() => _PeronalInformationScreen();
}

class _PeronalInformationScreen extends State<PeronalInformationScreen> {
  String? firstName = '';
  String? lastName = '';
  String? userType = '';
  String? email = '';
  String? apartmentNumber = '';
  String? buildingID = '';

  //TODO change to building info

  Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          firstName = snapshot.data()!["firstName"];
          lastName = snapshot.data()!["lastName"];
          userType = snapshot.data()!["userType"];
          email = snapshot.data()!["email"];
          apartmentNumber = snapshot.data()!["apartmentNumber"];
          buildingID = snapshot.data()!["buildingID"];
        });
      }
    });
  }

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    _getDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text(' My Information '),
            Icon(Icons.home),
          ],
        ),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          const SizedBox(
            height: 80.0,
          ),
          Column(
            children: <Widget>[
              const Text(
                'Name:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                    color: Colors.black87,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                '${firstName!} ${lastName!}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                'user type:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                '${userType?.toLowerCase()!}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                'email:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                email!,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                'apartment number:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                apartmentNumber!,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                'address:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                buildingID!,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                ),
              ),
            ].map((widget) => Padding(
              padding: const EdgeInsets.only(left: 60.0,),
              child: widget,
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
