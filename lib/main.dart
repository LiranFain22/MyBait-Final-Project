import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mybait/screens/login_screen.dart';
import 'package:mybait/screens/overview_manager_screen.dart';
import 'package:mybait/screens/overview_tenant_screen.dart';
import 'package:mybait/screens/splash_screen.dart';

// import 'package:mybait/providers/reports.dart';
// import 'package:provider/provider.dart';

// import './screens/overview_manager_screen.dart';
// import './screens/overview_tenant_screen.dart';
// import './screens/reports_screen.dart';
// import './screens/edit_report_screen.dart';
// import './screens/login_screen.dart';
// import './screens/managing_fault_screen.dart';

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
            if (userSnapshot.data!.email!.contains('manager')) {
              return OverviewManagerScreen(userSnapshot.data!.uid);
            }
            if (userSnapshot.data!.email!.contains('tenant')) {
              return OverviewTenantScreen(userSnapshot.data!.uid);
            }
          }
          return LoginScreen();
        },
      ),
    );
  }
}
