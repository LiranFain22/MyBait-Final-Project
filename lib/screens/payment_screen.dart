import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../widgets/app_drawer.dart';

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
              // todo: make payment history page
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('payments')
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
                return paymentDocuments[index]['status'] == 'NOTPAY'
                    ? GestureDetector(
                      onTap: () {
                        // todo: implement item_payment_page
                      },
                      child: Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  // todo: check status to 'PAID'
                                },
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                                icon: Icons.monetization_on_outlined,
                                label: 'Pay',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  // todo: implement close slider
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.close,
                                label: 'Close',
                              ),
                            ],
                          ),
                          child: Card(
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
                    )
                    : const Center(
                        child: Text('No payments, have a good day 🙏🏻'),
                      );
              },
            );
          }
          return const Text('OHH NO!');
        },
      ),
    );
  }
}
