import 'package:cloud_firestore/cloud_firestore.dart';

import 'report.dart';

class Reports {
  List<Report> _reportList = [];

  Reports();

  List<Report> get getReportList {
    return _reportList;
  }

  void addReportToReview(
      Report report, DocumentReference<Map<String, dynamic>> documentRef) {
    FirebaseFirestore.instance.collection('reports').add({
      'id': 'documentRef.id',
      'title': report.title,
      'description': report.description,
      'location': report.location,
      'imageUrl': report.imageUrl,
      'status': 'WAITING',
      'createBy': report.createBy,
    }).then(
      (value) {
        FirebaseFirestore.instance.collection('reports').doc(value.id).set({
          'id': value.id,
          'title': report.title,
          'description': report.description,
          'location': report.location,
          'imageUrl': report.imageUrl,
          'status': 'WAITING',
          'createBy': report.createBy,
        });
      },
    );
  }

  void addReportToReports(Report report) {
    FirebaseFirestore.instance.collection('reports').add({
      'id': 'documentRef.id',
      'title': report.title,
      'description': report.description,
      'location': report.location,
      'imageUrl': report.imageUrl,
      'createBy': report.createBy,
      'status': 'INPROGRESS'
    }).then(
      (value) {
        FirebaseFirestore.instance.collection('reports').doc(value.id).set({
          'id': value.id,
          'title': report.title,
          'description': report.description,
          'location': report.location,
          'imageUrl': report.imageUrl,
          'createBy': report.createBy,
          'status': 'INPROGRESS'
        });
      },
    );
  }

  void removeReportFromReportList(String reportId) {
    for (Report report in _reportList) {
      if (report.id == reportId) {
        _reportList.remove(report);
      }
    }
  }
}
