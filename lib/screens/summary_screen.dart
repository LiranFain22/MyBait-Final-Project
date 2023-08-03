import 'package:firebase_auth/firebase_auth.dart';
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
                subtitle: FutureBuilder(
                  future: FirebaseHelper.getPaymentsToPay(
                      FirebaseAuth.instance.currentUser!.uid,
                      DateTime.now().year.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    int count = snapshot.data!;
                    if (count > 0) {
                      return Text("$count Payments");
                    }
                    return Text("No Payments");
                  },
                ),
                trailing: const Icon(Icons.arrow_circle_right,
                    color: Colors.lightBlueAccent),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SurveysScreen.routeName);
            },
            child: Card(
              child: ListTile(
                leading:
                    const Icon(Icons.insert_chart, color: Colors.indigoAccent),
                title: Text("Survey"),
                subtitle: FutureBuilder(
                  future: getNumOfSurveys(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    int count = snapshot.data!;
                    if (count > 0) {
                      return Text("$count Surveys");
                    }
                    return Text("No Surveys");
                  },
                ),
                trailing: const Icon(Icons.arrow_circle_right,
                    color: Colors.lightBlueAccent),
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
                subtitle: FutureBuilder(
                  future: getNumOfReports(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    int count = snapshot.data!;
                    if (count > 0) {
                      return Text("$count reports");
                    }
                    return Text("No Reports");
                  },
                ),
                trailing: const Icon(Icons.arrow_circle_right,
                    color: Colors.lightBlueAccent),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Future<int> getNumOfReports() async {
    String buildingID = await FirebaseHelper.fetchBuildingID();
    int count = await FirebaseHelper.getReportsInProgress(buildingID);
    return count;
  }

  Future<int> getNumOfSurveys() async {
    String buildingID = await FirebaseHelper.fetchBuildingID();
    int count = await FirebaseHelper.getSurveysToAnswer(
        buildingID, FirebaseAuth.instance.currentUser!.uid);
    return count;
  }
}
