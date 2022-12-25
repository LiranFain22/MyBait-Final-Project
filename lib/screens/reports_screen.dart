import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybait/providers/reports.dart';
import 'package:provider/provider.dart';

import '../screens/edit_report_screen.dart';

import '../models/report.dart';

import '../widgets/app_drawer.dart';

class ReportsScreen extends StatefulWidget {
  static const routeName = '/reports';

  final String userType;

  ReportsScreen(this.userType, {super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      drawer: AppDrawer(widget.userType),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reports').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = snapshot.data!.docs;
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
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(EditReportScreen.routeName);
        },
      ),
    );
  }
}
