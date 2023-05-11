import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybait/Services/firebase_helper.dart';
import 'package:mybait/models/report.dart';

import 'package:mybait/models/reports.dart';
import 'package:mybait/widgets/custom_Button.dart';

import '../../widgets/custom_toast.dart';

class ReviewReportScreen extends StatelessWidget {
  static const routeName = '/reviewReport';
  String buildingID;
  String reportID;
  ReviewReportScreen(this.buildingID, this.reportID, {super.key});

  var customToast = CustomToast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Review'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: FirebaseHelper.fetchReportDoc(buildingID, reportID),
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
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(
                      snapshot.data!['imageURL'],
                      height: 300,
                      width: 300,
                    ),
                    Text(
                      snapshot.data!['title'],
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    const Text(
                      'Description: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '${snapshot.data!['description']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 20,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Text(
                          'Created By: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '${snapshot.data!['createdBy']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Date: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          getTimeAndDate(snapshot.data!['timestamp']),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Status: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '${snapshot.data!['status']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    FutureBuilder(
                      future: showButtonsBaseReportStatus(snapshot, context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return snapshot.data!;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<void> addReportToReportsList(
      AsyncSnapshot<DocumentSnapshot<Object?>> snapshot,
      BuildContext context) async {
    Report report = Report(
      id: snapshot.data!['id'],
      title: snapshot.data!['title'],
      description: snapshot.data!['description'],
      location: snapshot.data!['location'],
      imageUrl: snapshot.data!['imageURL'],
      createdBy: snapshot.data!['createdBy'],
      timestamp: snapshot.data!['timestamp'],
    );
    var userDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var data = userDocument.data();
    var buildingID = data!['buildingID'] as String;
    Reports.changeReportStatusToINPROGRESS(report, buildingID);
    customToast.showCustomToast(
        'Report: ${snapshot.data!['title']} is in progress! 💪🏻',
        Colors.white,
        Colors.green);
    Navigator.pop(context);
  }

  Future<void> addReportToCompleteList(
      AsyncSnapshot<DocumentSnapshot<Object?>> snapshot,
      BuildContext context) async {
    Report report = Report(
      id: snapshot.data!['id'],
      title: snapshot.data!['title'],
      description: snapshot.data!['description'],
      location: snapshot.data!['location'],
      imageUrl: snapshot.data!['imageURL'],
      createdBy: snapshot.data!['createdBy'],
      timestamp: snapshot.data!['timestamp'],
    );
    var userDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var data = userDocument.data();
    var buildingID = data!['buildingID'] as String;
    Reports.changeReportStatusToCOMPLETE(report, buildingID);
    customToast.showCustomToast(
        'Report: ${snapshot.data!['title']} Completed! 💪🏻',
        Colors.white,
        Colors.green);
    Navigator.pop(context);
  }

  Future<void> deleteDocument(AsyncSnapshot<DocumentSnapshot<Object?>> snapshot,
      BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .runTransaction((Transaction myTransaction) async {
        myTransaction.delete(snapshot.data!.reference);
      });
      customToast.showCustomToast('The report has been removed from review..',
          Colors.white, Colors.grey[800]!);
      Navigator.of(context).pop();
    } on Exception catch (error) {
      print(error.toString());
    }
  }

  String getTimeAndDate(timestamp) {
    // Convert the timestamp to a DateTime object and format it
    DateTime dateTime = timestamp.toDate().toLocal();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }

  Future<Widget> showButtonsBaseReportStatus(
      AsyncSnapshot<DocumentSnapshot<Object?>> snapshot,
      BuildContext context) async {
    var reportDoc = await FirebaseHelper.fetchReportDoc(buildingID, reportID);
    String status = reportDoc.get('status');
    if (status == 'WAITING') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          customButton(
              title: 'Approve',
              icon: Icons.done_outline_outlined,
              onClick: () => addReportToReportsList(snapshot, context)),
          customButton(
              title: 'Cancel',
              icon: Icons.cancel_outlined,
              onClick: () => deleteDocument(snapshot, context)),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          customButton(
              title: 'Done',
              icon: Icons.task_outlined,
              onClick: () => addReportToCompleteList(snapshot, context)),
        ],
      );
    }
  }
}
