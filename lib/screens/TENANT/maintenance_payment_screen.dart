import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../widgets/custom_toast.dart';
import 'maintenance_payment_history_screen.dart';

class MaintenancePaymentScreen extends StatelessWidget {
  static const routeName = '/MaintenancePayment';

  const MaintenancePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Maintenance payments',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                  context, MaintenancePaymentHistoryScreen.routeName);
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: Column(
        children: [
          getDocsNum(),
          Expanded(
            child: getUserPayments(),
          ),
        ],
      ),
    );
  }

  Widget getDocsNum() {
    var now = DateTime.now();
    var currentYear = now.year;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('payments')
          .doc(currentYear.toString())
          .collection('Maintenance Payments')
          .where('isPaid', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: snapshot.data!.docs.isNotEmpty
                ? Text(
                    "You have ${snapshot.data!.docs.length} payments",
                    style: const TextStyle(fontSize: 20),
                  )
                : const Center(
                    child: Text(
                      'You Don\'t Have Payments 😇',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
          );
        }
        return const Text('No Data');
      },
    );
  }

  Widget getUserPayments() {
    var customToast = CustomToast();
    var now = DateTime.now();
    var currentYear = now.year;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('payments')
          .doc(currentYear.toString())
          .collection("Maintenance Payments")
          .where('isPaid', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          var paymentDocuments = snapshot.data!.docs;
          // Sort paymentDocuments by the "monthNumber" field in ascending order
          paymentDocuments
              .sort((a, b) => a['monthNumber'].compareTo(b['monthNumber']));
          return ListView.builder(
            itemCount: paymentDocuments.length,
            padding: const EdgeInsets.all(5),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  String paymentPrice =
                      '${paymentDocuments[index]['amount']}\$';
                  return _showDialog(context, paymentDocuments[index]['title'],
                      paymentPrice, paymentDocuments[index]);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Card(
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              String paymentTitle =
                                  paymentDocuments[index]['title'];
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('payments')
                                  .doc(currentYear.toString())
                                  .collection('Maintenance payments')
                                  .doc(paymentDocuments[index].id)
                                  .update({
                                'isPaid': true,
                              });
                              customToast.showCustomToast(
                                  'Payment for $paymentTitle was successfully made 🙏🏻',
                                  Colors.white,
                                  Colors.grey[800]!);
                            },
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            icon: Icons.monetization_on_outlined,
                            label: 'Pay',
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              // Closing slider - DO NOTHING
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.close,
                            label: 'Close',
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                            child: paymentDocuments[index]['paymentType'] ==
                                    'month'
                                ? const Icon(Icons.calendar_month)
                                : const Icon(Icons.construction_outlined)),
                        title: Row(
                          children: [
                            Text(paymentDocuments[index]['title']),
                            const Spacer(),
                            Text('${paymentDocuments[index]['amount']}\$'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const Center(
          child: Text('No payments, have a good day 🙏🏻'),
        );
      },
    );
  }

  void _showDialog(BuildContext context, String title, String amount,
      QueryDocumentSnapshot<Map<String, dynamic>> docId) {
    var customToast = CustomToast();
    var now = DateTime.now();
    var currentYear = now.year;
    showDialog(
      context: context,
      builder: (context) {
        return isIos()
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(amount),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("Pay Now"),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('payments')
                          .doc(currentYear.toString())
                          .collection('Maintenance Payments')
                          .doc(docId.id)
                          .update({
                        'isPaid': true,
                      });
                      customToast.showCustomToast(
                          'Payment for $title was successfully made 🙏🏻',
                          Colors.white,
                          Colors.grey[800]!);
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: Text(title),
                content: Text(amount),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("Pay Now"),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('payments')
                          .doc(currentYear.toString())
                          .collection('Maintenance Payments')
                          .doc(docId.id)
                          .update({
                        'isPaid': true,
                      });
                      customToast.showCustomToast(
                          'Payment for $title was successfully made 🙏🏻',
                          Colors.white,
                          Colors.grey[800]!);
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
      },
    );
  }

  bool isIos() {
    if (Platform.isAndroid) {
      return false;
    }
    return true;
  }
}
