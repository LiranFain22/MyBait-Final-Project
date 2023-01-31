import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybait/screens/managing_fault_screen.dart';
import 'package:mybait/screens/payment_screen.dart';

import '../screens/login_screen.dart';
import '../screens/overview_manager_screen.dart';
import '../screens/overview_tenant_screen.dart';
import '../screens/reports_screen.dart';

class AppDrawer extends StatelessWidget {
  static const routeName = '/drawer';
  User? user = FirebaseAuth.instance.currentUser;
  String userType = '';

  AppDrawer({super.key});

  Widget userDrawerToShow(BuildContext context) {
    user!.email!.contains('manager')
        ? userType = 'MANAGER'
        : userType = 'TENANT';
    if (userType == 'MANAGER') {
      return Column(
        children: [
          AppBar(
            title: const Text(
                'What you like to do?'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OverviewManagerScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.error_outline),
            title: Text('Managing Fault'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ManagingFaultScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.attach_money_outlined),
            title: Text('Cash Register'),
            onTap: () {
              // todo: implement Cash Register Page
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.report_gmailerrorred),
            title: Text('Reports'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ReportsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text('Information'),
            onTap: () {
              // todo: implement Information Page
            },
          ),
           const Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
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
      );
    }
    return Column(
      children: [
        AppBar(
         title: const Text(
                'What you like to do? 🤔'),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(OverviewTenantScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.report_gmailerrorred),
          title: Text('Reports'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(ReportsScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.payment_outlined),
          title: Text('Payment'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(PaymentScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('Information'),
          onTap: () {
            // todo: implement Information Page
          },
        ),
         const Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(child: userDrawerToShow(context));
  }
}
