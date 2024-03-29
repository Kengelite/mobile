import 'dart:convert';

import 'package:finalproject/payment/payment.dart';
import 'package:finalproject/show_timeuse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'api_provider.dart';
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
  int check_send_data = 0;
  String? id_carname;
  String code_promotion = "";
  String name_promotion = "";
  String credit_promotion = "";
  @override
  void initState() {
    super.initState();
     scanQrCode();
    getUser();
    // data_promotion("washcar1");
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
      // print(id_branch.contains("washcar"));
      if (id_branch.contains("washcar")) {
        // ตรวจสอบว่ามี "txt" ในตัวแปร x หรือไม่
        id_branch = id_branch.replaceAll("washcar", "");
        // ตัด "txt" ออกจากตัวแปร x
        id_carname = id_branch;
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
        // print("newew");
        Future.delayed(Duration.zero, () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(
                'ข้อมูลไม่ถูกต้องกรุณาแสกนใหม่',
                style: TextStyle(fontSize: 16, fontFamily: 'Kodchasan'),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home_menu(),
                      ),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        });
      }

      // var rs = await apiProvider.choise_time_return_data_promotion("1");
    } catch (error) {
      print(error);
    }
  }

// senddata(var rs){

// }
  docheck() async {
    try {
      var rs;
      if (id_promotion != "") {
        rs = await apiProvider.add_use_washcar(
            // qrCodeResult
            emailname!.toString(),
            id_carname.toString(),
            int.parse(credit_promotion),
            check_send_data);
      } else {
        rs = await apiProvider.add_use_washcar(
            // qrCodeResult
            emailname!.toString(),
            id_carname.toString(),
            0,
            check_send_data);
      }

      if (rs.statusCode == 200) {
        // แปลงเป็น json
        print(json.decode(rs.body));
        var jsonResponse = await json.decode(rs.body);
        // print(jsonResponse['data'][0]['name']);
        if (jsonResponse['ok'] == true) {
          print("oh");
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
                                  builder: (context) {
                                    if (id_promotion != "") {
                                      return App_test(
                                        credit: money,
                                        id_carname: id_carname,
                                        id_promotion: int.parse(id_promotion),
                                        credit_promotion:
                                            int.parse(credit_promotion),
                                      );
                                    } else {
                                      return App_test(
                                        credit: money,
                                        id_carname: id_carname,
                                        id_promotion: 0,
                                        credit_promotion: 0,
                                      );
                                    }
                                  },
                                ),
                              )
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
          if (jsonResponse['txt'] == "money") {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('ยอดเงินไม่เพียงพอ \nกรุณาเติมเงิน'),
                // content: const Text('AlertDialog description'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            //  QrCodeGenerator payment_money
                            // builder: (context) => QrCodeGenerator(
                            //       qrData: '1',
                            //     )));
                            builder: (context) => Home_menu())),
                    child: const Text('ยืนยัน'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            //  QrCodeGenerator payment_money
                            // builder: (context) => QrCodeGenerator(
                            //       qrData: '1',
                            //     )));
                            builder: (context) => payment_money())),
                    child: const Text('เติมเงิน'),
                  ),
                ],
              ),
            );
          } else {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('ตู้ไม่พบใช้งานกรุณาติดต่อเจ้าหน้าที่'),
                // content: const Text('AlertDialog description'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            //  QrCodeGenerator payment_money
                            // builder: (context) => QrCodeGenerator(
                            //       qrData: '1',
                            //     )));
                            builder: (context) => Home_menu())),
                    child: const Text('ยืนยัน'),
                  ),
                ],
              ),
            );
          }
        }
        // if(jsonResponse.length)
      } else {
        print("Server Error");
      }
    } catch (error) {
      print(error);
    }
  }

  Widget map_api(String name, String type_name, String price, String id) {
    bool isSelected = id_promotion == id;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            id_promotion = id;
            code_promotion = name;
            name_promotion = type_name;
            credit_promotion = price;
          });
          // print(id);
          print(id_promotion);
        },
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? Colors.blueAccent : Colors.grey,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Checkbox(
                //   value: isSelected,
                //   onChanged: (bool? newValue) {
                //     setState(() {
                //       isSelected = newValue!;
                //       if (isSelected) {
                //         id_promotion = id;
                //       } else {
                //         id_promotion = ""; // ยกเลิกการเลือก
                //       }
                //     });
                //   },
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$name ',
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
                    '$type_name $price เครดิต${isSelected ? " - เลือกแล้ว" : ""}',
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
      ),
    );
  }

  Widget map_chose(String name, String type_name, String price, String id) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$name ',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Kodchasan',
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$type_name $price เครดิต',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Kodchasan',
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  id_promotion = "";
                  code_promotion = "";
                  name_promotion = "";
                  credit_promotion = "";
                });
              },
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red, // Color for cancel button
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Text(
                      'ยกเลิก',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Kodchasan',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
              // Container(
              //     child: Text(
              //   'ล้างรถ${money}',
              //   // ignore: prefer_const_constructors
              //   style: TextStyle(
              //       fontFamily: 'Kodchasan',
              //       fontSize: 24,
              //       fontWeight: FontWeight.bold),
              // )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      // color: Colors.blue.shade200,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(blurRadius: 10, color: Colors.grey.shade700),
                      ],
                    ),
                    child: Padding(
                      // แถบขวาทั้งหมดในกรอบ
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    'เครดิต',
                                    style: TextStyle(
                                        fontSize: 22, fontFamily: 'Kodchasan'),
                                  ),
                                ),
                                Text(
                                  '$money',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Kodchasan'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 0, 10),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      'โปรโมชั่นที่คุณเลือก',
                      style: TextStyle(fontSize: 18, fontFamily: 'Kodchasan'),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ]),
              ),
              Column(
                children: [
                  if (id_promotion != "")
                    map_chose(code_promotion, name_promotion, credit_promotion,
                        id_promotion),
                ],
              ),

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
                padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 0),
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
                        setState(() {
                          check_send_data += 1;
                        });
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
