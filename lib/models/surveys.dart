import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mybait/models/survey.dart';

import '../widgets/custom_toast.dart';

class Surveys {
  List<Survey> _surveyList = [];

  var customToast = CustomToast();

  Surveys();

  List<Survey> get getSurveyList {
    return _surveyList;
  }

  Future<void> addReportToReview(Survey survey, String buildID) async {
    try {
      await (value) {
        FirebaseFirestore.instance
            .collection('Buildings')
            .doc(buildID)
            .collection('Surveys')
            .doc(value.id)
            .set({
          'id': value.id,
          'title': survey.title,
          'description': survey.description,
          'options': survey.options,
          //'results': survey.results,
          //'whoVoted': survey.whoVoted,
          'timestamp': DateTime.now()
        });
      };
    } on PlatformException catch (e) {
      customToast.showCustomToast(
          e.message.toString(), Colors.white, Colors.red);
    }
  }
}


 /* void removeSurveyFromSurveyList(String surveyId) {
    for (Survey survey in _surveyList) {
      if (survey.id == surveyId) {
        _surveyList.remove(survey);
      }
    }
  }*/

