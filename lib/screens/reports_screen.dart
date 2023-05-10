import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void _showDialog(String title, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Image.network(
            imageUrl,
            cacheHeight: 200,
            cacheWidth: 200,
            loadingBuilder: (context, child, loadingProgress) {
              return loadingProgress == null
                  ? child
                  : const LinearProgressIndicator();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<String> fetchBuildingID() async {
      var userDocument = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential!.uid)
          .get();
      var data = userDocument.data();
      var buildingID = data!['buildingID'] as String;
      return buildingID;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: const [
          CustomPopupMenuButton(),
        ],
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
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _showDialog(documents[index]['title'],
                            documents[index]['imageURL']);
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
}
