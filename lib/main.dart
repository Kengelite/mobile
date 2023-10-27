import 'package:flutter/material.dart';

import 'package:finalproject/register.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      //   // ใส่สีเส้น
                      //   // side: BorderSide(color: Colors.blue.shade500)
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.blue.shade500,
                      // ตกแต่งเงา
                      shadowColor: Colors.black,
                      //ความมัว
                      elevation: 10),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  icon: Icon(Icons.login),
                  // "เข้าสู่ระบบ".toUpperCase() ให้ตัวใหญ่
                  label: Text("เข้าสู่ระบบ",style: TextStyle(fontSize: 18,fontFamily: 'Kodchasan')),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: Container(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          //   // ใส่สีเส้น
                          //   // side: BorderSide(color: Colors.blue.shade500)
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.blue.shade500,
                          // ตกแต่งเงา
                          shadowColor: Colors.black,
                          //ความมัว
                          elevation: 10),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      },
                      icon: Icon(Icons.app_registration_outlined),
                      // "เข้าสู่ระบบ".toUpperCase() ให้ตัวใหญ่
                      label: Text("สมัครสมาชิก",style: TextStyle(fontSize: 18,fontFamily: 'Kodchasan')))),
            )
          ]),
    );
  }
}
