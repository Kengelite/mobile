import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_provider.dart';

class HistoryPayment extends StatefulWidget {
  const HistoryPayment({super.key});

  @override
  State<HistoryPayment> createState() => _HistoryPaymentState();
}

class _HistoryPaymentState extends State<HistoryPayment> {
  late SharedPreferences prefs;
  String? emailname;
  List objcustomer = [];
  ApiProvider apiProvider = ApiProvider();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      emailname = prefs.getString('username')!;
    });
    getdata();
  }

  getdata() async {
    try {
      var rs = await apiProvider.data_payment(emailname!.toString());
      if (rs.statusCode == 200) {
        var jsonResponse = json.decode(rs.body);
        if (jsonResponse['ok'] == true) {
          print(jsonResponse['data'].length);
          print(jsonResponse['data'].runtimeType);
          setState(() {
            objcustomer = jsonResponse['data'];
            print(objcustomer);
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

  check_type(String nametype) {
    if (nametype == 'Q') {
      return 'QR Code';
    }
  }

  Widget data() {
    if (objcustomer.length == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ไม่พบรายการ',
              style: TextStyle(fontSize: 18, fontFamily: 'Kodchasan'))
        ],
      );
    } else {
      return ListView.builder(
        itemCount: objcustomer.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                "วันที่ ${(objcustomer[index]['create_time'].toString()).substring(0, 10)} ",
                style: TextStyle(fontSize: 20, fontFamily: 'Kodchasan')),
            subtitle: Text(
                "ประเภท: ${check_type(objcustomer[index]['type_payment'])}",
                style: TextStyle(fontSize: 16, fontFamily: 'Kodchasan')),
            trailing: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Text("จำนวนเงิน : ${objcustomer[index]['total'].toString()}",
                      style: TextStyle(fontSize: 14, fontFamily: 'Kodchasan')),
                  Text(
                      "คะแนนสะสม : ${objcustomer[index]['point_payment'].toString()}",
                      style: TextStyle(fontSize: 14, fontFamily: 'Kodchasan')),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการเติมเงิน'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Container(
                height: MediaQuery.of(context).size.height, child: data()),
          ),
          // Text("${objcustomer[]['fname']}")
        ],
      )),
    );
  }
}
