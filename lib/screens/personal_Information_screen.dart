import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybait/Services/firebase_helper.dart';
import 'package:mybait/widgets/custom_popupMenuButton.dart';
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
  String? address = '';

  //TODO change to building info

  Future _getDataFromDatabase() async {
    String buildingID = await FirebaseHelper.fetchBuildingID();
    DocumentSnapshot<Map<String, dynamic>> buildingDoc = await FirebaseFirestore
        .instance
        .collection('Buildings')
        .doc(buildingID)
        .get();
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
          address = buildingDoc.get('street');
          String country = buildingDoc.get('country');
          address = '$address, $country';
        });
      }
    });
  }

  @override
  void initState() {
    _getDataFromDatabase();
    super.initState();
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
        actions: [CustomPopupMenuButton()],
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 80.0,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  firstName != null
                      ? Text(
                          '${firstName!} ${lastName!}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black54,
                          ),
                        )
                      : Text(
                          '${FirebaseAuth.instance.currentUser!.displayName}',
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
                    '${userType?.toLowerCase()}',
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
                    address!,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
