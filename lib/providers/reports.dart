import '../models/report.dart';

class Reports {
  List<Report> _reportList = [];

  Reports();

  List<Report> get getReportList {
    return _reportList;
  }

  void addReportToReview(Report report) {
    _reportList.add(report);
  }

  void removeReportFromReportList(String reportId) {
    for(Report report in _reportList) {
      if (report.id == reportId) {
        _reportList.remove(report);
      }
    }
  }
}