import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Survey with ChangeNotifier{
  final String? id;
  final String? title;
  final String? description;
  final Map<String, List<String>> result;
  final DateTime timestamp; // TODO: change to DateTime
  final DateTime dueDate; // TODO: change to DateTime

  Survey({
    @required this.id,
    @required this.title,
    @required this.description,
    required this.result,
    required this.timestamp, // TODO: change to DateTime
    required this.dueDate, // TODO: change to DateTime
  });
}