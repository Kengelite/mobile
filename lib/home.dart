import 'dart:convert';
import 'dart:math';
import 'package:finalproject/fet.dart';
import 'package:finalproject/manual.dart';
import 'package:finalproject/payment/payment.dart';
import 'package:finalproject/show_timeuse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_utils/google_maps_utils.dart';
import 'Page_choise_car.dart';
// import 'package:location/location.dart';
// import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  // required this.data const HomePage({super.key});
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Location location = new Location();
  late SharedPreferences prefs;
  String? emailname;
  Map objcustomer = {};
  ApiProvider apiProvider = ApiProvider();
  late Position position;
  late double latitude;
  late double longitude;
  late Point startLocation;
  late Point endLocation;
  final List<Widget> myList_location = [];
  bool _isLoading = true;
  bool _isLoadingmap = true;
// = LatLng(13.724329, 100.537527)
  @override
  void initState() {
    super.initState();
    getUser();
  }

  // @override
  // void dispose() {
  //   // ยกเลิกหรือยุติ timer หรือ animation ที่นี่
  //   super.dispose();
  // }

// ดึงข้อมูล
  getUser() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      emailname = prefs.getString('username')!;
    });
    data_customer();
    getlocation();
  }

  getlocation() async {
    // openAppSettings();

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      latitude = position.latitude;
      longitude = position.longitude;
      print('Latitude: $latitude, Longitude: $longitude');

      // Location location = Location();
      // bool serviceEnabled = await location.serviceEnabled();
      // if (!serviceEnabled) {
      //   serviceEnabled = await location.requestService();
      //   if (!serviceEnabled) {
      //     print('Location services are disabled.');
      //     return;
      //   }
      // }

      // LocationData locationData = await location.getLocation();
      // latitude = locationData.latitude!;
      // longitude = locationData.longitude!;
      // print('Latitude: $latitude, Longitude: $longitude');
    } catch (e) {
      print('Error getting location: $e');
    }
    try {
      print('ละติจูด คือ : ${latitude.toStringAsFixed(7)}');
      print('ลองจิจูด คือ : ${longitude.toStringAsFixed(7)}');
      startLocation = Point(double.parse(latitude.toStringAsFixed(7)),
          double.parse(longitude.toStringAsFixed(7)));
      print('ตำแหน่ง คือ : ${startLocation}');
      var rs = await apiProvider.data_boxcar(longitude, latitude);

      if (rs.statusCode == 200) {
        var jsonResponse_location = json.decode(rs.body);
        // print(jsonResponse_location);
        for (var map in jsonResponse_location['results']) {
          endLocation = Point(
              double.parse(map['latitude']), double.parse(map['longitude']));
          double distance =
              SphericalUtils.computeDistanceBetween(startLocation, endLocation);

// แสดงผลลัพธ์ในหน่วยเมตร
          // print('Distance: ${(distance / 1000).toStringAsFixed(3)} Km.');
          // map.forEach((key, value) {
          //   // ทำอะไรก็ตามที่ต้องการกับ value
          //   print(value);
          // });
          print("${map['id_branch']}");
          if (distance / 1000 < 1) {
            myList_location.add(map_api(
                map['name_branch'],
                (distance / 1000).toStringAsFixed(3) + ' ม.',
                "${map['id_branch']}"));
            setState(() {});
          } else {
            myList_location.add(map_api(
                map['name_branch'],
                (distance / 1000).toStringAsFixed(3) + ' กม.',
                "${map['id_branch']}"));
            setState(() {});
          }
        }
        // _isLoadingmap = false;
        print(myList_location);
      }
      // _isLoading = false;
      // _isLoadingmap = false;
    } catch (error) {
      print(error);
    }
  }

  data_customer() async {
    try {
      var rs = await apiProvider.data_customer(emailname!.toString());
      if (rs.statusCode == 200) {
        var jsonResponse = json.decode(rs.body);

        if (jsonResponse['ok'] == true) {
          print(jsonResponse['data'][0]['money']);
          print(jsonResponse['data'][0]['fname']);
          setState(() {
            objcustomer['fname'] = jsonResponse['data'][0]['fname'].toString();
            objcustomer['lname'] = jsonResponse['data'][0]['lname'].toString();
            objcustomer['money'] = NumberFormat('#,###.##')
                .format(double.parse(jsonResponse['data'][0]['money']));
            objcustomer['point'] = NumberFormat('#,###.##')
                .format(double.parse(jsonResponse['data'][0]['point']));
            objcustomer['img'] = jsonResponse['data'][0]['img'].toString();
          });
          prefs.setString('money',
              (double.parse(jsonResponse['data'][0]['money']).toString()));
          _isLoading = false;
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

  // Widget map_api(String name_location, String km) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
  //     child: Container(
  //       width: double.infinity,
  //       height: 70,
  //       child: ElevatedButton(
  //           onPressed: () {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => MapSample()));
  //           },
  //           style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(16),
  //               ),
  //               shadowColor: Colors.grey.shade200,
  //               elevation: 8),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               // Container(
  //               //   width: 100,
  //               //   height: 50,
  //               //   child: Image.asset('images/book.png'),
  //               // ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     'สาขา${name_location}',
  //                     style: TextStyle(
  //                         fontSize: 16,
  //                         fontFamily: 'Kodchasan',
  //                         color: Colors.black),
  //                     textAlign: TextAlign.right,
  //                   ),
  //                   Text(
  //                     'ระยะทาง ${km}',
  //                     style: TextStyle(
  //                         fontSize: 16,
  //                         fontFamily: 'Kodchasan',
  //                         color: Colors.black),
  //                     textAlign: TextAlign.right,
  //                   ),
  //                 ],
  //               )
  //             ],
  //           )),
  //     ),
  //   );
  // }

  Widget map_api(String name_location, String distance, String id_data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Container(
        width: double.infinity,
        height: 70,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Page_choise_carwash(
                    data: id_data, name_location: name_location),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadowColor: Colors.grey.shade200,
            elevation: 8,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'สาขา$name_location',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Kodchasan',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    'ระยะทาง $distance',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Kodchasan',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
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
        // appBar: AppBar(title: Text("")
        // ),
        body: SingleChildScrollView(
      child: _isLoading // ตรวจสอบว่าข้อมูลกำลังโหลดหรือไม่
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            )
          :
          // อันใหญ่่
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 0),
              child: Column(children: <Widget>[
                Container(
                    height: 160,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 15, 0, 0),
                                child: Container(
                                  width: 70,
                                  height: 50,
                                  child:
                                      Image.asset('images/profile_start.png'),
                                ),
                              ),
                              Text(
                                '${objcustomer['fname']} ${objcustomer['lname']}',
                                style: TextStyle(
                                    fontSize: 22, fontFamily: 'Kodchasan'),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    'ยอดเครดิตคงเหลือ',
                                    style: TextStyle(
                                        fontSize: 22, fontFamily: 'Kodchasan'),
                                  ),
                                ),
                                Text(
                                  '${objcustomer['money']}',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Kodchasan'),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'คะแนนสะสม',
                                  style: TextStyle(
                                      fontSize: 18, fontFamily: 'Kodchasan'),
                                ),
                                Text(
                                  '${objcustomer['point']}',
                                  style: TextStyle(
                                      fontSize: 18, fontFamily: 'Kodchasan'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 100,
                  width: double.infinity,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Container(
                            width: 130,
                            height: 80,
                            // decoration: BoxDecoration(
                            //     color: Colors.green,
                            //     borderRadius: BorderRadius.circular(5),
                            //     boxShadow: [BoxShadow(blurRadius: 3)]),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          //  QrCodeGenerator payment_money
                                          // builder: (context) => QrCodeGenerator(
                                          //       qrData: '1',
                                          //     )));
                                          builder: (context) =>
                                              payment_money()));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    shadowColor: Colors.grey.shade200,
                                    elevation: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 110,
                                      height: 50,
                                      child: Image.asset('images/money.png'),
                                    ),
                                    Text(
                                      'เติมเงิน',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Kodchasan',
                                          color: Colors.black),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 130,
                            height: 80,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          // QrCodeScanner FetchData ManualPage()) App_test

                                          builder: (context) => ManualPage()));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    shadowColor: Colors.grey.shade200,
                                    elevation: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 50,
                                      child: Image.asset('images/book.png'),
                                    ),
                                    Text(
                                      'คู่มือการใช้งาน',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Kodchasan',
                                          color: Colors.black),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(children: myList_location)
                // Padding(
                //     padding: const EdgeInsets.all(0.0),
                //     child: _isLoadingmap // ตรวจสอบว่าข้อมูลกำลังโหลดหรือไม่
                //         ? Center(child: CircularProgressIndicator())
                //         : Column(children: myList_location))
              ]),
            ),
    ));
  }
}
