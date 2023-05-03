import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mybait/screens/MANAGER/review_report_screen.dart';
import 'package:provider/provider.dart';

import '../../models/reports.dart';
import '../../models/report.dart';
import '../../widgets/app_drawer.dart';

enum SelectedOptions {
  approve,
  delete,
}

class ManagingReportScreen extends StatefulWidget {
  static const routeName = '/managing-fault';

  ManagingReportScreen({super.key});

  @override
  State<ManagingReportScreen> createState() => _ManagingReportScreenState();
}

class _ManagingReportScreenState extends State<ManagingReportScreen> {
  List<Report> reportList = Reports().getReportList;

  Future<String> fetchBuildingID() async {
    var userDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var data = userDocument.data();
    var buildingID = data!['buildingID'] as String;
    return buildingID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Managing Fault'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: fetchBuildingID(),
        builder: (context, snapshot) {
          String? buildingID = snapshot.data;
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Buildings')
                .doc(buildingID)
                .collection('Reports')
                // .where('status', isEqualTo: 'WAITING')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var documents = snapshot.data!.docs;
              return ListView.builder(
                itemCount: documents.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(documents[index]['imageURL']),
                      ),
                      title: Text(documents[index]['title']),
                      // subtitle: Text(documents[index]['description']),
                      subtitle: showDateAsText(documents[index]['timestamp']),
                      trailing: IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: () async {
                          String documentId = documents[index].id;
                          if (documentId.isNotEmpty) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ReviewReportScreen(buildingID!, documentId)));
                          } else {
                            print('no document');
                            const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
  
  Widget showDateAsText(document) {
    var timestamp = document as Timestamp;
    DateTime date = timestamp.toDate();
    String formatted = DateFormat.yMd().add_jm().format(date);
    return Text(
      formatted
    );
  }
}
