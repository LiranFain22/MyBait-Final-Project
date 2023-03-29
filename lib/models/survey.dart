import 'package:flutter/material.dart';

class Survey with ChangeNotifier{
  final String? name;
  final List<String>? options;
  final List<String>? results;
  final List<String>? whoVoted;

  Survey({
    @required this.name,
    @required this.options,
    @required this.results,
    @required this.whoVoted,
  });
}
