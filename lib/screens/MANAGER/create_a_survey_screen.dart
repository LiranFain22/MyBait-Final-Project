import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybait/models/survey.dart';
import 'package:mybait/models/surveys.dart';
import 'package:mybait/widgets/custom_Button.dart';
import 'package:flutter/services.dart';
import 'package:mybait/widgets/custom_toast.dart';
import '../../widgets/custom_popupMenuButton.dart';
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

  User user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  // final _titleFocusNode = FocusNode();
  // final _descriptionFocusNode = FocusNode();
  // final _optionsFocusNode = FocusNode();
  var _createSurvey = Survey(
    id: null,
    title: '',
    description: '',
    createdTime: DateTime.now(),
    result: {
      'Yes': [],
      'No': [],
    },
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
                      createdTime: _createSurvey.createdTime,
                      result: _createSurvey.result,
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
                      createdTime: _createSurvey.createdTime,
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
