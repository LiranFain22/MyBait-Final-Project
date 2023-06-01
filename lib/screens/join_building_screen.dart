import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mybait/Services/firebase_helper.dart';
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
  final _formKey = GlobalKey<FormState>();
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
    // Set buildID's tenant
    await setBuildingToUser(buildingCode, userID);

    if (_isValidBuildingCode) {
      // Set apartment number
      _updateApartmentNumberDialog(buildingCode, userID);
    }

    // Update tenants array of the building
    await updateTenantsArrayOfBuilding(buildingCode, userID);

    // Update user's payments
    await FirebaseHelper.updateUserPayments(userID);
  }

  void _updateApartmentNumberDialog(String joinID, String userID) {
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
                ),
                CupertinoDialogAction(
                  child: const Text("Update"),
                  onPressed: () async {
                    var userInputAsInteger =
                        checkUserInputValidation(apartmentInputController.text);
                    if (userInputAsInteger != -1) {
                      apartmentInputController.text = userInputAsInteger.toString();
                      checkValidApartmentNumber(
                          joinID, apartmentInputController.text);
                      if (_isValidApartmentNumber == true) {
                        _congratulationsDialog(
                            userID, joinID, apartmentInputController.text);
                      }
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

  // -1 : invalid input
  // 0 or higher : correct input
  int checkUserInputValidation(String userInput) {
    RegExp numericRegex = RegExp(r'^-?[0-9]+$');
    if (userInput.isEmpty) {
      customToast.showCustomToast(
          'Please Enter Apartment Number', Colors.white, Colors.red);
      return -1;
    }
    if (!numericRegex.hasMatch(userInput)) {
      customToast.showCustomToast(
          'Apartment Number Must be Only Numbers', Colors.white, Colors.red);
      return -1;
    }
    // userInput contains only numbers
    int userInputAsInteger = int.parse(userInput);
    if (userInputAsInteger > 100) {
      customToast.showCustomToast(
          'Apartment Number Must be Equal or Less than 100',
          Colors.white,
          Colors.red);
      return -1;
    }
    if (userInputAsInteger.isNegative) {
      customToast.showCustomToast(
          'Apartment Number Must be Equal or Greater than 0',
          Colors.white,
          Colors.red);
      return -1;
    }
    return userInputAsInteger;
  }

  void checkValidApartmentNumber(String joinID, String apartmentInput) async {
    var buildingDoc = await FirebaseFirestore.instance
        .collection('Buildings')
        .where('joinID', isEqualTo: joinID)
        .get();
    if (buildingDoc.docs.isNotEmpty) {
      String buildingID = buildingDoc.docs.first.data()['buildingID'];
      QuerySnapshot buildingDocWithJoinID = await FirebaseFirestore.instance
          .collection('users')
          .where('buildingID', isEqualTo: buildingID)
          .where('apartmentNumber', isEqualTo: apartmentInput)
          .get();
      if (buildingDocWithJoinID.docs.isNotEmpty) {
        customToast.showCustomToast('The apartment number is already in use ⛔️',
            Colors.white, Colors.red);
        // Number apartment already exists!
        setStateIsValidApartmentNumber(false);
      } else {
        // Number apartment new!
        setStateIsValidApartmentNumber(true);
      }
    } else {
      debugPrint('*** Something went wrong ***');
      customToast.showCustomToast(
          '*** Something went wrong ***', Colors.white, Colors.red);
    }
  }

  void setStateIsValidApartmentNumber(bool state) {
    _isValidApartmentNumber = state;
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
                await updateTENANTApartmentNumber(userID, inputNumber, context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateTENANTApartmentNumber(
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
            setStateIsValidBuildingCode(false);
          } else {
            String buildingID = buildingDocs.docs.first.data()['buildingID'];
            FirebaseFirestore.instance
                .collection('users')
                .doc(userID)
                .update({'buildingID': buildingID});
            setStateIsValidBuildingCode(true);
          }
        });
      });
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  void setStateIsValidBuildingCode(bool state) {
    setState(() {
      _isValidBuildingCode = state;
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
      customToast.showCustomToast(error.toString(), Colors.white, Colors.red);
      debugPrint("Failed to fetch documents: $error");
    });
  }
}
