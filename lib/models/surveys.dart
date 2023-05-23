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
          'options': survey.options,
          'results': survey.results,
          'whoVoted': survey.whoVoted,
          'timestamp': survey.timestamp,
          'dueDate': survey.dueDate,
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
              'options': survey.options,
              'results': survey.results,
              'whoVoted': survey.whoVoted,
              'timestamp': survey.timestamp,
              'dueDate': survey.dueDate,
            });
          },
        );
    } on PlatformException catch (e) {
      customToast.showCustomToast(
          e.message.toString(), Colors.white, Colors.red);
    }
  }

  void addVoteToSurvey(String surveyID, String userID, String optionVoted) {
    //get surveyID and userID add userID to votes of this survey, under the option the user voted
  }

  void calcResult(String surveyID) {
    //show votes percentage
    // How many tenants voted in total, out of how many tenants there are in the building
  }

  bool checkIfVoted(String surveyID, String userID) {
    //check if user alredy voted, if true - show survey result and show you voted option ___ messege
    //if user didnt voted yet, let him vote
    return false;
  }

  bool timeToVote(String surveyID) {
    //check if due date to survey has passed if not
    //return true(let user vote)
    //else return false(don't let user vote)
    return false;
  }
}

