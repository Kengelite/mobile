import 'dart:convert';

import 'package:finalproject/payment/payment.dart';
import 'package:finalproject/show_timeuse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'api_provider.dart';
import 'choise_promotion.dart';
import 'home_menu.dart';

class choise_menu extends StatefulWidget {
  const choise_menu({super.key});

  @override
  State<choise_menu> createState() => _choise_menuState();
}

class _choise_menuState extends State<choise_menu> {
  String qrCodeResult = "ยังไม่ได้สแกน";
  Widget myDivider() {
    return Divider(
      height: 5.0,
      color: Colors.grey.shade800,
    );
  }

  late SharedPreferences prefs;
  ApiProvider apiProvider = ApiProvider();
  String? emailname;
  double? money;
  TextEditingController _ctrlPrice = TextEditingController();
  FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final List<Widget> myList = [];
  String id_promotion = "";
  String id = "";
  @override
  void initState() {
    super.initState();
    // scanQrCode();
    getUser();
    data_promotion("1");
    print(id_promotion);
  }

  Future<void> scanQrCode() async {
    String qrCodeResult = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666", // สีของหน้าสแกน
      "ยกเลิก", // ข้อความปุ่มยกเลิก
      true, // อนุญาตให้เปิดแฟลชไฟ (ถ้ามี)
      ScanMode.QR, // โหมดสแกน QR Code
    );

    if (qrCodeResult != '-1') {
      setState(() {
        this.qrCodeResult = qrCodeResult;

        data_promotion(this.qrCodeResult);
      });
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Home_menu()), // เปลี่ยนไปหน้าอื่น (AnotherPage)
      );
    }
  }

  getUser() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      emailname = prefs.getString('username')!;
      money = double.parse(prefs.getString('money')!);
    });
  }

  data_promotion(String id_branch) async {
    try {
      if (id_branch.contains("washcar")) {
        // ตรวจสอบว่ามี "txt" ในตัวแปร x หรือไม่
        id_branch = id_branch.replaceAll("washcar", "");
        // ตัด "txt" ออกจากตัวแปร x
        print(id_branch);
        var rs = await apiProvider.choise_time_return_data_promotion(id_branch);
        if (rs.statusCode == 200) {
          var jsonResponse = json.decode(rs.body);
          // print(jsonResponse['data']);
          if (jsonResponse['ok'] == true) {
            for (var data in jsonResponse['data']) {
              // setState(() {
              myList.add(map_api(data['ref'], data['name'],
                  data['price'].toString(), data['id_promo'].toString()));
              // });
              setState(() {});
            }
            print(myList);
          } else {
            print('ok != true');
          }
        } else {
          print('error');
        } // พิมพ์ค่า x หลังจากตัด "txt" ออก
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('ข้อมูลไม่ถูกต้องกรุณาแสกนใหม่'),
            // content: const Text('AlertDialog description'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.push(
                    context,
                    // App_test
                    MaterialPageRoute(builder: (context) => Home_menu())),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      // var rs = await apiProvider.choise_time_return_data_promotion("1");
    } catch (error) {
      print(error);
    }
  }

  docheck() async {
    try {
      var rs = await apiProvider.add_use_washcar(
          // qrCodeResult

          emailname!.toString());
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
                        Text("เริ่มทำงาน",
                            style: TextStyle(
                                fontSize: 22, fontFamily: 'Kodchasan'))
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
                                      builder: (context) => App_test()))
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
    } catch (error) {
      print(error);
    }

    // showDialog<String>(
    //   context: context,
    //   builder: (BuildContext context) => AlertDialog(
    //     title: const Text('ยอดเงินไม่เพียงพอ \nกรุณาเติมเงิน'),
    //     // content: const Text('AlertDialog description'),
    //     actions: <Widget>[
    //       TextButton(
    //         onPressed: () => Navigator.pop(context, 'ยืนยัน'),
    //         child: const Text('ยืนยัน'),
    //       ),
    //       TextButton(
    //         onPressed: () => Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 //  QrCodeGenerator payment_money
    //                 // builder: (context) => QrCodeGenerator(
    //                 //       qrData: '1',
    //                 //     )));
    //                 builder: (context) => payment_money())),
    //         child: const Text('เติมเงิน'),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget map_api(String name, String type_name, String price, String id) {
    bool isSelected = id_promotion == id;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            id_promotion = id;
          });
          print(id);
          print(id_promotion);
        },
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Color.fromARGB(255, 180, 180, 180),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
              ),
            ],
            color: id_promotion == id ? Colors.blueAccent : Colors.grey,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$name $qrCodeResult',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Kodchasan',
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Text(
                  '$type_name $price บาท',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Kodchasan',
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 70, 10, 20),
          child: Column(
            children: [
              Container(
                  child: Text(
                'ล้างรถ${money}',
                // ignore: prefer_const_constructors
                style: TextStyle(
                    fontFamily: 'Kodchasan',
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      'โปรโมชั่นสำหรับคุณ',
                      style: TextStyle(fontSize: 18, fontFamily: 'Kodchasan'),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ]),
              ),
              Column(children: myList),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              //   child: Container(
              //       height: 70,
              //       child: ElevatedButton(
              //         onPressed: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => Choise_promotion()));
              //         },
              //         style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.grey.shade100,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10),
              //               side: BorderSide(color: Colors.grey, width: 2),
              //             ),
              //             shadowColor: Colors.grey.shade200,
              //             elevation: 8),
              //         child: Row(
              //           children: [
              //             Text(
              //               'โปรโมชันสำหรับลูกค้าใหม่',
              //               style: TextStyle(
              //                   fontSize: 16,
              //                   fontFamily: 'Kodchasan',
              //                   color: Colors.black),
              //               textAlign: TextAlign.left,
              //             ),
              //             Expanded(
              //               child: Text(
              //                 'ส่วนลด 10 บาท',
              //                 style: TextStyle(
              //                     fontSize: 16,
              //                     fontFamily: 'Kodchasan',
              //                     color: Colors.black),
              //                 textAlign: TextAlign.right,
              //               ),
              //             )
              //           ],
              //         ),
              //       )),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 60.0, 0, 0),
                child: Container(
                    height: 50,
                    width: double.infinity, //ประกาศเต็มจอ
                    child: ElevatedButton(
                      // ใส่ label หรือข้อความที่ต้องการแสดงในปุ่ม
                      child: Text(
                        "ยืนยัน",
                        style: TextStyle(fontSize: 18, fontFamily: 'Kodchasan'),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.blue.shade500,
                        shadowColor: Colors.black,
                        elevation: 10,
                      ),
                      onPressed: () {
                        docheck();
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
