import 'dart:convert';

import 'package:finalproject/api_provider.dart';
import 'package:finalproject/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_menu.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _ctrlUsername = TextEditingController();
  TextEditingController _ctrlPassword = TextEditingController();
  TextEditingController _ctrlFPassword = TextEditingController();
  TextEditingController _ctrlfname = TextEditingController();
  TextEditingController _ctrllname = TextEditingController();
  TextEditingController _ctrltel = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  ApiProvider apiProvider = ApiProvider();

  doRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_ctrlPassword.text == _ctrlFPassword.text) {
          var rs = await apiProvider.doRegister(
              _ctrlfname.text,
              _ctrllname.text,
              _ctrlUsername.text,
              _ctrlFPassword.text,
              _ctrltel.text);
          if (rs.statusCode == 200) {
            print(json.decode(rs.body));
            var jsonRes = await json.decode(rs.body);
            if (jsonRes['ok'] == true) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('username', (jsonRes['data'][0]['username']));
              prefs.setInt('id', (jsonRes['data'][0]['id_cus']));
              Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home_menu()));
            } else {
              alertextbox();
            }
          } else {
            alertextbox();
          }
        } else {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('รหัสผ่านไม่ตรงกัน'),
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
      } catch (err) {
        print(err);
      }
    }
  }

  alertextbox() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('อีเมลถูกใช้งานไปแล้ว'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("สมัครสมาชิก"),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // Text("สมัครสมาชิก", style: TextStyle(fontSize: 30, color: Colors.black)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: 180, //ประกาศเต็มจอ
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกชื่อ';
                                }
                              },
                     
                              controller: _ctrlfname,
                              decoration: InputDecoration(
    
                                  // ไอคอนข้างหน้า
                                  // prefixIcon: Icon(Icons.add),
                                  fillColor: Colors.white70,
                                  filled: true,
                                  labelText: "ชื่อ",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                            )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                          child: SizedBox(
                              width: 170, //ประกาศเต็มจอ
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกนามสกุล';
                                  }
                                },
                                controller: _ctrllname,
                                decoration: InputDecoration(
                                    fillColor: Colors.white70,
                                    filled: true,
                                    labelText: "นามสกุล",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                              width: double.infinity,
                              child: TextFormField(
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length != 10) {
                                      return 'กรุณากรอกเบอร์โทรศัพท์ให้ครบถ้วน';
                                    }
                                  },
                                  controller: _ctrltel,
                                  decoration: InputDecoration(
                                      fillColor: Colors.white70,
                                      filled: true,
                                      labelText: "เบอร์โทรศัพท์",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))))),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: SizedBox(
                              width: double.infinity,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกอีเมล';
                                  }
                                },
                                controller: _ctrlUsername,
                                decoration: InputDecoration(
                                    fillColor: Colors.white70,
                                    filled: true,
                                    label: Text("อีเมล"),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกรหัส';
                                  }
                                },
                                controller: _ctrlPassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                    fillColor: Colors.white70,
                                    // ขยับตัวรับข้อความใน กล่องขยับไปนิดหนึ่ง
                                    filled: true,
                                    labelText: "รหัสผ่าน",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกยืนยันรหัสผ่าน';
                                  }
                                },
                                controller: _ctrlFPassword,
                                // ซ่อนข้อความ
                                obscureText: true,
                                decoration: InputDecoration(
                                    fillColor: Colors.white70,
                                    filled: true,
                                    // hintText แสดงข้อความแบบขึ้นมา ต้องพิมถึงหาย
                                    labelText: "ยืนยันรหัสผ่าน",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Container(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton.icon(
                                  icon: Icon(Icons.app_registration_outlined),
                                  label: Text("สมัครสมาชิก"),
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
                                    doRegister();
                                  }),
                            ),
                          )
                        ],
                      )),
                ],
              )),
        ));
  }
}
