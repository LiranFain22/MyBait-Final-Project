import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybait/models/payment.dart';
import 'package:mybait/models/survey.dart';
import 'package:mybait/models/surveys.dart';
import 'package:mybait/widgets/custom_Button.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mybait/screens/reports_screen.dart';
import 'package:mybait/widgets/custom_Button.dart';
import 'package:mybait/widgets/custom_toast.dart';

import '../../widgets/custom_popupMenuButton.dart';
import '../../widgets/custom_toast.dart';
import '../surveys_screen.dart';

class createSurveyScreen extends StatefulWidget {
  static const routeName = '/create-survey';

  const createSurveyScreen({super.key});

  @override
  State<createSurveyScreen> createState() => _createSurveyScreenState();
}

class _createSurveyScreenState extends State<createSurveyScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _optionsController = TextEditingController();

  //TextEditingController _textController = TextEditingController();
  List<String> _array = [];
  final _amountFocusNode = FocusNode();

  /*
  DateTime currentDate = DateTime.now(); // Get the current date and time
  DateTime threeDaysLater = currentDate.add(Duration(days: 3)); // Add 3 days to the current date
  int timestamp = threeDaysLater.millisecondsSinceEpoch; // Convert the date to a Unix timestamp in millisecondsSinceEpoch
  */
  User user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  // final _titleFocusNode = FocusNode();
  // final _descriptionFocusNode = FocusNode();
  // final _optionsFocusNode = FocusNode();
  var _createSurvey = Survey(
    id: null,
    title: '',
    description: '',
    timestamp: DateTime.now(),
    result: {
      'Yes': [],
      'No': [],
    },
    dueDate: DateTime.now().add(Duration(days: 3)),
  );
  var customToast = CustomToast();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _optionsController.dispose();
    // _titleFocusNode.dispose();
    // _descriptionFocusNode.dispose();
    // _titleFocusNode.dispose();
    // _optionsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create survey'),
        actions: const [
          CustomPopupMenuButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Title
                TextFormField(
                  //controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter a Title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _createSurvey = Survey(
                      id: _createSurvey.id,
                      title: value,
                      description: _createSurvey.description,
                      result: _createSurvey.result,
                      timestamp: _createSurvey.timestamp,
                      dueDate: _createSurvey.dueDate,
                    );
                  },
                ),
                // Description
                TextFormField(
                  //controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  textInputAction: TextInputAction.next,
                  validator: (_descriptionController) {
                    if (_descriptionController!.isEmpty) {
                      return 'Please Enter a Description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _createSurvey = Survey(
                      id: _createSurvey.id,
                      title: _createSurvey.title,
                      description: value,
                      result: _createSurvey.result,
                      timestamp: _createSurvey.timestamp,
                      dueDate: _createSurvey.dueDate,
                    );
                  },
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: customButton(
                    title: 'Create',
                    icon: Icons.add_chart,
                    buttonColor: Colors.blue,
                    onClick: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!
                            .save(); // saves all onSaved in each textFormField
                        addSurveyToSurveys(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addSurveyToSurveys(BuildContext context) async {
    Surveys surveys = Surveys();
    var userDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var data = userDocument.data();
    var buildingID = data!['buildingID'] as String;
    surveys.addSurveysToBuilding(_createSurvey, buildingID);
    customToast.showCustomToast(
        'Your survey was created!.', Colors.white, Colors.grey[800]!);
    Navigator.of(context).pushReplacementNamed(SurveysScreen.routeName);
  }
}
