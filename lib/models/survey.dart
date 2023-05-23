import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Survey with ChangeNotifier{
  final String? id;
  final String? title;
  final String? description;
  final List<String>? options;
  final List<String>? results;
  final List<String>? whoVoted;
  final DateTime timestamp; // TODO: change to DateTime
  final DateTime dueDate; // TODO: change to DateTime

  Survey({
    @required this.id,
    @required this.title,
    @required this.description,
    required this.options,
    required this.results,
    required this.whoVoted,
    required this.timestamp, // TODO: change to DateTime
    required this.dueDate, // TODO: change to DateTime
  });
}
