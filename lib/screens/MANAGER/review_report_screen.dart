import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybait/models/report.dart';

import 'package:mybait/models/reports.dart';

import '../../widgets/custom_toast.dart';

class ReviewReportScreen extends StatelessWidget {
  static const routeName = '/reviewReport';
  var customToast = CustomToast();
  String buildingID;
  String reportID;
  ReviewReportScreen(this.buildingID, this.reportID, {super.key});

  Future<DocumentSnapshot> getDocument(String buildingID, String reportID) async {
    return FirebaseFirestore.instance
    .collection('Buildings')
    .doc(buildingID)
    .collection('Reports')
    .doc(reportID)
    .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Review'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: getDocument(buildingID, reportID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              return Center(
                child: Column(
                  children: const [
                    Text('No Data...'),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Image.network(snapshot.data!['imageURL']),
                  Text(
                    snapshot.data!['title'],
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Created By: ${snapshot.data!['createdBy']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${snapshot.data!['description']}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          child: const Text('Approve'),
                          onPressed: () async {
                            Reports reports = Reports();
                            Report report = Report(
                              id: snapshot.data!['id'],
                              title: snapshot.data!['title'],
                              description: snapshot.data!['description'],
                              location: snapshot.data!['location'],
                              imageUrl: snapshot.data!['imageURL'],
                              createdBy: snapshot.data!['createdBy'],
                              dateTime: snapshot.data!['timestamp'],
                            );
                            var userDocument = await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .get();
                            var data = userDocument.data();
                            var buildingID = data!['buildingID'] as String;
                            reports.addReportToReports(report, buildingID);
                            // 2. Delete the document from the source collection.
                            deleteDocument(snapshot, context);
                          }),
                      ElevatedButton(
                        child: const Text('Cancel'),
                        onPressed: () async {
                          await deleteDocument(snapshot, context);
                        },
                      ),
                    ],
                  ),
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<void> deleteDocument(AsyncSnapshot<DocumentSnapshot<Object?>> snapshot,
      BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .runTransaction((Transaction myTransaction) async {
        myTransaction.delete(snapshot.data!.reference);
      });
      customToast.showCustomToast('The report has been removed from review..', Colors.white, Colors.grey[800]!);
      Navigator.of(context).pop();
    } on Exception catch (error) {
      print(error.toString());
    }
  }
}
