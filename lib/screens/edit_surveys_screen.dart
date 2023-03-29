import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybait/screens/overview_tenant_screen.dart';
import 'package:mybait/screens/reports_screen.dart';

import '../models/reports.dart';
import '../models/report.dart';
import '../widgets/app_drawer.dart';

class EditSurveysScreen extends StatefulWidget {
  static const routeName = '/edit-surveys';

  EditSurveysScreen({super.key});

  @override
  State<EditSurveysScreen> createState() => _EditSurveysScreenState();
}
class _EditSurveysScreenState extends State<EditSurveysScreenState> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  var _editedSurvey = Survey(
    id: null,
    title: '',
    description: '',
    location: '',
    imageUrl: '',
  );
