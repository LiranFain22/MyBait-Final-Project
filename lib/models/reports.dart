import 'package:cloud_firestore/cloud_firestore.dart';

import 'report.dart';

class Reports {
  List<Report> _reportList = [];

  Reports();

  List<Report> get getReportList {
    return _reportList;
  }

  void addReportToReview(Report report, String buildID) {
    FirebaseFirestore.instance
        .collection('Buildings')
        .doc(buildID)
        .collection('Reports')
        .add({
      'id': 'documentRef.id',
      'title': report.title,
      'description': report.description,
      'location': report.location,
      'imageURL': report.imageUrl,
      'status': 'WAITING',
      'createdBy': report.createBy,
    }).then(
      (value) {
        FirebaseFirestore.instance
            .collection('Buildings')
            .doc(buildID)
            .collection('Reports')
            .doc(value.id)
            .set({
          'id': value.id,
          'title': report.title,
          'description': report.description,
          'location': report.location,
          'imageURL': report.imageUrl,
          'status': 'WAITING',
          'createdBy': report.createBy,
        });
      },
    );
  }

  void addReportToReports(Report report, String buildingID) {
    FirebaseFirestore.instance
    .collection('Buildings')
    .doc(buildingID)
    .collection('Reports')
    .add({
      'id': 'documentRef.id',
      'title': report.title,
      'description': report.description,
      'location': report.location,
      'imageURL': report.imageUrl,
      'createdBy': report.createBy,
      'status': 'INPROGRESS'
    }).then(
      (value) {
        FirebaseFirestore.instance
        .collection('Buildings')
        .doc(buildingID)
        .collection('Reports')
        .doc(value.id)
        .set({
          'id': value.id,
          'title': report.title,
          'description': report.description,
          'location': report.location,
          'imageURL': report.imageUrl,
          'createdBy': report.createBy,
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
