import 'package:flutter/material.dart';
import 'package:mybait/Services/firebase_helper.dart';
import 'package:mybait/screens/TENANT/payment_screen.dart';
import 'package:mybait/screens/reports_screen.dart';
import 'package:mybait/screens/surveys_screen.dart';

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
        child: ListView(
              children: [
                GestureDetector(
                  onTap: () async {
                     Navigator.of(context).pushNamed(PaymentScreen.routeName);
                  },
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.paid, color: Colors.green),
                      title: Text("Payments"),
                      subtitle: Text("new payment"),
                      trailing: const Icon(
                          Icons.arrow_circle_right, color: Colors.lightBlueAccent),
                      ),
                    ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(SurveysScreen.routeName);
                  },
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.insert_chart, color: Colors.indigoAccent),
                      title: Text("Survey"),
                      subtitle: Text("new survey"),
                      trailing: const Icon(
                          Icons.arrow_circle_right, color: Colors.lightBlueAccent),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(ReportsScreen.routeName);
                  },
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.report, color: Colors.deepOrange),
                      title: Text("Report"),
                      // subtitle:  await getNumOfReports() > 0 ? Text("${getNumOfReports()} reports") : Text("No Reports"),
                      subtitle: FutureBuilder(
                        future: getNumOfReports(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          int count = snapshot.data!;
                          if (count > 0){
                            return Text("$count reports");
                          }
                          return Text("No Reports");
                        },
                      ),
                      trailing: const Icon(
                          Icons.arrow_circle_right, color: Colors.lightBlueAccent),
                    ),
                  ),
                ),
              ],
            )
            // Column(
            //     children: <Widget>[
            //       const Divider(),
            //       ListTile(
            //         leading: const Icon(Icons.paid, color: Colors.green),
            //         title: Text("payments"),
            //         subtitle: Text("price"),
            //         trailing: const Icon(
            //           Icons.arrow_circle_right, color: Colors.lightBlueAccent),
            //       ),
            //       const Divider(),
            //       ListTile(
            //         leading: const Icon(Icons.insert_chart, color: Colors.indigoAccent),
            //         title: Text("survey"),
            //         subtitle: Text("survey info"),
            //         trailing: const Icon(Icons.arrow_circle_right, color: Colors.lightBlueAccent),
            //       ),
            //       const Divider(),
            //       ListTile(
            //         leading: const Icon(Icons.report, color: Colors.deepOrange),
            //         title: Text("report"),
            //         subtitle: Text("report info"),
            //         trailing: const Icon(Icons.arrow_circle_right, color: Colors.lightBlueAccent),
            //       ),
            //     ]
            // ),
        ),
    );
  }

  Future<int> getNumOfReports() async {
    String buildingID = await FirebaseHelper.fetchBuildingID();
    int count =  await FirebaseHelper.getReportsInProgress(buildingID);
    return count;
  }
}