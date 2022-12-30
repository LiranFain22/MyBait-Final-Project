import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mybait/screens/login_screen.dart';

import 'reports_screen.dart';

import '../models/report.dart';
import '../widgets/app_drawer.dart';

class _MenuItem {
  final IconData icon;
  final String title;

  _MenuItem(this.icon, this.title);

  IconData get getIcon {
    return icon;
  }

  String get getTitle {
    return title;
  }
}

class OverviewTenantScreen extends StatefulWidget {
  static const routeName = '/menu-tenant';
  String userType;

  OverviewTenantScreen(this.userType, {super.key});

  @override
  State<OverviewTenantScreen> createState() => _OverviewTenantScreenState();
}

class _OverviewTenantScreenState extends State<OverviewTenantScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final String userType = 'TENANT';
  List menuList = [
    _MenuItem(Icons.report_gmailerrorred, 'Report'),
    _MenuItem(Icons.payment_outlined, 'Payment'),
    _MenuItem(Icons.info_outline, 'Information'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenant - Main'),
        actions: [
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
            },
          ),
        ],
      ),
      drawer: AppDrawer(widget.userType),
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
                  if (menuList[position].getTitle == 'Report') {
                    Navigator.of(context).pushReplacementNamed(ReportsScreen.routeName);
                  }
                  if (menuList[position].getTitle == 'Payment') {
                    // todo: implement payment screen
                  }
                  if (menuList[position].getTitle == 'Information') {
                    // todo: implement information screen
                  }
                },
                child: Center(
                  child: Column(
                    children: [
                      Center(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0)),
                          elevation: 10,
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
