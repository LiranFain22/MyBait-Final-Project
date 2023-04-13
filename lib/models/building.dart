import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Building {
  final String buildingID;
  final int buildingNumber;
  final String city;
  final String country;
  final String joinID;
  final String manager;
  final String street;
  final List<String> tenants;
  final Map<dynamic, String> reports;
  final Map<dynamic, String> payments;

  Building({
    required this.buildingID,
    required this.buildingNumber,
    required this.city,
    required this.country,
    required this.joinID,
    required this.manager,
    required this.street,
    required this.tenants,
    required this.reports,
    required this.payments,
  });

  Future<String> fetchBuildingID() async {
      var userDocument = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      var data = userDocument.data();
      var buildingID = data!['buildingID'] as String;
      return buildingID;
    }
}