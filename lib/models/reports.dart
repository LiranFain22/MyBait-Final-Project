import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../widgets/custom_toast.dart';
import 'report.dart';

class Reports {
  List<Report> _reportList = [];

  var customToast = CustomToast();

  Reports();

  List<Report> get getReportList {
    return _reportList;
  }

  Future<String> _uploadImageToFirestore(
      String imagePath, String? imageTitle) async {
    // Get the image file from the image path
    File imageFile = File(imagePath);

    // Reference to Firebase Storage
    Reference storageRef = FirebaseStorage.instance
        .ref('/userUploads')
        .child(DateTime.now().toString());

    UploadTask uploadTask;

    // Upload the image file to Firebase Storage
    uploadTask = storageRef.putData(await imageFile.readAsBytes());

    // Get the download URL of the uploaded image
    Future<String> imageUrl = (await uploadTask).ref.getDownloadURL();

    return imageUrl;
  }

  Future<void> addReportToReview(Report report, String buildID) async {
    try {
      await _uploadImageToFirestore(report.imageUrl, report.title)
          .then((imageAsString) {
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
          'createdBy': FirebaseAuth.instance.currentUser!.displayName,
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
              'createdBy': FirebaseAuth.instance.currentUser!.displayName,
              'timestamp': DateTime.now()
            });
          },
        );
      });
    } on PlatformException catch (e) {
      customToast.showCustomToast(
          e.message.toString(), Colors.white, Colors.red);
    }
  }

  static void updateReportDescription(
      Report report, String buildingID, String newDescription) {
    FirebaseFirestore.instance
        .collection('Buildings')
        .doc(buildingID)
        .collection('Reports')
        .doc(report.id)
        .update({'description': newDescription});
  }

  static Future<void> changeReportStatusToINPROGRESS(Report report, String buildingID) async {
    await FirebaseFirestore.instance
        .collection('Buildings')
        .doc(buildingID)
        .collection('Reports')
        .doc(report.id)
        .update({
      'status': 'INPROGRESS',
      'lastUpdate': Timestamp.now(),
    });
  }

  static Future<void> changeReportStatusToCOMPLETE(Report report, String buildingID) async {
    await FirebaseFirestore.instance
        .collection('Buildings')
        .doc(buildingID)
        .collection('Reports')
        .doc(report.id)
        .update({
      'status': 'COMPLETE',
      'lastUpdate': Timestamp.now(),
    });
  }

  void removeReportFromReportList(String reportId) {
    for (Report report in _reportList) {
      if (report.id == reportId) {
        _reportList.remove(report);
      }
    }
  }
}
