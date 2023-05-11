import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mybait/screens/reports_screen.dart';
import 'package:mybait/widgets/custom_Button.dart';
import 'package:mybait/widgets/custom_toast.dart';
import '../../models/survey.dart';
import '../../models/surveys.dart';
import '../../widgets/custom_popupMenuButton.dart';
import '../surveys_screen.dart';

class CreateSurveyScreen extends StatefulWidget {
  static const routeName = '/create-survey';

  const CreateSurveyScreen({super.key});

  @override
  State<CreateSurveyScreen> createState() => _CreateSurveyScreenState();
}

class _CreateSurveyScreenState extends State<CreateSurveyScreen> {
  User user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  final _descriptionFocusNode = FocusNode();
  late var _createSurvey = Survey(
    id: null,
    title: '',
    description: '',
    // options :'',
    timestamp: Timestamp.now(),
    options: [],
    results: [],
    whoVoted: [],
  );
  var customToast = CustomToast();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Report'),
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
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
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
                      timestamp: _createSurvey.timestamp,
                      options: [],
                      results: [],
                      whoVoted: [],
                    );
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  focusNode: _descriptionFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    //FocusScope.of(context).requestFocus(_locationFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter a Description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _createSurvey = Survey(
                      id: _createSurvey.id,
                      title: _createSurvey.title,
                      description: value,
                      timestamp: _createSurvey.timestamp,
                    );
                  },
                ),
                Container(
                  height: 50,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!
                            .save(); // saves all onSaved in each textFormField
                        Surveys surveys = Surveys();
                        var userDocument = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get();
                        var data = userDocument.data();
                        var buildingID = data!['buildingID'] as String;
                        var documentToCreate = FirebaseFirestore.instance
                            .collection('Buildings')
                            .doc(buildingID)
                            .collection('Surveys')
                            .doc();
                        surveys.addSurvey(_createSurvey, buildingID);
                        customToast.showCustomToast(
                            'Your survey was created and now your tenants can answer it!.',
                            Colors.white,
                            Colors.grey[800]!);
                        Navigator.of(context)
                            .pushReplacementNamed(SurveysScreen.routeName);
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
}
