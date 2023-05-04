import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Report with ChangeNotifier{
  final String? id;
  final String? title;
  final String? description;
  final String? location;
  String imageUrl;
  final String? createdBy;
  final Timestamp timestamp;

  Report({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.location,
    required this.imageUrl,
    @required this.createdBy,
    required this.timestamp,
  });

  
  void setImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }
}
