import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/survey.dart';
import '../models/surveys.dart';
import '../widgets/custom_popupMenuButton.dart';
import '../widgets/custom_toast.dart';
import 'edit_report_screen.dart';
import '../widgets/app_drawer.dart';

class SurveysScreen extends StatefulWidget {
  static const routeName = '/Surveys';

  SurveysScreen({super.key});

  @override
  State<SurveysScreen> createState() => _SurveysScreenState();
}
class _SurveysScreenState extends State<SurveysScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}


