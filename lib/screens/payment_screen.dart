import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class PaymentScreen extends StatelessWidget {
  static const routeName = '/payment';

  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      drawer: AppDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('payments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            var documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // todo: implement onTap
                  },
                  child: documents[index]['status'] == 'NOTPAY'
                      ? Card(
                          child: ListTile(
                            leading: CircleAvatar(
                                child: documents[index]['paymentType'] ==
                                        'month'
                                    ? const Icon(Icons.calendar_month)
                                    : const Icon(Icons.construction_outlined)),
                            title: Row(
                              children: [
                                Text(documents[index]['title']),
                                const Spacer(),
                                Text(documents[index]['amount'].toString() + '\$'),
                              ],
                            ),
                            // trailing: Text(documents[index]['amount']),
                          ),
                        )
                      : const Center(
                          child: Text('No payments, have a good day 🙏🏻'),
                        ),
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

