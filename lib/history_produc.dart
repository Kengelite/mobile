import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_provider.dart';

class HistoryProduct extends StatefulWidget {
  const HistoryProduct({super.key});

  @override
  State<HistoryProduct> createState() => _HistoryProductState();
}

class _HistoryProductState extends State<HistoryProduct> {
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

  Widget myDivider() {
    return Divider(
      height: 7.0,
      color: Colors.grey.shade800,
    );
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
      var rs = await apiProvider.data_usecar(emailname.toString());
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
            subtitle: Text("คะแนนสะสม: ${objcustomer[index]['point']}",
                style: TextStyle(fontSize: 16, fontFamily: 'Kodchasan')),
            trailing: Text(
                "จำนวนเงิน : ${objcustomer[index]['price'].toString()}",
                style: TextStyle(fontSize: 14, fontFamily: 'Kodchasan')),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการใช้งาน'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            // คำนวณอัตโนมัติ
            child: Container(
                height: MediaQuery.of(context).size.height, child: data()),
          ),
          // Text("${objcustomer[]['fname']}")
        ],
      )),
    );
  }
}
