import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mybait/screens/login_screen.dart';

import '../firebase_options.dart';

class FirebaseHelper {
  const FirebaseHelper._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> setupFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> _onBackgroundMessage(RemoteMessage message) async {
    await setupFirebase();
    debugPrint('we have received a notification ${message.notification}');
  }

  static Future<bool> sendNotification({
    required String title,
    required String body,
    required String token,
    String? image,
  }) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendNotification');

    try {
      final response = await callable.call(<String, dynamic>{
        'title': title,
        'body': body,
        'token': token,
      });

      debugPrint('result is ${response.data ?? 'No data came back'}');

      if (response.data == null) return false;
      return true;
    } catch (e) {
      debugPrint('There was an error $e');
      return false;
    }
  }

  static Future<bool> sendGroupNotifications({
    required String title,
    required String body,
    required List<String> tokens,
    String? image,
  }) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendGroupNotify');

    try {
      final response = await callable.call(<String, dynamic>{
        'title': title,
        'body': body,
        'tokens': tokens,
      });

      debugPrint('result is ${response.data ?? 'No data came back'}');

      if (response.data == null) return false;
      return true;
    } catch (e) {
      debugPrint('There was an error $e');
      return false;
    }
  }

  // todo: implement navigation!
  static Stream<QuerySnapshot<Map<String, dynamic>>> get buildViews =>
      _db.collection('users').snapshots();

  static Widget get homeScreen {
    if (_auth.currentUser != null) {
      return const LoginScreen();
    }

    return const LoginScreen();
  }

  static Future<void> testHealth() async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('checkHealth');

    final response = await callable.call();

    if (response.data != null) {
      print(response.data);
    }
  }

  static updateToken() async {
    final String? currentToken = await FirebaseMessaging.instance.getToken();
    if (currentToken == null) return;
    final userData =
        await _db.collection('users').doc(_auth.currentUser!.uid).get();
    final String? userToken = userData.data()!['token'];

    // Check if need to update token for push notification
    if (currentToken != userToken || userToken == null) {
      debugPrint('User Token = $userToken');
      debugPrint('Current Token = $currentToken');
      try {
        await _db
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({'token': currentToken});
        debugPrint('User Token Updated!');
      } on Exception catch (e) {
        debugPrint('Failed to update user token');
        debugPrint(e.toString());
      }
    }
  }

  static Future<String> fetchBuildingID() async {
    var userDocument =
        await _db.collection('users').doc(_auth.currentUser!.uid).get();
    var data = userDocument.data();
    var buildingID = data!['buildingID'] as String;
    return buildingID;
  }

  static Future<String> fetchToken(String username) async {
    try {
      var userDoc = await _db
          .collection('users')
          .where('userName', isEqualTo: username)
          .get();
      String token = userDoc.docs.first.data()['token'];
      return token;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  static Future<DocumentSnapshot> fetchReportDoc(
      String buildingID, String reportID) async {
    return _db
        .collection('Buildings')
        .doc(buildingID)
        .collection('Reports')
        .doc(reportID)
        .get();
  }

  static Future<String> fetchUserType() async {
    var userDoc =
        await _db.collection('users').doc(_auth.currentUser!.uid).get();
    String userType = userDoc.data()!['userType'];
    return userType;
  }

  static Future<DocumentSnapshot> fetchSurveyDoc(String buildingID, String surveyID) {
    return _db
        .collection('Buildings')
        .doc(buildingID)
        .collection('Surveys')
        .doc(surveyID)
        .get();
  }

  static Future<void> updateUserPayments(String userID) async {
    var now = DateTime.now();
    var currentMonth = now.month;
    var currentYear = now.year;

    // Loop through the remaining months of the year, starting from the current month
    for (var i = currentMonth; i <= 12; i++) {
      var month = DateFormat('MMMM').format(DateTime(currentYear, i));

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('payments')
          .doc(currentYear.toString())
          .collection('House committee payments')
          .doc(month)
          .set({
        'title': 'Month Payment: $month',
        'paymentType': 'month',
        'amount': 30,
        'isPaid': false,
        'monthNumber': i,
      });
    }
  }

  static Future<int> getTenantsNumber() async{
    String buildingID = await fetchBuildingID();
    var buildingDoc = await _db.collection('Buildings').doc(buildingID).get();
    List<dynamic> tenantsList = buildingDoc.data()!['tenants'];
    return tenantsList.length;
  }
}
