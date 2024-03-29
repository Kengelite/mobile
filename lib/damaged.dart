import 'dart:convert';

import 'package:finalproject/api_provider.dart';
import 'package:finalproject/home_menu.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class DamagedPage extends StatefulWidget {
  const DamagedPage({super.key});

  @override
  State<DamagedPage> createState() => _DamagedPageState();
}

class _DamagedPageState extends State<DamagedPage> {
  ApiProvider apiProvider = ApiProvider();
  TextEditingController feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  dosenddata() async {
    print("error");
    try {
      print(feedbackController.text.toString());
      var rs = await apiProvider.addcomment(feedbackController.text.toString());
      if (rs.statusCode == 200) {
        // แปลงเป็น json
        print("error88");
        print(json.decode(rs.body));
        var jsonResponse = await json.decode(rs.body);
        // print(jsonResponse['data'][0]['name']);
        if (jsonResponse['ok'] == true) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home_menu()));
        } else {
          // ยังทำไม่ได้
          print('อีเมลหรือรหัสผ่านไม่ถูกต้อง');
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('อีเมลหรือรหัสผ่านไม่ถูกต้อง'),
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
      print("wwwewe");
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('แจ้งตู้เสียหาย'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: feedbackController,
                  maxLines: 5, // กำหนดจำนวนบรรทัดใน Textarea
                  decoration: InputDecoration(
                    labelText: 'กรอกปัญหาหรือเรื่องร้องเรียน',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String feedback = feedbackController.text;
                    // ส่ง feedback ไปยัง API หรือทำการบันทึกลงฐานข้อมูลตามต้องการ
                    print('Feedback submitted: $feedback');
                    // ล้างข้อมูลใน Textarea
                    dosenddata();
                    feedbackController.clear();
                  },
                  child: Text('ส่งข้อความ'),
                ),
              ],
            ),
          ),
        ));
  }
}
