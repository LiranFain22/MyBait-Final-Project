import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reports.dart';
import '../models/report.dart';
import '../widgets/app_drawer.dart';

enum SelectedOptions {
  approve,
  delete,
}

class ManagingFaultScreen extends StatefulWidget {
  static const routeName = '/managing-fault';

  final String userType;

  ManagingFaultScreen(this.userType, {super.key});

  @override
  State<ManagingFaultScreen> createState() => _ManagingFaultScreenState();
}

class _ManagingFaultScreenState extends State<ManagingFaultScreen> {
  List<Report> reportList = Reports().getReportList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Managing Fault'),
      ),
      drawer: AppDrawer(widget.userType),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('review').snapshots(),
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
                    backgroundImage: NetworkImage(documents[index]['imageUrl']),
                  ),
                  title: Text(documents[index]['title']),
                  subtitle: Text(documents[index]['description']),
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      // todo: implement review_report_screen
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
