import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybait/models/report.dart';

import 'package:mybait/models/reports.dart';

class ReviewReportScreen extends StatelessWidget {
  static const routeName = '/reviewReport';
  String documentId;
  ReviewReportScreen(this.documentId, {super.key});

  Future<DocumentSnapshot> getDocument(String documentId) async {
    return FirebaseFirestore.instance
        .collection('reports')
        .doc(documentId)
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
          future: getDocument(documentId),
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
                  Image.network(snapshot.data!['imageUrl']),
                  Text(
                    snapshot.data!['title'],
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${snapshot.data!['description']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          child: const Text('Approve'),
                          onPressed: () {
                            // todo: implement approve action
                            // 1. Create a copy of the source document in the target collection, i.e. read it from the source collection,
                            //    get the document fields and create a new document in the target collection with these fields,
                            //    and then;
                            Reports reports = Reports();
                            Report report = Report(
                              id: snapshot.data!['id'],
                              title: snapshot.data!['title'],
                              description: snapshot.data!['description'],
                              location: snapshot.data!['location'],
                              imageUrl: snapshot.data!['imageUrl'],
                              createBy: snapshot.data!['createBy'],
                            );
                            reports.addReportToReports(report);
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The report has been removed from review..')));
      Navigator.of(context).pop();
    } on Exception catch (error) {
      print(error.toString());
    }
  }
}
