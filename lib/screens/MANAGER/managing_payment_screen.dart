import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mybait/Services/firebase_helper.dart';
import 'package:mybait/screens/MANAGER/edit_payment_screen.dart';
import 'package:mybait/widgets/app_drawer.dart';
import 'package:mybait/widgets/custom_toast.dart';

import '../../widgets/custom_popupMenuButton.dart';

enum ListType {
  houseCommitteePaymentsFiltter,
  maintenancePaymentsFilter,
}

class ManagingPaymentScreen extends StatefulWidget {
  static const routeName = '/managing-payment';

  const ManagingPaymentScreen({super.key});

  @override
  State<ManagingPaymentScreen> createState() => _ManagingPaymentScreenState();
}

class _ManagingPaymentScreenState extends State<ManagingPaymentScreen> {
  ListType _selectedOption = ListType.maintenancePaymentsFilter;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Managing Payment',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_on_sharp),
            onPressed: () => sendNotificationToAllUsers(
                'There are payments waiting 🔔'),
          ),
          const CustomPopupMenuButton(),
        ],
      ),
      drawer: const AppDrawer(),
      body: getListByFillter(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(EditPaymentScreen.routeName);
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Which Paymet Type?'),
          content: const Text('Select paymet type to show'),
          actions: [
            CupertinoButton(
              child: const Text('House committee payments'),
              onPressed: () {
                setState(() {
                  selectedOption(ListType.houseCommitteePaymentsFiltter);
                  Navigator.pop(context);
                });
              },
            ),
            CupertinoButton(
              child: const Text('Maintenance Payments'),
              onPressed: () {
                selectedOption(ListType.maintenancePaymentsFilter);
                Navigator.pop(context);
              },
            ),
            CupertinoButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void selectedOption(ListType listType) {
    setState(() {
      _selectedOption = listType;
    });
  }

  Widget getListByFillter() {
    if (_selectedOption.name == 'houseCommitteePaymentsFiltter') {
      return getHouseCommitteePaymentsList();
    } else if (_selectedOption.name == 'maintenancePaymentsFilter') {
      return getMaintenancePaymentsList();
    }
    return getMaintenancePaymentsList();
  }

  Widget getHouseCommitteePaymentsList() {
    return FutureBuilder(
      future: fetchBuildingID(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          debugPrint('*** Something went wrong with ManaginPaymentScreen ***');
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        String? buildingID = snapshot.data;
        var now = DateTime.now();
        var currentYear = now.year;
        var currentMonth = now.month;
        return StreamBuilder(
          stream: fetchNotPaidMonthList(buildingID, currentYear, currentMonth)
              .asStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              debugPrint(
                  '*** Something went wrong with ManaginPaymentScreen ***');
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var notPaidList = snapshot.data;
            if (notPaidList!.isEmpty) {
              return const Center(
                child: Text(
                  'No payments, have a good day 🙏🏻',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            return ListView.builder(
              itemCount: notPaidList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> userMap = notPaidList[index];
                return GestureDetector(
                  onTap: () => _showDialog(
                    context,
                    userMap[userMap.keys.first]['title'],
                    userMap[userMap.keys.first]['amount'],
                    notPaidList[index].keys.first,
                    // userMap[userMap.keys.first]['timestamp'],
                  ),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(notPaidList[index].keys.first),
                      // title: Text('?'),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.notifications_none_outlined,
                          color: Colors.red,
                        ),
                        onPressed: () => _showDialog(
                            context,
                            userMap[userMap.keys.first]['title'],
                            userMap[userMap.keys.first]['amount'],
                            notPaidList[index].keys.first),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget getMaintenancePaymentsList() {
    return FutureBuilder(
      future: fetchBuildingID(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          debugPrint('*** Something went wrong with ManaginPaymentScreen ***');
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        String? buildingID = snapshot.data;
        var now = DateTime.now();
        var currentYear = now.year;
        return StreamBuilder(
          stream: fetchNotPaidList(buildingID, currentYear).asStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              debugPrint(
                  '*** Something went wrong with ManaginPaymentScreen ***');
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No Payments 😇',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
            var notPaidList = snapshot.data;
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> userMap = notPaidList![index];
                return GestureDetector(
                  onTap: () => _showDialog(
                    context,
                    userMap[userMap.keys.first]['title'],
                    userMap[userMap.keys.first]['amount'],
                    notPaidList[index].keys.first,
                  ),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(notPaidList[index].keys.first),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.notifications_none_outlined,
                          color: Colors.red,
                        ),
                        onPressed: () => _showDialog(
                          context,
                          userMap[userMap.keys.first]['title'],
                          userMap[userMap.keys.first]['amount'],
                          notPaidList[index].keys.first,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchNotPaidMonthList(
    buildingID,
    currentYear,
    currentMonth,
  ) async {
    List<Map<String, dynamic>> notPaidList = [];

    QuerySnapshot usersDocByBuildingID = await FirebaseFirestore.instance
        .collection('users')
        .where('buildingID', isEqualTo: buildingID)
        .get();

    for (var userDoc in usersDocByBuildingID.docs) {
      // Get a reference to the payments-collection
      CollectionReference paymentsCollection = FirebaseFirestore.instance
          .collection(
              'users/${userDoc.id}/payments/$currentYear/House committee payments');

      // Get the documents in the payments
      QuerySnapshot paymentsCollectionSnapshot = await paymentsCollection
          // .where('monthNumber', isLessThanOrEqualTo: currentMonth)
          .where('isPaid', isEqualTo: false)
          .get();

      // Iterate through the payments in the payments-collection
      for (var paymentDoc in paymentsCollectionSnapshot.docs) {
        // Cast the result of the data() method to Map<String, dynamic>
        Map<String, dynamic> paymentDocData =
            paymentDoc.data() as Map<String, dynamic>;

        var username = userDoc.get('userName') as String;
        Map<String, dynamic> notPaidUser = {username: paymentDocData};
        if (paymentDocData['monthNumber'] <= currentMonth) {
          // Append the payment data to the list
          notPaidList.add(notPaidUser);
        }
      }
    }
    return notPaidList;
  }

  Future<String> fetchBuildingID() async {
    var userDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var data = userDocument.data();
    var buildingID = data!['buildingID'] as String;
    return buildingID;
  }

  Future<List<Map<String, dynamic>>> fetchNotPaidList(
      buildingID, currentYear) async {
    List<Map<String, dynamic>> notPaidList = [];

    QuerySnapshot usersDocByBuildingID = await FirebaseFirestore.instance
        .collection('users')
        .where('buildingID', isEqualTo: buildingID)
        .get();

    for (var userDoc in usersDocByBuildingID.docs) {
      // Get a reference to the payments-collection
      CollectionReference paymentsCollection = FirebaseFirestore.instance
          .collection(
              'users/${userDoc.id}/payments/$currentYear/Maintenance Payments');

      // Get the documents in the payments
      QuerySnapshot paymentsCollectionSnapshot =
          await paymentsCollection.where('isPaid', isEqualTo: false).get();

      // Iterate through the payments in the payments-collection
      for (var paymentDoc in paymentsCollectionSnapshot.docs) {
        // Cast the result of the data() method to Map<String, dynamic>
        Map<String, dynamic> paymentDocData =
            paymentDoc.data() as Map<String, dynamic>;

        var username = userDoc.get('userName') as String;
        Map<String, dynamic> notPaidUser = {username: paymentDocData};
        // Append the payment data to the list
        notPaidList.add(notPaidUser);
      }
    }
    return notPaidList;
  }

  _showDialog(BuildContext context, String title, int amount, String userName) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Cost Price: '),
                  Text(
                    '$amount\$',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            CupertinoButton(
              onPressed: () => sendNotificationToUser(
                  'REMINDER 🔔\n$title', userName),
              child: const Text('Remind'),
            ),
            CupertinoButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  String getTimeAndDateFromFirebase(Timestamp userTimestamp) {
    // Assuming `doc` is a Firestore document containing a `Timestamp` field named `timestamp`
    Timestamp timestamp = userTimestamp;

// Convert the `Timestamp` to a `DateTime` object
    DateTime dateTime = timestamp.toDate();

// Format the `DateTime` as a human-readable date and time string
    return DateFormat.yMd().add_jm().format(dateTime);
  }

  sendNotificationToUser(String message, String username) async {
    CustomToast customToast = CustomToast();
    var userData = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: username)
        .get();
    // final String? userToken = userData.data()!['token'];
    final String? userToken = userData.docs.first.data()['token'];
    if (userToken == null) return;
    FirebaseHelper.sendNotification(
      title: 'MyBait 🏠',
      body: message,
      token: userToken,
    );
    Navigator.pop(context);
    customToast.showCustomToast(
        'Reminder sended to $username 🔔', Colors.white, Colors.grey[800]!);
  }

  sendNotificationToAllUsers(String message) async {
    String buildingID = await FirebaseHelper.fetchBuildingID();
    DateTime now = DateTime.now();
    var currentYear = now.year;
    var currentMonth = now.month;
    CustomToast customToast = CustomToast();

    Set<String> usersSet = <String>{};

    print(_selectedOption.name);

    switch (_selectedOption.name) {
      case 'houseCommitteePaymentsFiltter':
        // Get List of users base filter
        List<Map<String, dynamic>> userList =
            await fetchNotPaidMonthList(buildingID, currentYear, currentMonth);
        for (Map<String, dynamic> user in userList) {
          Set<String> keys = user.keys.toSet();

          // add all unique users to the usersSet
          for (String key in keys) {
            if (!usersSet.contains(key)) {
              usersSet.add(key);
            }
          }
        }
        break;
      case 'maintenancePaymentsFilter':
        // Get List of users base filter
        List<Map<String, dynamic>> userList =
            await fetchNotPaidList(buildingID, currentYear);
        for (Map<String, dynamic> user in userList) {
          Set<String> keys = user.keys.toSet();

          // add all unique users to the usersSet
          for (String key in keys) {
            if (!usersSet.contains(key)) {
              usersSet.add(key);
            }
          }
        }
        break;
    }

    // List of users to send notifications
    List<String> usersList = usersSet.toList();
    List<String> usersToken = [];

    print(usersList.toString());

    for (String user in usersList) {
      try {
        var userToken = await FirebaseHelper.fetchToken(user);
        usersToken.add(userToken);
      } on Exception catch (e) {
        debugPrint('HAHAHAHAH');
        debugPrint(e.toString());
      }
    }
    
    // send each user notification
    await FirebaseHelper.sendGroupNotifications(
      title: 'MyBait 🏠',
      body: message,
      tokens: usersToken,
    );
    
    customToast.showCustomToast('Sent Reminder to All Users 🔔', Colors.white, Colors.grey[800]!);
  }
}
