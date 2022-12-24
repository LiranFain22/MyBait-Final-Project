import 'package:flutter/material.dart';

import '../models/report.dart';

class EditReportScreen extends StatefulWidget {
  static const routeName = '/edit-report';

  const EditReportScreen({super.key});

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  final _descriptionFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedReport = Report(
    id: null,
    title: '',
    description: '',
    location: '',
    imageUrl: '',
  );
  var _initValue = {
    'title': '',
    'description': '',
    'location': '',
    'imageUrl': '',
  };
  var _isInit = true;

  @override
  void dispose() {
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
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _initValue['title'],
                  decoration: InputDecoration(labelText: 'Title'),
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
                  initialValue: _initValue['description'],
                  decoration: InputDecoration(labelText: 'Description'),
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
                  initialValue: _initValue['location'],
                  decoration: InputDecoration(labelText: 'Location'),
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
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter an Image URL.';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg')) {
                            return 'Please enter a valid image URL.';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                Container(
                  height: 50,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      // Implement submit button report to Manager
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
