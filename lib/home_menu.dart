import 'package:finalproject/home.dart';
import 'package:flutter/material.dart';

import 'Profile/profile.dart';
import 'choise_time.dart';

class Home_menu extends StatelessWidget {
  const Home_menu({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          // backgroundColor: Colors.blue.shade500,
          backgroundColor: Colors.white,
          body: TabBarView(children: [
            HomePage(),
            choise_menu(),
            profile_set(),
          ]),
          bottomNavigationBar: TabBar(
            // indicatorWeight: 40,
            // indicator: BoxDecoration(
            //   borderRadius: BorderRadius.circular(40),
            // ),5
            // splashBorderRadius:BorderRadius.circular(40),
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
                // text: "หน้าหลัก",
              ),
              Tab(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.add_outlined,
                        color: Colors.blue.shade500,
                        size: 36.0,
                      )
                      // ,Text("แสกน",style: TextStyle(color: Colors.black,fontSize: 14,fontFamily: 'Kodchasan'))
                    ],
                  ),
                ),
              ),
              Tab(
                icon: Icon(Icons.person,
                    //Icons.face_outlined,

                    color: Colors.blue.shade500,
                    size: 24.0,
                    semanticLabel: 'โปรไฟล์'),
              )
            ],
          ),
        ));
  }
}
