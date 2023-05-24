import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Survey with ChangeNotifier{
  final String? id;
  final String? title;
  final String? description;
  final Map<String, List<String>> result;
  final DateTime createdTime;

  Survey({
    @required this.id,
    @required this.title,
    @required this.description,
    required this.result,
    required this.createdTime,
  });
}