import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mybait/screens/edit_report_screen.dart';
import 'package:mybait/screens/login_screen.dart';
import 'package:mybait/screens/managing_fault_screen.dart';
import 'package:mybait/screens/overview_manager_screen.dart';
import 'package:mybait/screens/overview_tenant_screen.dart';
import 'package:mybait/screens/reports_screen.dart';
import 'package:mybait/screens/splash_screen.dart';
import 'package:mybait/widgets/app_drawer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    String userType = '';
    return MaterialApp(
      title: 'MyBait',
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (userSnapshot.hasData) {
            if (userSnapshot.data!.email!.contains('manager')) {
              userType = 'MANAGER';
              return OverviewManagerScreen(userSnapshot.data!.uid);
            }
            if (userSnapshot.data!.email!.contains('tenant')) {
              userType = 'TENANT';
              return OverviewTenantScreen(userSnapshot.data!.uid);
            }
          }
          return LoginScreen();
        },
      ),
      routes: {
        // '/':(context) => const LoginScreen(),
        OverviewManagerScreen.routeName: (context) => OverviewManagerScreen(userType),
        OverviewTenantScreen.routeName:(context) => OverviewTenantScreen(userType),
        EditReportScreen.routeName:(context) => EditReportScreen(userType),
        ManagingFaultScreen.routeName: (context) => ManagingFaultScreen(userType),
        ReportsScreen.routeName:(context) => ReportsScreen(userType),
        SplashScreen.routeName:(context) => SplashScreen(),
        LoginScreen.routeName:(context) => const LoginScreen(),
        AppDrawer.routeName:(context) => AppDrawer(userType),
      },
    );
  }
}
