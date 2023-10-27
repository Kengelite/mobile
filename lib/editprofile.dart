import 'dart:convert';

import 'package:finalproject/api_provider.dart';
import 'package:finalproject/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Profile/profile.dart';
import 'home_menu.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late SharedPreferences prefs;
  String? emailname;
  final Map objcustomer = {};

  TextEditingController _ctrlfname = TextEditingController();

  TextEditingController _ctrllname = TextEditingController();
  TextEditingController _ctrltel = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ApiProvider apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  // ดึงข้อมูล
  getUser() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      emailname = prefs.getString('username')!;
    });
    data_customer();
  }

  data_customer() async {
    try {
      var rs = await apiProvider.data_customer(emailname!.toString());
      if (rs.statusCode == 200) {
        var jsonResponse = json.decode(rs.body);
        if (jsonResponse['ok'] == true) {
          print(jsonResponse['data'][0]['money']);
          setState(() {
            objcustomer['fname'] = jsonResponse['data'][0]['fname'].toString();
            objcustomer['lname'] = jsonResponse['data'][0]['lname'].toString();
            objcustomer['img'] = jsonResponse['data'][0]['img'].toString();
            objcustomer['tel'] = jsonResponse['data'][0]['tel'].toString();

            _ctrlfname =
                TextEditingController(text: objcustomer['fname'].toString());
            _ctrllname =
                TextEditingController(text: objcustomer['lname'].toString());
            _ctrltel =
                TextEditingController(text: objcustomer['tel'].toString());
          });
        } else {
          print('ok != true');
        }
      } else {
        print('error');
      }
    } catch (error) {
      print(error);
    }
  }

  editCustomer() async {
    if (_formKey.currentState!.validate()) {
      try {
        var rs = await apiProvider.editCustomer(_ctrlfname.text,
            _ctrllname.text, emailname!.toString(), _ctrltel.text);
        if (rs.statusCode == 200) {
          print(json.decode(rs.body));
          var jsonRes = await json.decode(rs.body);
          if (jsonRes['ok'] == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('username', (jsonRes['data'][0]['username']));
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('แก้ไขข้อมูลสำเร็จ'),
                // content: const Text('AlertDialog description'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.push(context,  MaterialPageRoute(builder: (context) => Home_menu())),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            alertextbox();
          }
        } else {
          alertextbox();
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
        title: const Text('ข้อมูลไม่ถูกต้อง'),
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
          title: Text("โปรไฟล์"),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 120,
                            child: Image.asset('images/profile_start.png'),
                          ),
                        ]),
                  ),
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

                              // เซ็ตค่่า

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
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Container(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton.icon(
                                  icon: Icon(Icons.app_registration_outlined),
                                  label: Text("แก้ไขข้อมูล"),
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
                                    editCustomer();
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
