import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybait/Services/firebase_helper.dart';
import 'package:mybait/screens/MANAGER/create_a_survey_screen.dart';
import 'package:mybait/screens/survey_result_screen.dart';
import '../widgets/custom_popupMenuButton.dart';
import '../widgets/app_drawer.dart';
import 'review_survey_screen.dart';

class SurveysScreen extends StatefulWidget {
  static const routeName = '/surveys';

  SurveysScreen({super.key});

  @override
  State<SurveysScreen> createState() => _SurveysScreenState();
}

class _SurveysScreenState extends State<SurveysScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surveys'),
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
                .collection('Surveys')
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
                      'No surveys, have a good day 🙏🏻',
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
                        String documentId = documents[index].id;
                        if (documentId.isNotEmpty) {
                          checkUserVote(context, buildingID, documentId);
                        } else {
                          print('no document');
                          const CircularProgressIndicator();
                        }
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(documents[index]['title']),
                          subtitle: Text(documents[index]['description']),
                        ),
                      ),
                    );
                  },
                );
              }
              return const Text('OHH NO!');
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButtonBaseUserType(),
    );
  }

  Widget FloatingActionButtonBaseUserType() {
    return FutureBuilder(
      future: FirebaseHelper.fetchUserType(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return SizedBox.shrink();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        }
        String userType = snapshot.data!;
        if (userType == 'MANAGER') {
          return FloatingActionButton(
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(CreateSurveyScreen.routeName);
            },
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Future<void> checkUserVote(
      BuildContext context, String? buildingID, String surveyID) async {
    final collectionRef = FirebaseFirestore.instance
        .collection('Buildings')
        .doc(buildingID)
        .collection('Surveys');
    final surveydocRef = collectionRef.doc(surveyID);
    final surveydocSnapshot = await surveydocRef.get();
    final currentMap =
        surveydocSnapshot.data()!['result'] as Map<String, dynamic>;

    for (var entry in currentMap.entries) {
      List<dynamic> values = entry.value;
      for (String value in values) {
        if (value == FirebaseAuth.instance.currentUser!.uid) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SurveyResultScreen(buildingID!, surveyID)));
          return;
        }
      }
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ReviewSurveyScreen(buildingID!, surveyID)));
  }
}
