import 'dart:convert';

import 'package:finalproject/history_payment.dart';
import 'package:finalproject/history_produc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_provider.dart';
import '../contact.dart';
import '../damaged.dart';
import '../editprofile.dart';
import '../main.dart';

class profile_set extends StatefulWidget {
  const profile_set({super.key});

  @override
  State<profile_set> createState() => _profile_setState();
}

class _profile_setState extends State<profile_set> {
  late SharedPreferences prefs;
  String? emailname;
  Map objcustomer = {};
  ApiProvider apiProvider = ApiProvider();
  @override
  void initState() {
    super.initState();
    getUsers();
  }

  getUsers() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      emailname = prefs.getString('username');
    });
    datausername();
  }

  logout() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  datausername() async {
    try {
      var rs = await apiProvider.data_customer(
          emailname!.toString());
      if (rs.statusCode == 200) {
        var jsonResponse = json.decode(rs.body);
        if (jsonResponse['ok'] == true) {
          setState(() {
            objcustomer['fname'] = jsonResponse['data'][0]['fname'].toString();
            objcustomer['lname'] = jsonResponse['data'][0]['lname'].toString();
          });
        }
      } else {
        print("error state != 200");
      }
    } catch (err) {
      print(err);
    }
  }

  Widget myDivider() {
    return Divider(
      height: 7.0,
      color: Colors.grey.shade800,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("โปรไฟล์"),
      // ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 65, 10, 0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(blurRadius: 8, color: Colors.grey.shade700),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfile()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.grey.shade200,
                      // ความสูงของเงา
                      elevation: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          height: 50,
                          child: Image.asset('images/profile_start.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            '${objcustomer['fname']} ${objcustomer['lname']}',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Kodchasan',
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryProduct()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.grey.shade200,
                      // ความสูงของเงา
                      elevation: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("ประวัติการใช้ตู้ล้างรถ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Kodchasan',
                            ))
                      ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryPayment()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.grey.shade200,
                      // ความสูงของเงา
                      elevation: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("ประวัติการเติมเงิน",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Kodchasan',
                            ))
                      ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),


              child: Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DamagedPage()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.grey.shade200,
                      // ความสูงของเงา
                      elevation: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("แจ้งปัญหาเครื่องเสีย",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Kodchasan',
                            ))
                      ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ContactPage()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.grey.shade200,
                      // ความสูงของเงา
                      elevation: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("หน้าช่วยเหลือ / ติดต่อเรา",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Kodchasan',
                            ))
                      ]),
                ),
              ),
            ),
            myDivider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    logout();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.grey.shade100,
                      // ความสูงของเงา
                      elevation: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("ออกจากระบบ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Kodchasan',
                            ))
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
