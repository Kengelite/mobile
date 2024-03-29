import 'dart:convert';

import 'package:finalproject/api_provider.dart';
import 'package:finalproject/home.dart';
import 'package:finalproject/home_menu.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App_test extends StatefulWidget {
  final double? credit;
  final String? id_carname;
  final int? id_promotion;
  final int? credit_promotion;
  // const App_test({required this.credit, required this.id_carname});
  App_test(
      {Key? key,
      this.credit,
      this.id_carname,
      this.id_promotion,
      this.credit_promotion})
      : super(key: key);

  @override
  State<App_test> createState() => _App_testState();
}

class _App_testState extends State<App_test> {
  late FirebaseDatabase rtdb;
  late DatabaseReference dbrtdb;

  ApiProvider apiProvider = ApiProvider();

  int credit_show = 0;
  String type = "";
  String? f_data;
  double? credit_dev;
  late SharedPreferences prefs;
  String? emailname;
  double? credit_now;
  String? id_carname_now;
  int x = 0;
  int check_status_now = 0;
  int x_controller = 0;
  int? id_promotion_now;
  int? credit_promotion_now;
  String? name_fb;
  int check_send_data = 0;
  int? credit_start;
  int? credit_water;
  int? credit_foam;
  int? credit_wind;
  int? credit_lastcredit;
  int credit_show_old = 0;
  int state_open = 0;
  int check_send_now = 0;
  DatabaseReference? _databaseReference;
  // Query refQ = FirebaseDatabase.instance.ref().child("box1");
  @override
  void initState() {
    super.initState();
    initializeFirebase();
    getUser();
    setState(() {
      credit_now = widget.credit;
      id_carname_now = widget.id_carname;
      id_promotion_now = widget.id_promotion;
      credit_promotion_now = widget.credit_promotion;
      name_fb = '/box$id_carname_now/credit_balance';
    });

    print(credit_promotion_now);
    print(name_fb);
  }

  getUser() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      emailname = prefs.getString('username')!;
      credit_dev = double.parse(prefs.getString('credit_dev')!);
    });
  }

  void initializeFirebase() async {
    // await Firebase.initializeApp();
    // final firebaseApp = Firebase.app();
    // rtdb = FirebaseDatabase.instanceFor(
    //     app: firebaseApp,
    //     databaseURL:
    //         'https://projectjop-86653-default-rtdb.asia-southeast1.firebasedatabase.app/');
    // print("Firebase initialized");
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
          // options: DefaultFirebaseOptions.currentPlatform,
          );

      DatabaseReference ref_controller_check =
          FirebaseDatabase.instance.ref('/box$id_carname_now/error_state');
      Stream<DatabaseEvent> stream_controller_check =
          ref_controller_check.onValue;
      stream_controller_check.listen((DatabaseEvent event_check) async {
        print('Event Type: ${event_check.type}'); // DatabaseEventType.value;
        print('Snapshot: ${event_check.snapshot.value}'); // DataSnapshot

        if (event_check.snapshot.value == 1) {
          // f_data = (event.snapshot.value).toString();
          print("helloworld");
          await docheck_success_last();
        }
        // print(f_data);
      });

      // ทำอย่างอื่นที่ต้องการเมื่อ Firebase ถูกเริ่มต้น
      DatabaseReference ref = FirebaseDatabase.instance.ref(name_fb);
//     // DatabaseEvent event = await ref.once();
//     // print(event.snapshot.value);
      Stream<DatabaseEvent> stream = ref.onValue;
      print("asasasasa");
// // Subscribe to the stream!
      stream.listen((DatabaseEvent event) {
        print('Event Type: ${event.type}'); // DatabaseEventType.value;
        print('Snapshot: ${event.snapshot.value}'); // DataSnapshot

        if (x == 0) {
          // f_data = (event.snapshot.value).toString();
          try {
            credit_start = int.parse(event.snapshot.value
                .toString()); // Parsing integer safely with toString()
            x++;
          } catch (e) {
            print('Error parsing integer: $e');
            // Handle the error or set a default value for credit_start
          }
          x++;
        }
        setState(() {
          credit_show = int.parse(event.snapshot.value.toString());
          print(check_send_data);
          if (credit_show == 0) {
            check_send_data += 1;
            print("heelolll");
            if (check_send_now == 0) {
              docheck_success();
            }
          }
          // var value = credit_show;
          // if (id_promotion_now != 0) {
          //   credit_show = credit_show! + credit_promotion_now!;
          // }
        });

        // print(f_data);
      });

// working_now
      DatabaseReference ref_controller =
          FirebaseDatabase.instance.ref('/box$id_carname_now/working_now');
      Stream<DatabaseEvent> stream_controller = ref_controller.onValue;
      stream_controller.listen((DatabaseEvent event) {
        print('Event Type: ${event.type}'); // DatabaseEventType.value;
        print('Snapshot: ${event.snapshot.value}'); // DataSnapshot

        if (x_controller == 0) {
          // f_data = (event.snapshot.value).toString();
          try {
            type = event.snapshot.value
                .toString(); // Parsing integer safely with toString()
            x_controller++;
          } catch (e) {
            print('Error parsing integer: $e');
            // Handle the error or set a default value for credit_start
          }
          x_controller++;
        }
        setState(() {
          type = event.snapshot.value.toString();
        });

        // print(f_data);
      });

      DatabaseReference ref_controller_water =
          FirebaseDatabase.instance.ref('/credit_water');
      Stream<DatabaseEvent> stream_controller_water =
          ref_controller_water.onValue;
      stream_controller_water.listen((DatabaseEvent event_water) {
        print('Event Type: ${event_water.type}'); // DatabaseEventType.value;
        print('Snapshot: ${event_water.snapshot.value}'); // DataSnapshot
        credit_water = int.parse(event_water.snapshot.value.toString());

        // print(f_data);
      });

      DatabaseReference ref_controller_foam =
          FirebaseDatabase.instance.ref('/credit_foam');
      Stream<DatabaseEvent> stream_controller_foam =
          ref_controller_foam.onValue;
      stream_controller_foam.listen((DatabaseEvent event_foam) {
        print('Event Type: ${event_foam.type}'); // DatabaseEventType.value;
        print('Snapshot: ${event_foam.snapshot.value}'); // DataSnapshot
        credit_foam = int.parse(event_foam.snapshot.value.toString());

        // print(f_data);
      });

      DatabaseReference ref_controller_wind =
          FirebaseDatabase.instance.ref('/credit_wind');
      Stream<DatabaseEvent> stream_controller_wind =
          ref_controller_wind.onValue;
      stream_controller_wind.listen((DatabaseEvent event_wind) {
        print('Event Type: ${event_wind.type}'); // DatabaseEventType.value;
        print('Snapshot: ${event_wind.snapshot.value}'); // DataSnapshot
        credit_wind = int.parse(event_wind.snapshot.value.toString());

        // print(f_data);
      });

      DatabaseReference ref_controller_lastcredit =
          FirebaseDatabase.instance.ref('/box$id_carname_now/last_credit');
      Stream<DatabaseEvent> stream_controller_lastcredit =
          ref_controller_lastcredit.onValue;
      stream_controller_lastcredit.listen((DatabaseEvent event_lastcredit) {
        print(
            'Event Type: ${event_lastcredit.type}'); // DatabaseEventType.value;
        print('Snapshot: ${event_lastcredit.snapshot.value}'); // DataSnapshot
        credit_lastcredit =
            int.parse(event_lastcredit.snapshot.value.toString());

        // print(f_data);
      });
    } catch (e) {
      print("Error initializing Firebase: $e");
    }
  }

  docheck_success_last() async {
    try {
      setState(() {
        check_send_now = 1;
      });

      print("check_send_data5555 => $credit_lastcredit");
      var price = credit_start! - credit_lastcredit!;
      if (id_promotion_now != 0) {
        print("dsdsdssasasa555");
        price -= credit_promotion_now!;
      }
      print("credit_start = >>> " + credit_start.toString());
      print("price = >>> " + price.toString());
      if (price > 0) {
        print("price = >>>ss ");
        var rs = await apiProvider.send_use_carwash(
            emailname.toString(),
            price.toString(),
            id_promotion_now.toString(),
            id_carname_now.toString(),
            credit_show.toString(),
            1);
        if (rs.statusCode == 200) {
          // แปลงเป็น json
          print(json.decode(rs.body));
          var jsonResponse = await json.decode(rs.body);
          // print(jsonResponse['data'][0]['name']);
          if (jsonResponse['ok'] == true) {
            print("oh");
            // setState(() {
            //   check_send_data = 0;
            // });
            var rs = await apiProvider.end_use_carwash(
              emailname.toString(),
              id_carname_now.toString(),
              2,
              id_promotion_now.toString(),
            );
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('ขอบคุณทีใช้บริการครับ'),
                // content: const Text('AlertDialog description'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>
                        // {Navigator.of(context).pop()},
                        Navigator.push(
                            context,
                            // App_test
                            MaterialPageRoute(
                                builder: (context) => Home_menu())),
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
      } else {
        print("Server Errorsasasa");
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('ขอบคุณทีใช้บริการครับ'),
            // content: const Text('AlertDialog description'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    // {Navigator.of(context).pop()},
                    Navigator.push(
                        context,
                        // App_test
                        MaterialPageRoute(builder: (context) => Home_menu())),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  docheck_success() async {
    try {
      // setState(() {
      //   check_send_data += 1;
      // });
      DatabaseReference ref_controller_lastcredit =
          FirebaseDatabase.instance.ref('/credit_lastcredit');
      Stream<DatabaseEvent> stream_controller_lastcredit =
          ref_controller_lastcredit.onValue;
      stream_controller_lastcredit.listen((DatabaseEvent event_lastcredit) {
        print(
            'Event Type: ${event_lastcredit.type}'); // DatabaseEventType.value;
        print('Snapshot: ${event_lastcredit.snapshot.value}'); // DataSnapshot
        credit_lastcredit =
            int.parse(event_lastcredit.snapshot.value.toString());

        // print(f_data);
      });
      print("check_send_data => $check_send_data");
      var price = credit_start! - credit_show!;
      if (id_promotion_now != 0) {
        print("dsdsdssasasa555");
        price -= credit_promotion_now!;
      }
      if (price > 0) {
        print("dsdsdsdsdsdsdsdsds");
        var rs = await apiProvider.send_use_carwash(
            emailname.toString(),
            price.toString(),
            id_promotion_now.toString(),
            id_carname_now.toString(),
            credit_show.toString(),
            check_send_data);
        if (rs.statusCode == 200) {
          // แปลงเป็น json
          print(json.decode(rs.body));
          var jsonResponse = await json.decode(rs.body);
          // print(jsonResponse['data'][0]['name']);
          if (jsonResponse['ok'] == true) {
            print("oh");
            // setState(() {
            //   check_send_data = 0;
            // });
            var rs = await apiProvider.end_use_carwash(
              emailname.toString(),
              id_carname_now.toString(),
              2,
              id_promotion_now.toString(),
            );
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('ขอบคุณทีใช้บริการครับ'),
                // content: const Text('AlertDialog description'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>
                        // {Navigator.of(context).pop()},
                        Navigator.push(
                            context,
                            // App_test
                            MaterialPageRoute(
                                builder: (context) => Home_menu())),
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
      } else {
        var rs = await apiProvider.end_use_carwash(
          emailname.toString(),
          id_carname_now.toString(),
          check_send_data,
          id_promotion_now.toString(),
        );
        if (rs.statusCode == 200) {
          // แปลงเป็น json
          print(json.decode(rs.body));
          var jsonResponse = await json.decode(rs.body);
          // print(jsonResponse['data'][0]['name']);
          if (jsonResponse['ok'] == true) {
            print("oh");
            // setState(() {
            //   check_send_data = 0;
            // });
            var rs = await apiProvider.end_use_carwash(
              emailname.toString(),
              id_carname_now.toString(),
              2,
              id_promotion_now.toString(),
            );
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('ขอบคุณทีใช้บริการครับ'),
                // content: const Text('AlertDialog description'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>
                        // {Navigator.of(context).pop()},
                        Navigator.push(
                            context,
                            // App_test
                            MaterialPageRoute(
                                builder: (context) => Home_menu())),
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
        }
      }
    } catch (error) {
      print(error);
    }
  }

  docheck(String ctl) async {
    try {
      if (ctl == type && state_open == 1) {
        var rs =
            await apiProvider.controller_box("0", id_carname_now.toString());
        if (rs.statusCode == 200) {
          // แปลงเป็น json
          print(json.decode(rs.body));
          var jsonResponse = await json.decode(rs.body);
          // print(jsonResponse['data'][0]['name']);
          if (jsonResponse['ok'] == true) {
            print("oh");
            setState(() {
              state_open = 0;
              type = "";
            });
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
                title: const Text('หยุดการทำงาน'),
                // content: const Text('AlertDialog description'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    // Navigator.push(
                    //     context,
                    //     // App_test
                    //     MaterialPageRoute(
                    //         builder: (context) => App_test(
                    //             credit: credit_now, id_carname: id_carname_now))),
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
      } else if (type == "0") {
        var rs =
            await apiProvider.controller_box(ctl, id_carname_now.toString());
        if (rs.statusCode == 200) {
          // แปลงเป็น json
          print(json.decode(rs.body));
          var jsonResponse = await json.decode(rs.body);
          // print(jsonResponse['data'][0]['name']);
          if (jsonResponse['ok'] == true) {
            print("oh");
            setState(() {
              state_open = 1;
              type = ctl;
            });
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
                    onPressed: () => {Navigator.of(context).pop()},
                    // Navigator.push(
                    //     context,
                    //     // App_test
                    //     MaterialPageRoute(
                    //         builder: (context) => App_test(
                    //             credit: credit_now, id_carname: id_carname_now))),
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
      } else if (ctl != type && state_open == 1) {
        String txt_alert = "";
        if (type == "1") {
          setState(() {
            txt_alert = "น้ำ";
          });
        } else if (type == "2") {
          setState(() {
            txt_alert = "โฟม";
          });
        } else {
          setState(() {
            txt_alert = "ลม";
          });
        }
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('กรุณาปิดการทำงานของ $txt_alert'),
            // content: const Text('AlertDialog description'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (type != "0" && state_open == 0) {
        var rs =
            await apiProvider.controller_box(ctl, id_carname_now.toString());
        if (rs.statusCode == 200) {
          // แปลงเป็น json
          print(json.decode(rs.body));
          var jsonResponse = await json.decode(rs.body);
          // print(jsonResponse['data'][0]['name']);
          if (jsonResponse['ok'] == true) {
            print("oh");
            setState(() {
              state_open = 1;
              type = ctl;
            });
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
                    onPressed: () => {Navigator.of(context).pop()},
                    // Navigator.push(
                    //     context,
                    //     // App_test
                    //     MaterialPageRoute(
                    //         builder: (context) => App_test(
                    //             credit: credit_now, id_carname: id_carname_now))),
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
      } else {}
    } catch (error) {
      print(error);
    }
  }

  void status_error() async {
    var rs = await apiProvider.controller_box_error(id_carname_now.toString());
    if (rs.statusCode == 200) {
      // แปลงเป็น json
      print(json.decode(rs.body));
      var jsonResponse = await json.decode(rs.body);
      // print(jsonResponse['data'][0]['name']);
      if (jsonResponse['ok'] == true) {
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
                      Text("ตู้ไม่พร้อมใช้งาน",
                          style:
                              TextStyle(fontSize: 22, fontFamily: 'Kodchasan'))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("กรุณาแจ้งเจ้าหน้าที่",
                          style:
                              TextStyle(fontSize: 22, fontFamily: 'Kodchasan'))
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
                      onPressed: () {
                        setState(() {
                          check_send_data += 1;
                        });

                        if (check_send_data == 1) {
                          docheck_success();
                        }
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
                      onPressed: () {
                        setState(() {
                          check_send_data = 0;
                        });
                        Navigator.of(context).pop();
                      },
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
    if (credit_start == null) {
      // Return a loading or error state
      return Center(
          child:
              CircularProgressIndicator()); // Replace with your desired widget.
    }
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
                  // SafeArea(
                  //     child: FirebaseAnimatedList(
                  //         query: refQ,
                  //         itemBuilder: (context, snapshot, animation, index) {
                  //           String userString = snapshot.value as String;
                  //           return Text(userString);
                  //         })),
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
                        '${credit_show / credit_dev!}  ฿',
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
                          docheck("1");

                          // Color backgroundColor = Colors.white;
                          // ใส่โค้ดที่คุณต้องการให้ทำงานเมื่อปุ่มถูกแตะ
                          // setState(() {

                          //     type = "";

                          // });

                          // ใส่โค้ดที่คุณต้องการให้ทำงานเมื่อปุ่มถูกแตะ
                          print('น้ำ');
                        },
                        child: Container(
                          width: 150, // ขนาดของปุ่มวงกลม
                          height: 150,
                          decoration: BoxDecoration(
                            color: type == "1" ? Colors.blue : Colors.white,
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
                                color: type == "1" ? Colors.white : Colors.blue,
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
                          docheck("2");
                          // setState(() {
                          //   if (type == "2") {
                          //     type = "";
                          //   } else {
                          //     type = "2";
                          //   }
                          // });
                          // ใส่โค้ดที่คุณต้องการให้ทำงานเมื่อปุ่มถูกแตะ
                          print('โฟม');
                        },
                        child: Container(
                          width: 150, // ขนาดของปุ่มวงกลม
                          height: 150,
                          decoration: BoxDecoration(
                            color: type == "2" ? Colors.blue : Colors.white,
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
                                color: type == "2" ? Colors.white : Colors.blue,
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
                      docheck("3");
                      // setState(() {
                      //   if (type == "3") {
                      //     type = "";
                      //   } else {
                      //     type = "3";
                      //   }
                      // });
                      // ใส่โค้ดที่คุณต้องการให้ทำงานเมื่อปุ่มถูกแตะ
                      print('ลม');
                    },
                    child: Container(
                      width: 150, // ขนาดของปุ่มวงกลม
                      height: 150,
                      decoration: BoxDecoration(
                        color: type == "3" ? Colors.blue : Colors.white,
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
                            color: type == "3" ? Colors.white : Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Column(children: [
                      Text(
                        'น้ำราคา ${credit_water! / credit_dev!} ฿ ต่อ 2 วินาที',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Kodchasan',
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        'โฟมราคา ${credit_foam! / credit_dev!} ฿ ต่อ 2 วินาที',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Kodchasan',
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        'ลมราคา ${credit_wind! / credit_dev!} ฿ ต่อ 2 วินาที',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Kodchasan',
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
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
                            setState(() {
                              check_send_data += 1;
                            });
                            docheck_success();
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
