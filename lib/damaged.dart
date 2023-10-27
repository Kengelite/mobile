import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class DamagedPage extends StatefulWidget {
  const DamagedPage({super.key});

  @override
  State<DamagedPage> createState() => _DamagedPageState();
}

class _DamagedPageState extends State<DamagedPage> {
  TextEditingController feedbackController = TextEditingController();
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
