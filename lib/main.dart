import 'package:flutter/material.dart';

import 'package:mybait/screens/overview_manager_screen.dart';
import 'package:mybait/screens/overview_tenant_screen.dart';
import 'package:mybait/screens/sign_in_screen.dart';
import './screens/reports_screen.dart';
import './screens/edit_report_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'MyBait',
      home: SingInScreen(),
      routes: {
        OverviewManagerScreen.routeName: (context) => OverviewManagerScreen(),
        OverviewTenantScreen.routeName: (context) => OverviewTenantScreen(),
        ReportsScreen.routeName: (context) => ReportsScreen(''),
        EditReportScreen.routeName:(context) => EditReportScreen(),
      },
    );
  }
}
