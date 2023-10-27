import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: TabBar(
        unselectedLabelStyle: TextStyle(
          fontSize: 10,
        ),
        tabs: [
          Tab(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.blue.shade500,
              size: 24.0,
              semanticLabel: 'หน้าหลัก',
            ),
          ),
          Tab(
            child: Container(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.add_outlined,
                    color: Colors.blue.shade500,
                    size: 36.0,
                  ),
                ],
              ),
            ),
          ),
          Tab(
            icon: Icon(
              Icons.person,
              color: Colors.blue.shade500,
              size: 24.0,
              semanticLabel: 'โปรไฟล์',
            ),
          )
        ],
      ),
    );
  }
}
