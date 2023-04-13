import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mybait/screens/TENANT/payment_history_screen.dart';

import '../../widgets/app_drawer.dart';

class PaymentScreen extends StatelessWidget {
  static const routeName = '/payment';

  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, PaymentHistoryScreen.routeName);
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      drawer: AppDrawer(),
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

  void _showDialog(BuildContext context, String title, String amount,
      QueryDocumentSnapshot<Map<String, dynamic>> docId) {
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Payment for $title was successfully made 🙏🏻')));
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('payments')
                          .doc(docId.id)
                          .update({
                        'isPaid': true,
                      });
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Payment for $title was successfully made 🙏🏻')));
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('payments')
                          .doc(docId.id)
                          .update({
                        'isPaid': true,
                      });
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

  Widget getDocsNum() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('payments')
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
                    ));
        }
        return const Text('No Data');
      },
    );
  }

  Widget getUserPayments() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('payments')
          .where('isPaid', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          var paymentDocuments = snapshot.data!.docs;
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
                            onPressed: (context) {
                              String paymentTitle =
                                  paymentDocuments[index]['title'];
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Payment for $paymentTitle was successfully made 🙏🏻')));
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('payments')
                                  .doc(paymentDocuments[index].id)
                                  .update({
                                'isPaid': true,
                              });
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

  bool isIos() {
    if (Platform.isAndroid) {
      return false;
    }
    return true;
  }
}
