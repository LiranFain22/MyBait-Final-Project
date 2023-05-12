import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mybait/screens/TENANT/payment_screen.dart';
import 'package:mybait/screens/login_screen.dart';

import '../personal_Information_screen.dart';
import '../reports_screen.dart';

import '../../widgets/app_drawer.dart';
import '../summary_screen.dart';
import '../surveys_screen.dart';

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

  OverviewTenantScreen({super.key});

  @override
  State<OverviewTenantScreen> createState() => _OverviewTenantScreenState();
}

class _OverviewTenantScreenState extends State<OverviewTenantScreen> {



  final currentUser = FirebaseAuth.instance.currentUser;  

  List menuList = [
    _MenuItem(Icons.report_gmailerrorred, 'Report'),
    _MenuItem(Icons.payment_outlined, 'Payment'),
    _MenuItem(Icons.info_outline, 'Information'),
    _MenuItem(Icons.insert_chart, 'Surveys'),
    _MenuItem(Icons.assignment, 'Summary'), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text(' MyBait '),
            Icon(Icons.home),
          ],
        ),
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
                      onPressed: () async {
                        final String? token = await FirebaseMessaging.instance.getToken();
                        print(token);
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
      drawer: const AppDrawer(),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Hi ${FirebaseAuth.instance.currentUser!.displayName}! 👋🏻',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: menuList.length,
                  itemBuilder: (context, position) {
                    return Padding(
                      padding: const EdgeInsets.all(0),
                      child: InkWell(
                        onTap: () {
                          if (menuList[position].getTitle == 'Report') {
                            Navigator.of(context)
                                .pushNamed(ReportsScreen.routeName);
                          }
                          if (menuList[position].getTitle == 'Payment') {
                            Navigator.of(context)
                                .pushNamed(PaymentScreen.routeName);
                          }
                          if (menuList[position].getTitle == 'Information') {
                            Navigator.of(context)
                                .pushNamed(PeronalInformationScreen.routeName);
                          }
                          if (menuList[position].getTitle == 'Surveys') {
                            Navigator.of(context)
                                .pushReplacementNamed(SurveysScreen.routeName);
                          }
                          if (menuList[position].getTitle == 'Summary') {
                            Navigator.of(context)
                                .pushReplacementNamed(SummeryScreen.routeName);
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
            ),
          ],
        ),
      ),
    );
  }
}
