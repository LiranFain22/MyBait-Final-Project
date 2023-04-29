import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mybait/screens/TENANT/overview_tenant_screen.dart';

import 'package:mybait/screens/welcome_screen.dart';

import '../widgets/custom_toast.dart';

class JoinBuildingScreen extends StatefulWidget {
  static const routeName = '/joinBuilding';
  const JoinBuildingScreen({super.key});

  @override
  State<JoinBuildingScreen> createState() => _JoinBuildingScreenState();
}

class _JoinBuildingScreenState extends State<JoinBuildingScreen> {
  var customToast = CustomToast();
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final buildingIDController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;

  final apartmentInputController = TextEditingController();

  bool _isSubmitted = false;
  bool _updateBTNPressed = false;
  bool _isValidApartmentNumber = false;
  bool _isValidBuildingCode = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    buildingIDController.dispose();
    apartmentInputController.dispose();
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
                    } catch (error) {
                      customToast.showCustomToast(
                          error.toString(), Colors.white, Colors.red);
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

    if (_isValidBuildingCode) {
      // Set apartment number
      _updateApartmentNumberDialog(buildingCode, userID);
    }

    // Update user's payments
    await updateUserPayments(userID);
  }

  Future<void> updateUserPayments(String userID) async {
    var now = DateTime.now();
    var currentMonth = now.month;
    var currentYear = now.year;

    // Loop through the remaining months of the year, starting from the current month
    for (var i = currentMonth; i <= 12; i++) {
      var month = DateFormat('MMMM').format(DateTime(currentYear, i));

      await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('payments')
        .doc(currentYear.toString())
        .collection('House committee payments')
        .doc(month)
        .set({
          'title': 'Month Payment: $month',
          'paymentType': 'month',
          'amount': '30',
          'isPaid': false,
          'monthNumber': i,
        });
    }
  }

  void _updateApartmentNumberDialog(String joinID, String userID) {
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
                TextFormField(
                  controller: apartmentInputController,
                  decoration: InputDecoration(
                    labelText: "Enter Apartment Number",
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: (userInput) {
                    RegExp numericRegex = RegExp(r'^-?[0-9]+$');
                    if (userInput!.isEmpty) {
                      return 'Please Enter Apartment Number';
                    }
                    if (!numericRegex.hasMatch(userInput)) {
                      return 'Apartment Number Must be Only Numbers';
                    } else {
                      // userInput contains only numbers
                      int userInputAsInteger = int.parse(userInput);
                      if (userInputAsInteger > 100) {
                        return 'Apartment Number Must be Equal or Less than 100';
                      }
                    }
                    return null;
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("Update"),
                  onPressed: () async {
                    checkValidApartmentNumber(
                        joinID, apartmentInputController.text);
                    if (_isValidApartmentNumber) {
                      _congratulationsDialog(
                          userID, joinID, apartmentInputController.text);
                    } else {
                      customToast.showCustomToast(
                          'The apartment number is already in use ⛔️',
                          Colors.white,
                          Colors.red);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void checkValidApartmentNumber(String joinID, String apartmentInput) async {
    // 1. get building id with the help of joinID
    try {
      await FirebaseFirestore.instance
          .collection('Buildings')
          .where('joinID', isEqualTo: joinID)
          .get()
          .then((buildingDocs) {
        String buildingID = buildingDocs.docs.first.data()['buildingID'];
        // 2. check if there is not user with same buildingID AND apartment number
        FirebaseFirestore.instance
            .collection('users')
            .where('buildingID', isEqualTo: buildingID)
            .where('joinID', isEqualTo: joinID)
            .get()
            .then((result) {
          setState(() {
            // 3. if there is not one there continue flow, otherwise error number -> 'The apartment number is already in use'
            if (result.docs.isNotEmpty) {
              _isValidApartmentNumber = false;
            } else {
              _isValidApartmentNumber = true;
            }
          });
        });
      });
    } on Exception catch (e) {
      customToast.showCustomToast(e.toString(), Colors.white, Colors.red);
    }
  }

  Future<void> _congratulationsDialog(
      String userID, String joinID, String inputNumber) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You have join a new building'),
          actions: [
            CupertinoDialogAction(
              child: const Text("Got it!"),
              onPressed: () async {
                await updateApartmentNumber(userID, inputNumber, context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateApartmentNumber(
      String userID, String inputNumber, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .update({'apartmentNumber': inputNumber});
    _updateBTNPressed = true;
    Navigator.of(context).pop();
    Navigator.pushReplacementNamed(context, OverviewTenantScreen.routeName);
  }

  Future<void> setBuildingToUser(String buildingCode, String userID) async {
    try {
      await FirebaseFirestore.instance
          .collection('Buildings')
          .where('joinID', isEqualTo: buildingCode)
          .get()
          .then((buildingDocs) {
        setState(() {
          if (buildingDocs.docs.isEmpty) {
            customToast.showCustomToast(
                'Invalid Building Code', Colors.white, Colors.red);
            _isValidBuildingCode = false;
          } else {
            String buildingID = buildingDocs.docs.first.data()['buildingID'];
            FirebaseFirestore.instance
                .collection('users')
                .doc(userID)
                .update({'buildingID': buildingID});
            _isValidBuildingCode = true;
          }
        });
      });
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
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
      customToast.showCustomToast(error.toString(), Colors.white, Colors.red);
      debugPrint("Failed to fetch documents: $error");
    });
  }
}
