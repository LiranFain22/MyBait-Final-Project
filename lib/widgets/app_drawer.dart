import 'package:flutter/material.dart';
import 'package:mybait/screens/managing_fault_screen.dart';

import '../screens/overview_manager_screen.dart';
import '../screens/overview_tenant_screen.dart';
import '../screens/reports_screen.dart';

class AppDrawer extends StatelessWidget {
  static const routeName = '/drawer';
  String userType;

  AppDrawer(this.userType, {super.key});

  Widget userDrawerToShow(BuildContext context, String userType) {
    // print(userType);
    if (userType == 'MANAGER') {
      return Column(
        children: [
          AppBar(
            title: Text(
                'Hello $userType!'), // todo: change to name of user base Firebase!
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
        ],
      );
    }
    return Column(
      children: [
        AppBar(
          title: Text(
              'Hello $userType!'), // todo: change to name of user base Firebase!
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
            // todo: implement Payment Page
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(child: userDrawerToShow(context, userType));
  }
}
