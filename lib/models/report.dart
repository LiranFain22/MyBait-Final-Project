import 'package:flutter/material.dart';

class Report with ChangeNotifier{
  final String? id;
  final String? title;
  final String? description;
  final String? location;
  String imageUrl;
  final String? createBy;

  Report({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.location,
    required this.imageUrl,
    @required this.createBy,
  });

  
  void setImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }
}
