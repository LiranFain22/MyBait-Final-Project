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
      body: ListView.builder(
        itemCount: reportList.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(reportList[index].imageUrl!),
              ),
              title: Text(reportList[index].title!),
              subtitle: Text(reportList[index].description!),
              trailing: IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  // todo: implement report_review_screen
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
