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
  TextEditingController _textController = TextEditingController();
  List<String> _array = [];
  var customToast = CustomToast();
  final _formKey = GlobalKey<FormState>();
  final _amountFocusNode = FocusNode();
  var _createSurvey = Survey(
    title: '',
    description: '',
    timestamp: Timestamp.now(),
    options: [],
    //results: [],
   // whoVoted: [],
  );

  @override
  void initState() {
    super.initState();
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
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_amountFocusNode);
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
                      options: _createSurvey.options,
                      //results: _createSurvey.results,
                      //whoVoted: _createSurvey.whoVoted,
                      timestamp: _createSurvey.timestamp,
                    );
                  },
                ),

                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_amountFocusNode);
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
                      options: _createSurvey.options,
                      //results: _createSurvey.results,
                      //whoVoted: _createSurvey.whoVoted,
                      timestamp: _createSurvey.timestamp,
                    );
                  },
                ),

                TextField(
                  controller: _textController,
                  decoration: InputDecoration(hintText: "Enter comma-separated values"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _array = _textController.text.split(",");
                    });
                  },
                  child: Text("Submit"),
                ),
                Text("Array: $_array"),
                //TODO: implement save array

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
                        surveys.addReportToReview(_createSurvey, buildingID);
                        customToast.showCustomToast('Your survey was created!.', Colors.white, Colors.grey[800]!);
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
