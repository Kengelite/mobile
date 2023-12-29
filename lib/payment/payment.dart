import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_provider.dart';

class payment_money extends StatefulWidget {
  const payment_money({super.key});

  @override
  State<payment_money> createState() => _payment_moneyState();
}

class _payment_moneyState extends State<payment_money> {
  GlobalKey _globalKey = GlobalKey();
  String? emailname;
  late SharedPreferences prefs;
  final List<Widget> myList_location = [];
  ApiProvider apiProvider = ApiProvider();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _ctrlamount = TextEditingController();
  // ปิดแป้นพิม
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    _requestPermission();
  }

  getUser() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      emailname = prefs.getString('username')!;
    });
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    // _toastInfo(info);
  }

  _saveScreen() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
        as FutureOr<ByteData?>);
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);
      _toastInfo(result.toString());
    }
  }

  _toastInfo(String info) {
    print(info);
    Fluttertoast.showToast(
        msg: "บันทึกรูปสำเร็จ", toastLength: Toast.LENGTH_LONG);
  }

  getapi_qrcode() async {
    myList_location.clear();
    print(_ctrlamount.text.toString());
    // if (_formKey.currentState!.validate()) {
    try {
      var rs = await apiProvider.create_qrcode_payment(
          _ctrlamount.text.toString(), emailname!.toString());
      if (rs.statusCode == 200) {
        // แปลงเป็น json
        print(json.decode(rs.body));
        var jsonResponse = await json.decode(rs.body);
        // print(jsonResponse['data'][0]['name']);
        if (jsonResponse['ok'] == true) {
          // pushReplacement ไม่ให้สามารถย้อนกลับมาได้
          // เก็บค่าข้อมุล
          print(jsonResponse['data']['referenceNo']);
          print(jsonResponse['data']['qrcode']);
          myList_location.add(data_numberqr_code(
              jsonResponse['data']['qrcode'], _ctrlamount.text.toString()));
          // setStringname(jsonResponse['data'][0]['name']);
          setState(() {});
        } else {
          // ยังทำไม่ได้
          print('มีบางอย่างผิดพลาด');
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('มีบางอย่างผิดพลาด'),
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
    // }
  }

  Widget data_numberqr_code(String number_qr, String amount_total) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: RepaintBoundary(
              // เอาจากตรงนี้ที่จะนำไปบันทก
              key: _globalKey,
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        "Wash Car",
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Kodchasan',
                            color: Colors.black),
                      ),
                      Container(
                        width: 200,
                        height: 200,
                        color: Colors.white,
                        child: QrImageView(
                          data: number_qr,
                          // data: "washcar1",
                          // '00020101021230830016A0000006770101120115010556006812748021800000023051903559203180000000WESDSS55222530376454041.105802TH5910GBPrimePay63045E7F',
                          version: QrVersions.auto,
                          size: 200.0,
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: const Size(
                              100,
                              100,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          "จำนวนเงิน  ${amount_total}  บาท",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Kodchasan',
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
            child: ElevatedButton(
              onPressed: _saveScreen,
              // () => saveQRCode(context),
              child: Text('บันทึกรูปภาพ',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Kodchasan')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text(
              "**กรณีเกิดเกินเวลาที่กำหนด จะไม่สามารถเติมเข้าระบบได้**",
              style: TextStyle(
                  fontSize: 12, fontFamily: 'Kodchasan', color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("เติมเงิน"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: Form(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text("ระบุยอดเงิน",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: 'Kodchasan')),
                        ),
                        Expanded(
                            child: TextFormField(
                          focusNode: _focusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'use 30-5,000.';
                            }
                          },
                          controller: _ctrlamount,
                          decoration: InputDecoration(
                            // fillColor: Colors.white70,
                            // filled: true,

                            hintText: "30-5000",
                            label: Text(
                              "",
                              textAlign: TextAlign.right,
                            ),
                            // border: OutlineInputBorder(
                            //     borderRadius: BorderRadius.circular(5.0))
                          ),
                        )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Container(
                            child: ElevatedButton(
                              onPressed: () {
                                _focusNode.unfocus(); // ปิดแป้นพิมพ์
                                // setState(() {});
                                getapi_qrcode();
                              },
                              // () => saveQRCode(context),
                              child: Text('ยืนยัน',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontFamily: 'Kodchasan')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    child: Column(children: myList_location)
                    // child: Column(
                    //   children: <Widget>[
                    // Container(
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: <Widget>[
                    //         Text(
                    //           "เลือกช่องทางการชำระเงิน",
                    //           style: TextStyle(
                    //               fontSize: 20,
                    //               color: Colors.black,
                    //               fontFamily: 'Kodchasan'),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    // Container(
                    //   width: double.maxFinite,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(10.0),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: <Widget>[
                    //         ClipRRect(
                    //           borderRadius:
                    //               BorderRadius.circular(20), // Image border
                    //           child: SizedBox.fromSize(
                    //             size: Size.fromRadius(48), // Image radius
                    //             child: Image.asset('images/krungthai.png',
                    //                 fit: BoxFit.cover),
                    //           ),
                    //         ),
                    //         ClipRRect(
                    //           borderRadius:
                    //               BorderRadius.circular(20), // Image border
                    //           child: SizedBox.fromSize(
                    //             size: Size.fromRadius(48), // Image radius
                    //             child: Image.asset('images/krungthai.png',
                    //                 fit: BoxFit.cover),
                    //           ),
                    //         ),
                    //         Container(
                    //           width: 110,
                    //           height: 100,
                    //           child: Text("พร้อมเพย์"),
                    //           decoration: BoxDecoration(
                    //               color: Colors.green.shade900,
                    //               borderRadius: BorderRadius.circular(5)),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // )
                    //   ],
                    // ),
                    ),
              )
            ],
          ),
        ));
  }
}
