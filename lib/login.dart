import 'dart:convert';

import 'package:finalproject/qr_codetest.dart';
import 'package:finalproject/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'home_menu.dart';
import 'api_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _ctrlUsername = TextEditingController();
  TextEditingController _ctrlPassword = TextEditingController();
  late SharedPreferences prefs;
  late String? emailname;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  String txt = "";
  // ดึง api
  ApiProvider apiProvider = ApiProvider();

  doLogin() async {
    if (_formKey.currentState!.validate()) {
      print("error");
      try {
        print("error82");
        var rs =
            await apiProvider.doLogin(_ctrlUsername.text, _ctrlPassword.text);
        if (rs.statusCode == 200) {
          // แปลงเป็น json
          print("error88");
          print(json.decode(rs.body));
          var jsonResponse = await json.decode(rs.body);
          // print(jsonResponse['data'][0]['name']);
          if (jsonResponse['ok'] == true) {
            // pushReplacement ไม่ให้สามารถย้อนกลับมาได้
            // เก็บค่าข้อมุล
            // setStringname(jsonResponse['data'][0]['name']);
            print("error55");
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(
                'username', (jsonResponse['data'][0]['username'].toString()));
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home_menu()));
          } else {
            // ยังทำไม่ได้
            print('อีเมลหรือรหัสผ่านไม่ถูกต้อง');
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('อีเมลหรือรหัสผ่านไม่ถูกต้อง'),
                // content: const Text('AlertDialog description'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
          // if(jsonResponse.length)
        } else {
          print("Server Error");
        }
      } catch (error) {
        print("wwwewe");
        print(error);
      }
    }
  }

  getUser() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      emailname = prefs.getString('username');
    });
    if (emailname != null) {
      Future.delayed(Duration(seconds: 3), () {
        // เมื่อดีเลย์เสร็จสิ้น ให้เปลี่ยนไปหน้าอื่น
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Home_menu()));
      });
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => Home_menu()));
    } else {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();

    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("เข้าสู่ระบบ",
      //       style: TextStyle(fontSize: 18, fontFamily: 'Kodchasan')),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: _isLoading // ตรวจสอบว่าข้อมูลกำลังโหลดหรือไม่
                ? Center(child: CircularProgressIndicator())
                : Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // Text('Login', style: TextStyle(color: Colors.black, fontSize: 24)),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0),
                          child: Container(
                              width: double.infinity, //ประกาศเต็มจอ
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty && value.contains('@')) {
                                    return 'use the @ char.';
                                  }
                                },
                                controller: _ctrlUsername,
                                decoration: InputDecoration(
                                    fillColor: Colors.white70,
                                    filled: true,
                                    labelText: 'อีเมล',
                                    labelStyle: TextStyle(
                                        fontSize: 18, fontFamily: 'Kodchasan'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              )),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                          child: Container(
                              width: double.infinity, //ประกาศเต็มจอ
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Password';
                                  }
                                },
                                controller: _ctrlPassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                    fillColor: Colors.white70,
                                    filled: true,
                                    labelText: "รหัสผ่าน",
                                    labelStyle: TextStyle(
                                        fontSize: 18, fontFamily: 'Kodchasan'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              )),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
                          child: Container(
                              height: 45,
                              width: double.infinity, //ประกาศเต็มจอ
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.login),
                                label: Text("เข้าสู่ระบบ",
                                    style: TextStyle(
                                        fontSize: 18, fontFamily: 'Kodchasan')),
                                style: ElevatedButton.styleFrom(
                                    //   // ใส่สีเส้น
                                    //   // side: BorderSide(color: Colors.blue.shade500)
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor: Colors.blue.shade500,
                                    // ตกแต่งเงา
                                    shadowColor: Colors.black,
                                    //ความมัว
                                    elevation: 10),
                                onPressed: () {
                                  doLogin();
                                },
                              )),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
                          child: Container(
                              height: 45,
                              width: double.infinity, //ประกาศเต็มจอ
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.app_registration_outlined),
                                label: Text("สมัครสมาชิก",
                                    style: TextStyle(
                                        fontSize: 18, fontFamily: 'Kodchasan')),
                                style: ElevatedButton.styleFrom(
                                    //   // ใส่สีเส้น
                                    //   // side: BorderSide(color: Colors.blue.shade500)
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor: Colors.blue.shade500,
                                    // ตกแต่งเงา
                                    shadowColor: Colors.black,
                                    //ความมัว
                                    elevation: 10),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              // QRCodeScreen
                                              RegisterPage()));
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
