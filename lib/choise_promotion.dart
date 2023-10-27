import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Choise_promotion extends StatefulWidget {
  const Choise_promotion({super.key});

  @override
  State<Choise_promotion> createState() => _Choise_promotionState();
}

class _Choise_promotionState extends State<Choise_promotion> {
  Widget myDivider() {
    return Divider(
      height: 5.0,
      color: Colors.grey.shade800,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('โปรโมชันทั้งมหด')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  'คะแนนสะสมทั้งหมด',
                  style: TextStyle(fontSize: 18, fontFamily: 'Kodchasan'),
                  textAlign: TextAlign.left,
                )),
                Expanded(
                    child: Text(
                  '110 คะแนน',
                  style: TextStyle(fontSize: 18, fontFamily: 'Kodchasan'),
                  textAlign: TextAlign.right,
                ))
              ],
            ),
            myDivider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Container(
                child: Text(
                  'คุณสามารถใช้คะแนนในการเพิ่มเวลา หรือใช้เป็นส่วนลดได้ 1 รายการ',
                  style: TextStyle(fontSize: 12, fontFamily: 'Kodchasan'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Container(
                height: 50,
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                          // borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10, color: Colors.grey.shade700),
                          ],
                        ),
                        child: Text(
                          'น้ำ',
                          style:
                              TextStyle(fontSize: 18, fontFamily: 'Kodchasan'),
                        )),
                    Container(
                      child: Column(
                        children: [
                          Container(
                              alignment: FractionalOffset.topLeft,
                              child: Text(
                                'ใช้เป็นส่วนลด',
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Kodchasan'),
                              )),
                          Container(
                              child: Text(
                            'โปรดใช้ก่อน 19.11.2022',
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'Kodchasan'),
                          )),
                        ],
                      ),
                    ),
                    Container(
                      child: Expanded(
                          child: Text(
                        '10 บาท',
                        style: TextStyle(fontSize: 18, fontFamily: 'Kodchasan'),
                        textAlign: TextAlign.right,
                      )),
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
