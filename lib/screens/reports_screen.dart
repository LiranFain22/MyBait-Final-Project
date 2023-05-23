import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybait/Services/firebase_helper.dart';
import 'package:mybait/widgets/custom_Button.dart';

import '../widgets/custom_popupMenuButton.dart';
import 'edit_report_screen.dart';
import '../widgets/app_drawer.dart';

class ReportsScreen extends StatefulWidget {
  static const routeName = '/reports';

  ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  User? userCredential = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    super.dispose();
  }

  void _showDialog(
    String title,
    String imageUrl,
    String status,
    String createdBy,
    Timestamp lastUpdate,
    String description,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 30,
                width: 40,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'x',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title),
                ],
              ),
            ],
          ),
          content: Column(
            children: [
              Image.network(
                imageUrl,
                cacheHeight: 200,
                cacheWidth: 200,
                loadingBuilder: (context, child, loadingProgress) {
                  return loadingProgress == null
                      ? child
                      : const LinearProgressIndicator();
                },
              ),
              Divider(),
              const Text(
                'Created By: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                createdBy,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Divider(),
              const Text(
                'Last Update: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                getTimeAndDate(lastUpdate),
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Divider(),
              const Text(
                'Status: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Divider(),
              const Text(
                'Description: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: const [
          CustomPopupMenuButton(),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: FirebaseHelper.fetchBuildingID(),
        builder: (context, snapshot) {
          String? buildingID = snapshot.data;
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Buildings')
                .doc(buildingID)
                .collection('Reports')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                var documents = snapshot.data!.docs;
                if (documents.isEmpty) {
                  return const Center(
                    child: Text(
                      'No reports, have a good day 🙏🏻',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: documents.length,
                  padding: const EdgeInsets.all(5),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _showDialog(
                          documents[index]['title'],
                          documents[index]['imageURL'],
                          documents[index]['status'],
                          documents[index]['createdBy'],
                          documents[index]['lastUpdate'],
                          documents[index]['description'],
                        );
                      },
                      child: cardReportBaseStatus(documents, index),
                    );
                  },
                );
              }
              return const Text('OHH NO!');
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

  Widget cardReportBaseStatus(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents, int index) {
    switch (documents[index]['status']) {
      case 'INPROGRESS':
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(documents[index]['imageURL']),
            ),
            title: Text(documents[index]['title']),
            trailing: const Text(
              'In Progress',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        );
      case 'WAITING':
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(documents[index]['imageURL']),
            ),
            title: Text(documents[index]['title']),
            subtitle: Text(documents[index]['createdBy']),
            trailing: const Text(
              'Waiting',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        );
    }
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(documents[index]['imageURL']),
        ),
        title: Text(documents[index]['title']),
        subtitle: Text(documents[index]['createdBy']),
        trailing: const Text(
          'Done',
          style: TextStyle(color: Colors.green),
        ),
      ),
    );
  }

  String getTimeAndDate(timestamp) {
    // Convert the timestamp to a DateTime object and format it
    DateTime dateTime = timestamp.toDate().toLocal();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }
}
