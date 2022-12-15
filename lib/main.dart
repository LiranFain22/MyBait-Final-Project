import 'package:flutter/material.dart';

import './screens/overview_manager_screen.dart';
import './screens/overview_tenant_screen.dart';

import './screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'MyBait',
      home: LoginScreen(),
      routes: {
        OverviewManagerScreen.routeName: (context) => OverviewManagerScreen(),
        OverviewTenantScreen.routeName: (context) => OverviewTenantScreen(),
      },
    );
  }
}
