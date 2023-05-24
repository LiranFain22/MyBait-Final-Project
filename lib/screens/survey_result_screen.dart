import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybait/Services/firebase_helper.dart';

class SurveyResultScreen extends StatelessWidget {
  String buildingID;
  String surveyID;
  SurveyResultScreen(this.buildingID, this.surveyID, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Review'),
      ),
      body: FutureBuilder(
        future: FirebaseHelper.fetchSurveyDoc(buildingID, surveyID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Center(
                child: Text(
                    'No Internet Connection 😢\nPlease Try Again Later...'));
          }
          DocumentSnapshot<Object?>? surveyDoc = snapshot.data;
          var surveyResult = surveyDoc!.get('result');
          return Column(
            children: [
              Text(
                snapshot.data!['title'],
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                snapshot.data!['description'],
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
              const Divider(),
              Text('HERE WILL SEE RESULT'),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: surveyResult!.length,
                  itemBuilder: (context, index) {
                    String keyName = surveyResult.keys.toList()[index];
                    List<dynamic> valueOfKeyName = surveyResult[keyName];
                    int valueLength = valueOfKeyName.length;
                    return Card(
                      child: ListTile(
                        title: Text(keyName),
                        trailing: Text('$valueLength'),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getSurveyResult() async {
    Map<String, dynamic> surveyResult = await fetchSurveyResult();
    return surveyResult;
  }

  Future<Map<String, dynamic>> fetchSurveyResult() async {
    final collectionRef = FirebaseFirestore.instance
        .collection('Buildings')
        .doc(buildingID)
        .collection('Surveys');
    final documentRef = collectionRef.doc(surveyID);
    final documentSnapshot = await documentRef.get();
    final currentMap =
        documentSnapshot.data()!['result'] as Map<String, dynamic>;
    return currentMap;
  }
}
