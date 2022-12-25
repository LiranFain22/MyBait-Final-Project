import 'package:flutter/material.dart';
import 'package:mybait/providers/reports.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import './screens/overview_manager_screen.dart';
import './screens/overview_tenant_screen.dart';
import './screens/reports_screen.dart';
import './screens/edit_report_screen.dart';
import './screens/login_screen.dart';
import './screens/managing_fault_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyBait',
      home: LoginScreen(),
      routes: {
        OverviewManagerScreen.routeName: (context) =>
            const OverviewManagerScreen(),
        OverviewTenantScreen.routeName: (context) =>
            const OverviewTenantScreen(),
        ReportsScreen.routeName: (context) => ReportsScreen(''),
        EditReportScreen.routeName: (context) => EditReportScreen(),
        ManagingFaultScreen.routeName: (context) => ManagingFaultScreen(''),
      },
    );
  }
}
