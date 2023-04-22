import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'report.dart';

class Reports {
  List<Report> _reportList = [];

  Reports();

  List<Report> get getReportList {
    return _reportList;
  }

  Future<String> _uploadImageToFirestore(String imagePath) async {
    // Get the image file from the image path
    File imageFile = File(imagePath);

    // Create a unique file name for the image in Firebase Storage
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Reference to Firebase Storage
    Reference storageRef = FirebaseStorage.instance.ref('/userUploads');

    UploadTask uploadTask;

    // Upload the image file to Firebase Storage
    uploadTask = storageRef.putData(await imageFile.readAsBytes());

    // Get the download URL of the uploaded image
    Future<String> imageUrl = (await uploadTask).ref.getDownloadURL();

    return imageUrl;
  }

  Future<void> addReportToReview(Report report, String buildID) async {
    try {
      await _uploadImageToFirestore(report.imageUrl).then((imageAsString) {
        FirebaseFirestore.instance
            .collection('Buildings')
            .doc(buildID)
            .collection('Reports')
            .add({
          'id': 'documentRef.id',
          'title': report.title,
          'description': report.description,
          'location': report.location,
          'imageURL': imageAsString,
          'status': 'WAITING',
          'createdBy': FirebaseAuth.instance.currentUser!.uid,
        }).then(
          (value) {
            FirebaseFirestore.instance
                .collection('Buildings')
                .doc(buildID)
                .collection('Reports')
                .doc(value.id)
                .set({
              'id': value.id,
              'title': report.title,
              'description': report.description,
              'location': report.location,
              'imageURL': imageAsString,
              'status': 'WAITING',
              'createdBy': FirebaseAuth.instance.currentUser!.uid,
            });
          },
        );
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  void addReportToReports(Report report, String buildingID) {
    FirebaseFirestore.instance
        .collection('Buildings')
        .doc(buildingID)
        .collection('Reports')
        .add({
      'id': 'documentRef.id',
      'title': report.title,
      'description': report.description,
      'location': report.location,
      'imageURL': report.imageUrl,
      'createdBy': report.createBy,
      'status': 'INPROGRESS'
    }).then(
      (value) {
        FirebaseFirestore.instance
            .collection('Buildings')
            .doc(buildingID)
            .collection('Reports')
            .doc(value.id)
            .set({
          'id': value.id,
          'title': report.title,
          'description': report.description,
          'location': report.location,
          'imageURL': report.imageUrl,
          'createdBy': report.createBy,
          'status': 'INPROGRESS'
        });
      },
    );
  }

  void removeReportFromReportList(String reportId) {
    for (Report report in _reportList) {
      if (report.id == reportId) {
        _reportList.remove(report);
      }
    }
  }
}
