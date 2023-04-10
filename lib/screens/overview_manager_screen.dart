import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share/share.dart';

import '../screens/login_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/managing_fault_screen.dart';

import '../widgets/app_drawer.dart';

class MenuItem {
  final IconData icon;
  final String title;

  MenuItem(this.icon, this.title);

  IconData get getIcon {
    return icon;
  }

  String get getTitle {
    return title;
  }
}

class OverviewManagerScreen extends StatelessWidget {
  static const routeName = '/menu-manager';

  OverviewManagerScreen({super.key});

  List menuList = [
    MenuItem(Icons.error_outline, 'Managing Fault'),
    MenuItem(Icons.monetization_on_outlined, 'Cash Register'),
    MenuItem(Icons.info_outline, 'Reports'),
    MenuItem(Icons.account_circle_outlined, 'Information'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('hi ${currentUser!.displayName}! 👋🏻'),
        title: Row(
          children: const [
            Text(' MyBait '),
            Icon(Icons.home),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get()
                  .then((userDoc) {
                // String buildingID = userDoc.get('buildingID');
                String buildingID = userDoc.data()!['buildingID'];
                FirebaseFirestore.instance
                    .collection('Buildings')
                    .doc(buildingID)
                    .get()
                    .then((buildingDoc) {
                  String joinID = buildingDoc.get('joinID');
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Code to join building:'),
                      content: Row(
                        children: [
                          Text('${buildingDoc.get('joinID')}'),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Share.share(
                                  'Join my building 🏠\nThe code is: $joinID');
                            },
                            icon: const Icon(Icons.share),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure, do you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context, rootNavigator: true).pop(
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
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: menuList.length,
          itemBuilder: (context, position) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () {
                  if (menuList[position].getTitle == 'Managing Fault') {
                    Navigator.of(context)
                        .pushReplacementNamed(ManagingFaultScreen.routeName);
                  }
                  if (menuList[position].getTitle == 'Reports') {
                    Navigator.of(context)
                        .pushReplacementNamed(ReportsScreen.routeName);
                  }
                  if (menuList[position].getTitle == 'Cash Register') {
                    // todo: implement Cash Register screen
                  }
                  if (menuList[position].getTitle == 'Information') {
                    // todo: implement Information screen
                  }
                },
                child: Center(
                  child: Column(
                    children: [
                      Center(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0)),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              menuList[position].icon,
                              size: 70,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            menuList[position].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
