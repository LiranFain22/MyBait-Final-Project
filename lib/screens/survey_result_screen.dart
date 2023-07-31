import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybait/Services/firebase_helper.dart';

class SurveyResultScreen extends StatefulWidget {
  String buildingID;
  String surveyID;
  SurveyResultScreen(this.buildingID, this.surveyID, {super.key});

  @override
  State<SurveyResultScreen> createState() => _SurveyResultScreenState();
}

class _SurveyResultScreenState extends State<SurveyResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Review'),
      ),
      body: FutureBuilder(
        future:
            FirebaseHelper.fetchSurveyDoc(widget.buildingID, widget.surveyID),
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
          Map<String, dynamic> surveyResult = surveyDoc!.get('result');
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  snapshot.data!['title'],
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                Text(
                  snapshot.data!['description'],
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
                const Divider(),
                Container(
                  height: 150,
                  child: Column(
                    children:
                        List<Widget>.generate(surveyResult.length, (index) {
                      String keyName = surveyResult.keys.toList()[index];
                      List<dynamic> valueOfKeyName = surveyResult[keyName];
                      int numOfVotes = valueOfKeyName.length;
                      return Card(
                        child: ListTile(
                          title: Text(
                            keyName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: getPercentageOfVoted(keyName, numOfVotes),
                        ),
                      );
                    }),
                  ),
                ),
                getWhoVoted(surveyResult),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getPercentageOfVoted(keyName, numOfVotes) {
    return FutureBuilder(
      future: FirebaseHelper.getTenantsNumber(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Text('Error');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading');
        }
        int tenantsNumber = snapshot.data!;
        double percentageNumber = (numOfVotes / tenantsNumber) * 100;
        return Text(
          '${percentageNumber.floor()} %',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> getSurveyResult() async {
    Map<String, dynamic> surveyResult = await fetchSurveyResult();
    return surveyResult;
  }

  Future<Map<String, dynamic>> fetchSurveyResult() async {
    final collectionRef = FirebaseFirestore.instance
        .collection('Buildings')
        .doc(widget.buildingID)
        .collection('Surveys');
    final documentRef = collectionRef.doc(widget.surveyID);
    final documentSnapshot = await documentRef.get();
    final currentMap =
        documentSnapshot.data()!['result'] as Map<String, dynamic>;
    return currentMap;
  }

  // Widget getWhoVoted(Map<String, dynamic> surveyResult) {
  Widget getWhoVoted(Map<String, dynamic> surveyResult) {
    String? winningKey; // Variable to hold the key of the winning vote list
    bool isTie = false;
    return FutureBuilder(
      future: FirebaseHelper.getTenantsNumber(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Text('Error');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading');
        }
        int tenantsNumber = snapshot.data!;
        int totalVotes = 0;

        // Count the votes
        int maxVotes = 0;
        surveyResult.forEach((key, value) {
          List<dynamic> voteList = value;
          totalVotes += voteList.length;
          int totalVotesCurrentKey = voteList.length;

          if (totalVotesCurrentKey > maxVotes) {
            maxVotes = totalVotesCurrentKey;
            winningKey = key;
            isTie = false; // Reset tie flag
          } else if (totalVotesCurrentKey == maxVotes) {
            // A tie has occurred
            isTie = true;
          }
        });

        if (totalVotes < tenantsNumber) {
          return Text(
            '$totalVotes of $tenantsNumber tenants voted ⏳',
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          );
        } else {
          if (!isTie) {
            return Column(
              children: [
                Text(
                  'All tenants voted ✅',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '\nWinning Vote:',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '$winningKey',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          } else {
            return Text(
              'Tie!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            );
          }
        }
      },
    );
  }
}
