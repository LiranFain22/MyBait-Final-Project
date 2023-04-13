import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybait/screens/TENANT/overview_tenant_screen.dart';

import 'package:mybait/screens/welcome_screen.dart';

class JoinBuildingScreen extends StatefulWidget {
  static const routeName = '/joinBuilding';
  const JoinBuildingScreen({super.key});

  @override
  State<JoinBuildingScreen> createState() => _JoinBuildingScreenState();
}

class _JoinBuildingScreenState extends State<JoinBuildingScreen> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final buildingIDController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    buildingIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'MyBait',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
            ),
            const Icon(
              Icons.home_outlined,
              color: Colors.white,
              size: 40,
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: buildingIDController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Building Code',
                  hintText: 'Enter Building Code Here',
                ),
                autofocus: false,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    try {
                      onSubmitCodeBuilding(
                          buildingIDController.text, currentUser!.uid);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Congratulations! 🥳\nYou have successfully joined the building!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pushReplacementNamed(
                          context, OverviewTenantScreen.routeName);
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                          backgroundColor: Theme.of(context).errorColor,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Enter',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, WelcomeScreen.routeName);
                  },
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> onSubmitCodeBuilding(String buildingCode, String userID) async {
    // Update tenants array of the building
    await updateTenantsArrayOfBuilding(buildingCode, userID);

    // Set buildID's tenant
    await setBuildingToUser(buildingCode, userID);
  }

  Future<void> setBuildingToUser(String buildingCode, String userID) async {
    await FirebaseFirestore.instance
        .collection('Buildings')
        .where('joinID', isEqualTo: buildingCode)
        .get()
        .then((buildingDocs) {
      String buildingID = buildingDocs.docs.first.data()['buildingID'];
      FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .update({'buildingID': buildingID});
    });
  }

  Future<void> updateTenantsArrayOfBuilding(
      String buildingCode, String userID) async {
    await FirebaseFirestore.instance
        .collection('Buildings')
        .where('joinID', isEqualTo: buildingCode)
        .get()
        .then((buildingsDocs) {
      List<dynamic> tenantsList;
      for (var building in buildingsDocs.docs) {
        // Fetch List of tenants from Firebase
        tenantsList = building.data()['tenants'];

        // Add user to List of tenants of building
        tenantsList.add(userID);

        building.reference.update({
          // Update list of tenants in Firebase
          'tenants': tenantsList
        });
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        ),
      );
      debugPrint("Failed to fetch documents: $error");
    });
  }
}
