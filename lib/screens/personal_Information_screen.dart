import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mybait/screens/MANAGER/managing_payment_screen.dart';
import 'package:share/share.dart';

import '../TENANT/payment_screen.dart';
import '../login_screen.dart';
import '../reports_screen.dart';
import 'managing_report_screen.dart';

import '../../widgets/app_drawer.dart';

class PersonalInformationScreen extends StatelessWidget {
  static const routeName = '/personalInformation';

  PersonalInformationScreen({super.key});

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

          ],
      ),
    );
  }
}