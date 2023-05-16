import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybait/screens/MANAGER/overview_manager_screen.dart';
import 'package:mybait/screens/TENANT/overview_tenant_screen.dart';

import '../screens/login_screen.dart';
import '../screens/personal_Information_screen.dart';

class CustomPopupMenuButton extends StatefulWidget {
  const CustomPopupMenuButton({super.key});

  @override
  State<CustomPopupMenuButton> createState() => CustomPopupMenuButtonState();
}

class CustomPopupMenuButtonState extends State<CustomPopupMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (String value) async {
        switch (value) {
          case 'Home':
            await navigateHomeByUserType(context);
            break;
          case 'Profile':
            Navigator.pushReplacementNamed(context, PeronalInformationScreen.routeName);
            break;
          case 'Logout':
            showLogoutDialog(context);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'Home',
          child: Text('Home'),
        ),
        const PopupMenuItem<String>(
          value: 'Profile',
          child: Text('Profile'),
        ),
        const PopupMenuItem<String>(
          value: 'Logout',
          child: Text('Logout'),
        ),
      ],
    );
  }

  Future<void> navigateHomeByUserType(BuildContext context) async {
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    String userType = userDoc.data()!['userType'];
    if (userType == 'MANAGER') {
      Navigator.pushReplacementNamed(context, OverviewManagerScreen.routeName);
    } else {
      // Otherwise, userType is TENANT
      Navigator.pushReplacementNamed(context, OverviewTenantScreen.routeName);
    }
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure, do you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pop(
                  true); // dismisses only the dialog and returns true
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(
                  false); // dismisses only the dialog and returns false
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }
}
