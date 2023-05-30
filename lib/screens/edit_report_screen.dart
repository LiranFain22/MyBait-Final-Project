import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mybait/screens/MANAGER/managing_payment_screen.dart';
import 'package:mybait/screens/MANAGER/managing_report_screen.dart';
import 'package:mybait/screens/reports_screen.dart';
import 'package:mybait/widgets/custom_Button.dart';
import 'package:mybait/widgets/custom_toast.dart';

import '../models/reports.dart';
import '../models/report.dart';
import '../widgets/custom_popupMenuButton.dart';

class EditReportScreen extends StatefulWidget {
  static const routeName = '/edit-report';

  EditReportScreen({super.key});

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  File? _image;

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        // Set default image => 'No Image Available'
        _editedReport.setImageUrl(
            'https://upload.wikimedia.org/wikipedia/commons/'
            'thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png');
        return;
      }

      final imageTemporary = File(image.path);

      setState(() {
        _image = imageTemporary;
      });

      _editedReport.setImageUrl(_image!.path);
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  User user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  final _descriptionFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  var _editedReport = Report(
    id: null,
    title: '',
    description: '',
    location: '',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png',
    createdBy: FirebaseAuth.instance.currentUser!.displayName,
    timestamp: Timestamp.now(),
    lastUpdate: Timestamp.now(),
  );
  var customToast = CustomToast();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _locationFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageUrlController.dispose();
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
                    _editedReport = Report(
                      id: _editedReport.id,
                      title: value,
                      description: _editedReport.description,
                      location: _editedReport.location,
                      imageUrl: _editedReport.imageUrl,
                      timestamp: _editedReport.timestamp,
                      createdBy: _editedReport.createdBy,
                      lastUpdate: _editedReport.lastUpdate,
                    );
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  focusNode: _descriptionFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_locationFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter a Description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedReport = Report(
                      id: _editedReport.id,
                      title: _editedReport.title,
                      description: value,
                      location: _editedReport.location,
                      imageUrl: _editedReport.imageUrl,
                      timestamp: _editedReport.timestamp,
                      createdBy: _editedReport.createdBy,
                      lastUpdate: _editedReport.lastUpdate,
                    );
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Location'),
                  focusNode: _locationFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_imageFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter a Location';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedReport = Report(
                      id: _editedReport.id,
                      title: _editedReport.title,
                      description: _editedReport.description,
                      location: value,
                      imageUrl: _editedReport.imageUrl,
                      timestamp: _editedReport.timestamp,
                      createdBy: _editedReport.createdBy,
                      lastUpdate: _editedReport.lastUpdate,
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _image == null
                          ? Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/'
                              'thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png')
                          : FittedBox(
                              fit: BoxFit.contain,
                              child: Image.file(_image!),
                            ),
                    ),
                    Column(
                      children: [
                        customButton(
                          title: 'Pick From Gallery',
                          icon: Icons.image,
                          buttonColor: Colors.blue,
                          onClick: () => getImage(ImageSource.gallery),
                        ),
                        customButton(
                          title: 'Pick From Camera',
                          icon: Icons.camera_alt,
                          buttonColor: Colors.blue,
                          onClick: () => getImage(ImageSource.camera),
                        )
                      ],
                    ),
                  ],
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
                        Reports reports = Reports();
                        var userDocument = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get();
                        var data = userDocument.data();
                        var buildingID = data!['buildingID'] as String;
                        var documentToCreate = FirebaseFirestore.instance
                            .collection('Buildings')
                            .doc(buildingID)
                            .collection('Reports')
                            .doc();
                        try {
                          reports.addReportToReview(_editedReport, buildingID);
                        } on Exception catch (e) {
                          customToast.showCustomToast(e.toString(), Colors.white, Colors.red);
                        }
                        customToast.showCustomToast(
                            'Your report send to manager building for review.',
                            Colors.white,
                            Colors.grey[800]!);
                        var userType = data['userType'] as String;
                        if (userType == 'MANAGER') {
                          Navigator.of(context).pushReplacementNamed(
                              ManagingReportScreen.routeName);
                        } else {
                          Navigator.of(context)
                              .pushReplacementNamed(ReportsScreen.routeName);
                        }
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
