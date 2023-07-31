import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  static const routeName = '/summary';

  SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Column(
                children: <Widget>[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.paid, color: Colors.green),
                    title: Text("payments"),
                    subtitle: Text("price"),
                    trailing: const Icon(
                      Icons.arrow_circle_right, color: Colors.lightBlueAccent),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.insert_chart, color: Colors.indigoAccent),
                    title: Text("survey"),
                    subtitle: Text("survey info"),
                    trailing: const Icon(Icons.arrow_circle_right, color: Colors.lightBlueAccent),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.report, color: Colors.deepOrange),
                    title: Text("report"),
                    subtitle: Text("report info"),
                    trailing: const Icon(Icons.arrow_circle_right, color: Colors.lightBlueAccent),
                  ),
                ]
            ),
          ],
        ),
      ),
    );
  }
}