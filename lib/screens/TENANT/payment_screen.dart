import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybait/Services/firebase_helper.dart';

import '../../widgets/app_drawer.dart';
import '../../widgets/custom_popupMenuButton.dart';
import 'home_committee_payment_screen.dart';
import 'maintenance_payment_screen.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment';

  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        actions: const [
          CustomPopupMenuButton(),
        ],
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<int>(
              stream: GetNumOfHomeCommittee(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  int numOfHomeCommittee = snapshot.data ?? 0;

                  if (numOfHomeCommittee > 0) {
                    return Badge(
                      label: Text("$numOfHomeCommittee",
                          style: TextStyle(fontSize: 22)),
                      largeSize: 25,
                      child: SizedBox(
                        height: 150,
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context,
                                  HomeCommitteePaymentScreen.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Home Committee Payments',
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: 150,
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, HomeCommitteePaymentScreen.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Home Committee Payments',
                            style: TextStyle(fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }
                }
                return Text("Error");
              },
            ),
            StreamBuilder(
              stream: GetNumOfMaintenance(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  int numOfHomeCommittee = snapshot.data ?? 0;

                  if (numOfHomeCommittee > 0) {
                    return Badge(
                      label: Text("$numOfHomeCommittee",
                          style: TextStyle(fontSize: 22)),
                      largeSize: 25,
                      child: SizedBox(
                        height: 150,
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, MaintenancePaymentScreen.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Maintenance Payments',
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: 150,
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, MaintenancePaymentScreen.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Maintenance Payments',
                            style: TextStyle(fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }
                }
                return Text("Error");
              },
            )
          ],
        ),
      ),
    );
  }

  Stream<int> GetNumOfHomeCommittee() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String currentYear = DateTime.now().year.toString();
    return FirebaseHelper.getHouseCommitteePaymentsToPay(userId, currentYear);
  }

  Stream<int> GetNumOfMaintenance() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String currentYear = DateTime.now().year.toString();
    return FirebaseHelper.getMaintenancePaymentsToPay(userId, currentYear);
  }
}
