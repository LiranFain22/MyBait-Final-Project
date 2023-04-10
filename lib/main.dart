import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mybait/screens/create_building_screen.dart';
import 'package:mybait/screens/edit_report_screen.dart';
import 'package:mybait/screens/join_building_screen.dart';
import 'package:mybait/screens/login_screen.dart';
import 'package:mybait/screens/managing_fault_screen.dart';
import 'package:mybait/screens/overview_manager_screen.dart';
import 'package:mybait/screens/overview_tenant_screen.dart';
import 'package:mybait/screens/payment_history_screen.dart';
import 'package:mybait/screens/payment_screen.dart';
import 'package:mybait/screens/register_screen.dart';
import 'package:mybait/screens/reports_screen.dart';
import 'package:mybait/screens/splash_screen.dart';
import 'package:mybait/screens/welcome_screen.dart';
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
    return MaterialApp(
      title: 'MyBait',
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (userSnapshot.hasData) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(userSnapshot.data!.uid)
                .get()
                .then((value) {
              if (value.data()!['userType'] == 'MANAGER') {
                return OverviewManagerScreen();
              }
              if (value.data()!['userType'] == 'TENANT') {
                return OverviewTenantScreen();
              }
            });
          }
          return const LoginScreen();
        },
      ),
      routes: {
        OverviewManagerScreen.routeName: (context) => OverviewManagerScreen(),
        OverviewTenantScreen.routeName: (context) => OverviewTenantScreen(),
        EditReportScreen.routeName: (context) => EditReportScreen(),
        ManagingFaultScreen.routeName: (context) => ManagingFaultScreen(),
        ReportsScreen.routeName: (context) => ReportsScreen(),
        SplashScreen.routeName: (context) => SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        AppDrawer.routeName: (context) => AppDrawer(),
        PaymentScreen.routeName: (context) => PaymentScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        PaymentHistoryScreen.routeName: (context) => PaymentHistoryScreen(),
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        CreateBuildingScreen.routeName: (context) => CreateBuildingScreen(),
        JoinBuildingScreen.routeName: (context) => const JoinBuildingScreen(),
      },
    );
  }
}
