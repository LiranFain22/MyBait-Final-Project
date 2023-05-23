import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_toast.dart';
import 'survey.dart';

class Surveys {
  List<Survey> _surveyList = [];

  var customToast = CustomToast();

  Surveys();

  List<Survey> get getSurveyList {
    return _surveyList;
  }
 /* create()async{
    DocumentReference documentReference = await FirebaseFirestore.instance
        .collection('Buildings')
        .doc(buildID)
        .collection('Surveys')
        .add({ 'id': 'documentRef.id',
      'title': survey.title,
      'description': survey.description,
      'options': survey.options,
      'results': survey.results,
      'whoVoted': survey.whoVoted,
      'timestamp': survey.timestamp,
      'dueDate': survey.dueDate,
    }
        }*/

  Future<void> addSurveysToBuilding(Survey survey, String buildID) async {
    try {
      await FirebaseFirestore.instance
            .collection('Buildings')
            .doc(buildID)
            .collection('Surveys')
            .add({
          'id': 'documentRef.id',
          'title': survey.title,
          'description': survey.description,
          'result': survey.result,
          'createdTime': survey.createdTime,
        }).then(
          (value) {
            FirebaseFirestore.instance
                .collection('Buildings')
                .doc(buildID)
                .collection('Surveys')
                .doc(value.id)
                .set({
              'id': value.id,
              'title': survey.title,
              'description': survey.description,
              'result': survey.result,
              'createdTime': survey.createdTime,
            });
          },
        );
    } on PlatformException catch (e) {
      customToast.showCustomToast(
          e.message.toString(), Colors.white, Colors.red);
    }
  }
}

