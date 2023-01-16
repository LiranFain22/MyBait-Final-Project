import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/edit_report_screen.dart';
import '../widgets/app_drawer.dart';

class ReportsScreen extends StatefulWidget {
  static const routeName = '/reports';

  ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
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
      ),
      drawer: AppDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('reports')
            .where('status', isEqualTo: 'INPROGRESS')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            var documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showDialog(documents[index]['title'],
                        documents[index]['imageUrl']);
                  },
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(documents[index]['imageUrl']),
                        ),
                      title: Text(documents[index]['title']),
                    ),
                  ),
                );
              },
            );
          }
          return const Text('OHH NO!');
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigator.of(context)
          //     .pushReplacementNamed(EditReportScreen.routeName);
          Navigator.of(context).pushNamed(EditReportScreen.routeName);
        },
      ),
    );
  }
}
