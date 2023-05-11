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

  List<Survey> get getSurveysList {
    return _surveyList;
  }

  Future<void> addSurvey(Survey survey, String buildID) async {
    try {
      await FirebaseFirestore.instance
          .collection('Buildings')
          .doc(buildID)
          .collection('Surveys')
          .add({
        'id': 'documentRef.id',
        'title': survey.title,
        'description': survey.description,
        'options' : survey.options,
        'results' : survey.results,
        'whoVoted' :  survey.whoVoted,
      }).then(
            (value) {
          FirebaseFirestore.instance
              .collection('Buildings')
              .doc(buildID)
              .collection('Reports')
              .doc(value.id)
              .set({
            'id': value.id,
            'title': survey.title,
            'description': survey.description,
            'options' : survey.options,
            'results' : survey.results,
            'whoVoted' :  survey.whoVoted,
            'timestamp': DateTime.now()
          });
        },
      );
  } on PlatformException catch (e) {
  customToast.showCustomToast(
  e.message.toString(), Colors.white, Colors.red);
  }
    }
  void addSurveyToSurveys(Survey survey, String buildingID) {
    FirebaseFirestore.instance
        .collection('Buildings')
        .doc(buildingID)
        .collection('Surveys')
        .doc(survey.id);
  }

  void removeSurveyFromSurveyList(String surveyId) {
    for (Survey survey in _surveyList) {
      if (survey.id == surveyId) {
        _surveyList.remove(survey);
      }
    }
  }
}