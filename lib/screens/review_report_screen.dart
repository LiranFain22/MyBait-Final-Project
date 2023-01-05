import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybait/models/report.dart';

class ReviewReportScreen extends StatelessWidget {
  static const routeName = '/reviewReport';
  String documentId;
  ReviewReportScreen(this.documentId, {super.key});

  Future<DocumentSnapshot> getDocument(String documentId) async {
    return FirebaseFirestore.instance
        .collection('review')
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
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Cancel'),
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance.runTransaction(
                                (Transaction myTransaction) async {
                              myTransaction.delete(snapshot.data!.reference);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'The report has been removed from review..')));
                            Navigator.of(context).pop();
                          } on Exception catch (error) {
                            print(error.toString());
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
