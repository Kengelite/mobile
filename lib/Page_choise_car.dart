import 'dart:convert';

import 'package:flutter/material.dart';
import 'api_provider.dart';
import 'map.dart';
import 'package:url_launcher/url_launcher.dart';

class Page_choise_carwash extends StatefulWidget {
  final String data, name_location;
  final double start_lati, start_longti;
  const Page_choise_carwash(
      {required this.data,
      required this.name_location,
      required this.start_lati,
      required this.start_longti});

  @override
  State<Page_choise_carwash> createState() => _Page_choise_carwashState();
}

class _Page_choise_carwashState extends State<Page_choise_carwash> {
  String receivedData_id = '';
  ApiProvider apiProvider = ApiProvider();
  late List resul_data_car = [];
  String name_branch = '';
  late double start_lati;
  late double start_longti;
  @override
  void initState() {
    super.initState();
    receivedData_id = widget.data;
    name_branch = widget.name_location;
    start_lati = widget.start_lati;
    start_longti = widget.start_longti; // Fix the typo here
    data_car();
  }

  void openMap(double startLatitude, double startLongitude,
      double destinationLatitude, double destinationLongitude) async {
    // String mapUrl =
    // 'https://www.google.com/maps/dir/?api=1&origin=$startLatitude,$startLongitude&destination=$destinationLatitude,$destinationLongitude';
    Uri mapUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=$startLatitude,$startLongitude&destination=$destinationLatitude,$destinationLongitude');
    if (!await launchUrl(mapUrl)) {
      print('Could not launch $mapUrl');
      throw Exception('Could not launch $mapUrl');
    } else {
      print('Error getting location: $mapUrl');
      // throw 'Could not launch $mapUrl';
    }
  }

  data_car() async {
    try {
      var rs = await apiProvider.branch_data_car(receivedData_id.toString());
      if (rs.statusCode == 200) {
        var jsonResponse = json.decode(rs.body);

        if (jsonResponse['success'] == true) {
          print(jsonResponse['results'][0]['idcar_wash']);
          // resul_data_car.add('${jsonResponse['results'][0]['idcar_wash']}');
          // print(jsonResponse['data'][0]['fname']);
          resul_data_car = jsonResponse['results'];
          setState(() {
            // objcustomer['fname'] = jsonResponse['data'][0]['fname'].toString();
            // objcustomer['lname'] = jsonResponse['data'][0]['lname'].toString();
            // objcustomer['money'] = NumberFormat('#,###.##')
            //     .format(double.parse(jsonResponse['data'][0]['money']));
            // objcustomer['point'] = NumberFormat('#,###.##') latitude longitude
            //     .format(double.parse(jsonResponse['data'][0]['point']));
            // objcustomer['img'] = jsonResponse['data'][0]['img'].toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'สาขา$name_branch',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Kodchasan',
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: resul_data_car.length,
        // prototypeItem: ListTile(
        //   title: Text(resul_data_car[0]),
        // ),
        itemBuilder: (context, index) {
          Map<String, dynamic> data_c = resul_data_car[index];
          String id_car = '${data_c['idcar_wash']}';
          String id_status = '';

          if (data_c['status'] == '1') {
            id_status = 'ว่าง';
          } else if (data_c['status'] == '2') {
            id_status = 'กำลังใช้งาน';
          } else {
            id_status = 'ไม่พร้อมใช้งาน';
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                // color: Colors.blue.shade200,
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(blurRadius: 10, color: Colors.grey.shade700),
                ],
              ),
              child: ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 60,
                          height: 50,
                          child: Image.asset('images/profile_start.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'washcar No.${index + 1}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Kodchasan',
                                        color: Colors.black),
                                  ),
                                  Text(
                                    '$id_status',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'Kodchasan',
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                            child: Container(
                              width: 20,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  openMap(
                                      start_lati,
                                      start_longti,
                                      double.parse(data_c['latitude']),
                                      double.parse(data_c['longitude']));
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => MapSample(
                                  //         li: double.parse(data_c['latitude']),
                                  //         long: double.parse(
                                  //             data_c['longitude'])),
                                  //   ),
                                  // );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade400,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  shadowColor: Colors.grey.shade200,
                                  elevation: 8,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'เส้นทาง',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Kodchasan',
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
