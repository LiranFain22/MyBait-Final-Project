import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybait/screens/overview_tenant_screen.dart';
import 'package:mybait/screens/reports_screen.dart';

import '../models/reports.dart';
import '../models/report.dart';
import '../widgets/app_drawer.dart';

class EditReportScreen extends StatefulWidget {
  static const routeName = '/edit-report';

  EditReportScreen({super.key});

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  var _editedReport = Report(
    id: null,
    title: '',
    description: '',
    location: '',
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _descriptionFocusNode.dispose();
    _locationFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // This function update imageUrl preview even if the focus is NOT on image url
  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Report'),
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
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? const Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter an Image URL.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedReport = Report(
                            id: _editedReport.id,
                            title: _editedReport.title,
                            description: _editedReport.description,
                            location: _editedReport.location,
                            imageUrl: value,
                          );
                        },
                      ),
                    )
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!
                            .save(); // saves all onSaved in each textFormField
                        Reports reports = Reports();
                        var documentToCreate = FirebaseFirestore.instance.collection('review').doc();
                        reports.addReportToReview(_editedReport, documentToCreate);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Your report send to manager building for review.'),
                          ),
                        );
                        Navigator.of(context).pushReplacementNamed(ReportsScreen.routeName);
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
