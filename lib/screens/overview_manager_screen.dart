import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class MenuItem {
  final IconData icon;
  final String title;

  MenuItem(this.icon, this.title);
}

class OverviewManagerScreen extends StatefulWidget {
  static const routeName = '/menu-manager';

  const OverviewManagerScreen({super.key});

  @override
  State<OverviewManagerScreen> createState() => _OverviewManagerScreenState();
}

class _OverviewManagerScreenState extends State<OverviewManagerScreen> {
  final String userType = 'MANAGE';
  List menuList = [
    MenuItem(Icons.error_outline, 'Managing Fault'),
    MenuItem(Icons.monetization_on_outlined, 'Cash Register'),
    MenuItem(Icons.account_circle_outlined, 'Information'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager - Main'),
      ),
      drawer: AppDrawer('MANAGER'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: menuList.length,
          itemBuilder: (context, position) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () {},
                child: Center(
                  child: Column(
                    children: [
                      Center(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0)),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              menuList[position].icon,
                              size: 70,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            menuList[position].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
