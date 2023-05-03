import 'package:flutter/material.dart';

class Payment {
  final String? id;
  final String? title;
  final String? paymentType; 
  final int? amount;
  final String? createdBy;
  final DateTime dateTime;

  Payment({
    @required this.id,
    @required this.title,
    @required this.paymentType,
    @required this.amount,
    @required this.createdBy, 
    required this.dateTime,
  });
}