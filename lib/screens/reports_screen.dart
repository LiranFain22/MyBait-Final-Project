import 'package:flutter/material.dart';

import '../screens/edit_report_screen.dart';

import '../models/report.dart';

import '../widgets/app_drawer.dart';

class ReportsScreen extends StatelessWidget {
  static const routeName = '/reports';

  final String userType;

  ReportsScreen(this.userType, {super.key});

  final List<Report> reports = [
    Report(
        id: '1',
        title: 'Broken Door',
        description: 'Lobby door is broken',
        location: 'Lobby',
        imageUrl: 'https://images.unsplash.com/photo-1600876876038-161d838876c1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8YnJva2VuJTIwZG9vcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60'),
    Report(
        id: '2',
        title: 'Broken Pipe',
        description: 'Broken pipe in parking lot 12',
        location: 'Parking Lot',
        imageUrl: 'https://images.unsplash.com/photo-1562545714-62c15e7fdf9e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8cGlwZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60'),
    Report(
        id: '3',
        title: 'Burn Out Lamp',
        description: 'Burn Out Lamp in Floor 3',
        location: 'Floor 3',
        imageUrl: 'https://images.unsplash.com/photo-1552529232-9e6cb081de19?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8bGFtcHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      drawer: AppDrawer(userType),
      body: ListView.builder(
        itemCount: reports.length,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(reports[index].imageUrl!),
              ),
              title: Text(reports[index].title!),
            ),
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
