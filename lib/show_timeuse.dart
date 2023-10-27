import 'dart:convert';

import 'package:finalproject/api_provider.dart';
import 'package:finalproject/home_menu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class App_test extends StatefulWidget {
  const App_test({super.key});

  @override
  State<App_test> createState() => _App_testState();
}

class _App_testState extends State<App_test> {
  late FirebaseDatabase rtdb;
  ApiProvider apiProvider = ApiProvider();
  String? ph;
  String type = "";
  String? f_data;
  int x = 0;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  void initializeFirebase() async {
    await Firebase.initializeApp();
    final firebaseApp = Firebase.app();
    rtdb = FirebaseDatabase.instanceFor(
        app: firebaseApp,
        databaseURL:
            'https://projectjop-86653-default-rtdb.asia-southeast1.firebasedatabase.app/');
    print("Firebase initialized");
    // ทำอย่างอื่นที่ต้องการเมื่อ Firebase ถูกเริ่มต้น
    DatabaseReference ref = FirebaseDatabase.instance.ref("credit_balance");
    // DatabaseEvent event = await ref.once();
    // print(event.snapshot.value);
    Stream<DatabaseEvent> stream = ref.onValue;
    // print(event.snapshot.value);
// Subscribe to the stream!
    stream.listen((DatabaseEvent event) {
      print('Event Type: ${event.type}'); // DatabaseEventType.value;
      print('Snapshot: ${event.snapshot.value}'); // DataSnapshot

      if (x == 0) {
        f_data = (event.snapshot.value).toString();
        x++;
      }
      setState(() {
        ph = (event.snapshot.value).toString();
        if (int.parse(ph!) == 0) {
          time_out();
        }
      });
      print(f_data);
    });
  }

  docheck(String ctl) async {
    try {
      var rs = await apiProvider.controller_box(ctl);
      if (rs.statusCode == 200) {
        // แปลงเป็น json
        print(json.decode(rs.body));
        var jsonResponse = await json.decode(rs.body);
        // print(jsonResponse['data'][0]['name']);
        if (jsonResponse['ok'] == true) {
          print("oh");
          // pushReplacement ไม่ให้สามารถย้อนกลับมาได้
          // เก็บค่าข้อมุล
          // setStringname(jsonResponse['data'][0]['name']);
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // prefs.setString(
          //     'username', (jsonResponse['data'][0]['username'].toString()));
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => Home_menu()));
          // ignore: use_build_context_synchronously
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('เริ่มการทำงาน'),
              // content: const Text('AlertDialog description'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      // App_test
                      MaterialPageRoute(builder: (context) => App_test())),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // ยังทำไม่ได้
          // print('อีเมลหรือรหัสผ่านไม่ถูกต้อง');
          // ignore: use_build_context_synchronously
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
        // if(jsonResponse.length)
      } else {
        print("Server Error");
      }
    } catch (error) {
      print(error);
    }
  }

  void time_out() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('ส่งคำตอบ'),
        content: Container(
          width: 180,
          height: 250,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 150,
                    child: Image.asset('images/money.png'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("หมดเวลา",
                      style: TextStyle(fontSize: 22, fontFamily: 'Kodchasan'))
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      // Home_menu
                      onPressed: () => {
                        // Navigator.of(context).pop()
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                //  QrCodeGenerator payment_money
                                // builder: (context) => QrCodeGenerator(
                                //       qrData: '1',
                                //     )));
                                builder: (context) => Home_menu()))
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3f000000),
                              offset: Offset(0, 5),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text('ยืนยัน',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontFamily: 'Kodchasan')),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // title: const Text('เหลือเวลาทำข้อสอบอีก 5 นาที'),
        // content: const Text('AlertDialog description'),
      ),
    );
  }

  void exit_question() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('ส่งคำตอบ'),
        content: Container(
          width: 360,
          height: 280,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 150,
                    child: Image.asset('images/money.png'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ต้องการออกจากหน้าล้างรถหรือไม่ ?",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Kodchasan'))
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home_menu()))
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.green,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3f000000),
                              offset: Offset(0, 5),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text('ยืนยัน',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontFamily: 'Kodchasan')),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => {Navigator.of(context).pop()},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3f000000),
                              offset: Offset(0, 5),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text('ยกเลิก',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontFamily: 'Kodchasan')),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // title: const Text('เหลือเวลาทำข้อสอบอีก 5 นาที'),
        // content: const Text('AlertDialog description'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // ระบุว่าคุณไม่ต้องการให้ Dialog ปิดลงเมื่อผู้ใช้กดปุ่ม "ย้อนกลับ"
          // return false;
          exit_question();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('เริ่มการทำงาน'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${ph} ',
                        style: TextStyle(
                          fontSize: 36,
                          fontFamily: 'Kodchasan',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50), // ระยะห่างระหว่างกรอบและปุ่ม

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          docheck("water");

                          // Color backgroundColor = Colors.white;
                          // ใส่โค้ดที่คุณต้องการให้ทำงานเมื่อปุ่มถูกแตะ
                          setState(() {
                            if (type == "water") {
                              type = "";
                            } else {
                              type = "water";
                            }
                          });

                          // ใส่โค้ดที่คุณต้องการให้ทำงานเมื่อปุ่มถูกแตะ
                          print('น้ำ');
                        },
                        child: Container(
                          width: 150, // ขนาดของปุ่มวงกลม
                          height: 150,
                          decoration: BoxDecoration(
                            color: type == "water" ? Colors.blue : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "น้ำ",
                              style: TextStyle(
                                color: type == "water"
                                    ? Colors.white
                                    : Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20), // ระยะห่างระหว่างปุ่ม
                      InkWell(
                        onTap: () {
                          docheck("foam");
                          setState(() {
                            if (type == "foam") {
                              type = "";
                            } else {
                              type = "foam";
                            }
                          });
                          // ใส่โค้ดที่คุณต้องการให้ทำงานเมื่อปุ่มถูกแตะ
                          print('โฟม');
                        },
                        child: Container(
                          width: 150, // ขนาดของปุ่มวงกลม
                          height: 150,
                          decoration: BoxDecoration(
                            color: type == "foam" ? Colors.blue : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "โฟม",
                              style: TextStyle(
                                color:
                                    type == "foam" ? Colors.white : Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // ระยะห่างระหว่างปุ่ม
                  InkWell(
                    onTap: () {
                      docheck("wind");
                      setState(() {
                        if (type == "wind") {
                          type = "";
                        } else {
                          type = "wind";
                        }
                      });
                      // ใส่โค้ดที่คุณต้องการให้ทำงานเมื่อปุ่มถูกแตะ
                      print('ลม');
                    },
                    child: Container(
                      width: 150, // ขนาดของปุ่มวงกลม
                      height: 150,
                      decoration: BoxDecoration(
                        color: type == "wind" ? Colors.blue : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "ลม",
                          style: TextStyle(
                            color: type == "wind" ? Colors.white : Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 10, 0),
                    child: Container(
                        height: 60,
                        width: double.infinity, //ประกาศเต็มจอ
                        child: ElevatedButton(
                          // ใส่ label หรือข้อความที่ต้องการแสดงในปุ่ม
                          child: Text(
                            "สิ้นสุดการทำงาน",
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Kodchasan'),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.blue.shade500,
                            shadowColor: Colors.black,
                            elevation: 10,
                          ),
                          onPressed: () {
                            // docheck();
                          },
                        )),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
